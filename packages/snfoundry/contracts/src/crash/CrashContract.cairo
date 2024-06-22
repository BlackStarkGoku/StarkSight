use starknet::ContractAddress;

// pub enum GameState {
    //     BetStaked,
    //     ResultDetermined,
    //     Done,
    // }


#[derive(Drop, Serde, Copy, starknet::Store)]
pub struct GameInfo {
    pub state: u8, // Since it was impossible to have an enum here state = 0 tate = 2 -> ResultDetermined, state = 3 -> Done. 
    pub player_address: ContractAddress,
    pub game_id: u256,
    pub stake_amount: u256,

}

#[starknet::interface]
pub trait ICrashContract<TContractState> {
    fn start_game(ref self: TContractState, stake_amount:u256);
    fn request_my_randomness(
        ref self: TContractState,
        seed: u64,
        callback_address: ContractAddress,
        callback_fee_limit: u128,
        publish_delay: u64,
        num_words: u64,
        calldata: Array<felt252>
    );
    fn receive_random_words(
        ref self: TContractState,
        requestor_address: ContractAddress,
        request_id: u64,
        random_words: Span<felt252>,
        calldata: Array<felt252>
    );
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
        next_game_id: u256,
        games: LegacyMap<ContractAddress, GameInfo>,
        randomness_contract_address: ContractAddress,
        min_block_number_storage: u64,
        last_random_storage: felt252,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        let eth_contract_address = ETH_CONTRACT_ADDRESS.try_into().unwrap();
        self.eth_token.write(IERC20CamelDispatcher { contract_address: eth_contract_address });
        //self.greeting.write("Building Unstoppable Apps!!!");
        self.ownable.initializer(owner);
    }

    #[abi(embed_v0)]
    impl CrashContractImpl of ICrashContract<ContractState> {

        fn request_my_randomness(
            ref self: ContractState,
            seed: u64,
            callback_address: ContractAddress,
            callback_fee_limit: u128,
            publish_delay: u64,
            num_words: u64,
            calldata: Array<felt252>
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
            let game_info = GameInfo {state: 0, player_address: player_address, game_id: game_id, stake_amount: stake_amount};
            self.games.write(player_address, game_info);
            }


    }

}
