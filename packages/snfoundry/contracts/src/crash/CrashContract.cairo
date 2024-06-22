use starknet::ContractAddress;

// pub enum GameState {
    //     BetStaked,
    //     ResultDetermined,
    //     Done,
    // }


#[derive(Drop, Serde, Copy, starknet::Store)]
pub struct GameInfo {
    pub state: u8, // Since it was impossible to have an enum here state = 0 tate = 2 -> ResultDetermined, state = 3 -> Done. 
    pub playerAddress: ContractAddress,
    pub id: u256,
}

#[starknet::interface]
pub trait ICrashContract<TContractState> {
    fn start_game(ref self: TContractState, stake_amount:u256);
}

#[starknet::contract]
mod CrashContract {
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    use starknet::{get_caller_address, get_contract_address};
    use super::{ContractAddress, ICrashContract, GameInfo};

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
        fn start_game(ref self: ContractState, stake_amount: u256) {
            let player_address = get_caller_address();
            let game_id = self.next_game_id.read();
            self.next_game_id.write(game_id + 1);
            self
                .eth_token
                .read()
                .transferFrom(player_address, get_contract_address(), stake_amount);
            let game_info = GameInfo {state: 0, playerAddress: player_address, id: game_id};
            self.games.write(player_address, game_info);

            } 
    }
}



// use starknet::ContractAddress;
// use core::starknet::StorageBaseAddress; // Add this line to import StorageBaseAddress

// #[derive(Drop, Serde, Copy, starknet::Store)]
// pub enum GameState {
//     Init,
//     BetStaked,
//     ResultDetermined,
//     Done,
// }

// #[derive(Drop, Serde, Copy, starknet::Store)]
// pub struct GameInfo {
//     pub state: GameState,
//     pub playerAddress: ContractAddress,
//     pub id: u256,

// }


// #[starknet::interface]
// pub trait ICrashContract<TContractState> {
//     fn start_game(ref self: TContractState, stakeAmount: u256);
// }

// #[starknet::contract]
// pub mod CrashContract {
//     use super::{ICrashContract, GameInfo, GameState};
//     use contracts::cryptos::PragmaPrice::IPragmaPrice;
//     use contracts::cryptos::PragmaPrice::PragmaPrice as PragmaPriceComponent;
//     use core::traits::TryInto;
//     use openzeppelin::access::ownable::OwnableComponent;
//     use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
//     use pragma_lib::types::{AggregationMode, DataType, PragmaPricesResponse};
//     use starknet::ContractAddress;
//     use starknet::{get_caller_address, get_contract_address, get_block_timestamp};


//     component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
//     component!(path: PragmaPriceComponent, storage: pragma, event: PragmaPriceEvent);
//     const ETH_CONTRACT_ADDRESS: felt252 =
//         0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7;

//     #[storage]
//     struct Storage {
//         eth_token: IERC20CamelDispatcher,
//         gameIdToState: LegacyMap::<u256, GameState>,
//         nextGameId: u256,
//     }

//     #[constructor]
//     fn constructor(ref self: ContractState) {
//         let eth_contract_address = ETH_CONTRACT_ADDRESS.try_into().unwrap();
//         self.eth_token.write(IERC20CamelDispatcher { contract_address: eth_contract_address });
//     }

//     #[abi(embed_v0)]
//     impl CrashContractImpl of ICrashContract<ContractState> {
//         fn start_game(ref self: ContractState, stakeAmount: u256) {
//             let caller_address = get_caller_address();
//             // first get the funds from the user
//             self
//             .eth_token
//             .read()
//             .transferFrom(caller_address, get_contract_address(), stakeAmount);

//             //Init the GameInfo, then transfer funds to the contract
//             let gameInfo = GameInfo {state: GameStateInit, playerAddress: get_caller_address, id: 1};
//         }
//     }
// }