use starknet::ContractAddress;

// pub enum GameState {
    //     BetStaked,
    //     ResultDetermined,
    //     Done,
    // }


#[derive(Drop, Serde, Copy, starknet::Store)]
pub struct GameInfo {
    pub state: u8, // Since it was impossible to have an enum here state = 0 -> BetStaked, state = 1 -> ResultDetermined, state = 3 -> Game Done. 
    pub player_address: ContractAddress,
    pub game_id: u128,
    pub stake_amount: u256,
    pub reached_multiplier: u256,
}

#[starknet::interface]
pub trait ICrashContract<TContractState> {
    fn get_last_random(self: @TContractState) -> felt252;
    fn start_game(ref self: TContractState, stake_amount:u256);
    fn request_my_randomness(
        ref self: TContractState,
        seed: u64,
        callback_address: ContractAddress,
        callback_fee_limit: u128,
    );
    fn receive_random_words(
        ref self: TContractState,
        requestor_address: ContractAddress,
        request_id: u64,
        random_words: Span<felt252>,
        calldata: Array<felt252>
    );

    fn get_crash_point(ref self: TContractState, player_address : ContractAddress) -> felt252;
    fn settle_game(ref self: TContractState, player_address : ContractAddress, reached_multiplier : u256) -> u8; // return 0 on loss and 1 on win 
    fn cashout (ref self: TContractState, player_address: ContractAddress);
    fn deposit_funds (ref self: TContractState, amount: u256);
}

#[starknet::contract]
mod CrashContract {
    use openzeppelin::access::ownable::OwnableComponent;
    //use pragma_lib::types::Ownable;
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    use pragma_lib::abi::{IRandomnessDispatcher, IRandomnessDispatcherTrait};
    use starknet::{get_block_number, get_caller_address, get_contract_address};
    use super::{ContractAddress, ICrashContract, GameInfo};
    use core::array::{ArrayTrait, SpanTrait};
    use core::traits::{TryInto, Into};
    use core::poseidon::PoseidonTrait;
    use core::hash::{HashStateTrait, HashStateExTrait};

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    const ETH_CONTRACT_ADDRESS: felt252 =
        0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event
    }



    #[storage]
    struct Storage {
        eth_token: IERC20CamelDispatcher,
        next_game_id: u128,
        games: LegacyMap<ContractAddress, GameInfo>,
        randomness_contract_address: ContractAddress,
        min_block_number_storage: u64,
        last_random_storage: felt252,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress, randomness_contract_address: ContractAddress) {
        let eth_contract_address = ETH_CONTRACT_ADDRESS.try_into().unwrap();
        self.eth_token.write(IERC20CamelDispatcher { contract_address: eth_contract_address });
        self.next_game_id.write(0);
        self.min_block_number_storage.write(0);
        self.randomness_contract_address.write(randomness_contract_address);

        //self.greeting.write("Building Unstoppable Apps!!!");
        self.ownable.initializer(owner);
    }

    #[abi(embed_v0)]
    impl CrashContractImpl of ICrashContract<ContractState> {
        
        fn get_last_random(self: @ContractState) -> felt252 {
            let last_random = self.last_random_storage.read();
            return last_random;
        }

        fn request_my_randomness(
            ref self: ContractState,
            seed: u64,
            callback_address: ContractAddress,
            callback_fee_limit: u128,
        ) {
            let randomness_contract_address = self.randomness_contract_address.read();
            let randomness_dispatcher = IRandomnessDispatcher {
                contract_address: randomness_contract_address
            };
            let caller = get_caller_address();
            let compute_fees = randomness_dispatcher.compute_premium_fee(caller);

            self.eth_token
                .read()
                .approve(
                    randomness_contract_address,
                    (callback_fee_limit + compute_fees + callback_fee_limit / 5).into()
                );
            }

            fn receive_random_words(
                ref self: ContractState,
                requestor_address: ContractAddress,
                request_id: u64,
                random_words: Span<felt252>,
                calldata: Array<felt252>
            ) {
                // Have to make sure that the caller is the Pragma Randomness Oracle contract
                let caller_address = get_caller_address();
                assert(
                    caller_address == self.randomness_contract_address.read(),
                    'caller not randomness contract'
                );
                // and that the current block is within publish_delay of the request block
                let current_block_number = get_block_number();
                let min_block_number = self.min_block_number_storage.read();
                assert(min_block_number <= current_block_number, 'block number issue');
    
                let random_word = *random_words.at(0);
    
                self.last_random_storage.write(random_word);
            }


        fn start_game(ref self: ContractState, stake_amount: u256) {
            let player_address = get_caller_address();
            let game_id = self.next_game_id.read();
            self.next_game_id.write(game_id + 1);
            self
                .eth_token
                .read()
                .transferFrom(player_address, get_contract_address(), stake_amount);
            let game_info = GameInfo {state: 0, player_address: player_address, game_id: game_id, stake_amount: stake_amount, reached_multiplier: 0};

            self.games.write(player_address, game_info);
        }
        
        fn get_crash_point(ref self: ContractState, player_address: ContractAddress) -> felt252 {
            let game_info = self.games.read(player_address);
            if (game_info.state != 0) {
                return 0;
            }
            let random_seed = self.last_random_storage.read();
            let game_id: felt252 = self.games.read(player_address).game_id.into();
            let game_seed = random_seed + game_id;
            let h = PoseidonTrait::new().update_with(game_seed).finalize();
            return h;
        }

        fn cashout (ref self: ContractState, player_address: ContractAddress) {
            let game_info = self.games.read(player_address);
            if (game_info.state == 1) {
                self
                    .eth_token
                    .read()
                    .transferFrom(get_contract_address(), player_address, game_info.stake_amount* game_info.reached_multiplier);
            }

        }

        fn settle_game (ref self: ContractState, player_address: ContractAddress, reached_multiplier: u256) -> u8{
            //Settle_game is called after the user is done playing, it takes the user's final multiplier. 
            let game_info = self.games.read(player_address);
            if (game_info.state != 0) {
                return 1;
            }
            let _updated_game_info = GameInfo {state: 1, reached_multiplier : reached_multiplier, ..game_info};
            return 0;
        }

        fn deposit_funds (ref self: ContractState, amount: u256) {
            let funder_address: ContractAddress = get_caller_address();
            self
                .eth_token
                .read()
                .transferFrom(funder_address, get_contract_address(), amount);
        }
    }
}