use starknet::ContractAddress;


#[derive(Copy, Drop, Serde, starknet::Store, Debug)]
pub struct BetInfos {
    id: u64,
    pub total_amount: u256,
    pub total_amount_yes: u256,
    pub total_amount_no: u256,
    begin_date: u64,
    end_date: u64,
    token_price_start: u256,
    reference_token_price: u256,
    vote_date_limit: u64,
}

#[starknet::interface]
pub trait IBitcoinPrice<TContractState> {
    fn vote_yes(ref self: TContractState, amount_eth: u256);
    fn vote_no(ref self: TContractState, amount_eth: u256);
    fn get_current_bet(self: @TContractState) -> BetInfos;
    fn get_own_yes_amount(self: @TContractState) -> u256;
    fn get_own_no_amount(self: @TContractState) -> u256;
    fn claimRewards(ref self: TContractState) -> u256;
    // TODO: owner claim balance of contract
    // TODO: owner set new bet
}

#[starknet::contract]
pub mod BitcoinPrice {
    use contracts::cryptos::PragmaPrice::IPragmaPrice;
use super::IBitcoinPrice;
    use starknet::ContractAddress;
    use openzeppelin::access::ownable::OwnableComponent;
    use contracts::cryptos::PragmaPrice::PragmaPrice as PragmaPriceComponent;
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    use starknet::{get_caller_address, get_contract_address, get_block_timestamp};
    use pragma_lib::types::{AggregationMode, DataType, PragmaPricesResponse};
    use super::BetInfos;
    
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: PragmaPriceComponent, storage: pragma, event: PragmaPriceEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl PragmaPriceImpl = PragmaPriceComponent::PragmaPriceImpl<ContractState>;

    
    const ETH_CONTRACT_ADDRESS: felt252 =
        0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7;

    const KEY :felt252 = 18669995996566340;
    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        PragmaPriceEvent: PragmaPriceComponent::Event,
    }


    #[storage]
    struct Storage {
        eth_token: IERC20CamelDispatcher,
        total_bets: u64,
        current_bet: BetInfos,
        bets_history: LegacyMap::<u64, BetInfos>,
        user_bet_yes_amount: LegacyMap::<ContractAddress, u256>,
        user_bet_no_amount: LegacyMap::<ContractAddress, u256>,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        pragma: PragmaPriceComponent::Storage,
    }


    #[constructor]
    fn constructor(ref self: ContractState, end_date: u64, vote_date_limit: u64, reference_token_price: u256, owner: ContractAddress, pragmaAddress: ContractAddress) {
        let eth_contract_address = ETH_CONTRACT_ADDRESS.try_into().unwrap();
        self.eth_token.write(IERC20CamelDispatcher { contract_address: eth_contract_address });
        self.total_bets.write(1); // First bet when contract is created

        
        let btc_price = self.pragma.get_asset_price_median(pragmaAddress, DataType::SpotEntry(KEY));

        let current_bet = BetInfos {
            id: 0,
            total_amount: 0,
            total_amount_yes: 0,
            total_amount_no: 0,
            begin_date: get_current_timestamp(),
            end_date: end_date,
            token_price_start: btc_price.into(), // 8 decimals
            reference_token_price: reference_token_price,
            vote_date_limit: vote_date_limit,
        };
        self.current_bet.write(current_bet);
        self.ownable.initializer(owner);
        self.bets_history.write(0, current_bet); // TODO: Remove this, make It when bet is over
    }

 
    fn get_current_timestamp() -> u64 {
        let timestamp = get_block_timestamp();
        timestamp
    }
    
    fn assert_bet_period_validity(self: @ContractState) {
        let current_timestamp = get_current_timestamp();
        let start_vote_bet_timestamp = self.current_bet.read().begin_date;
        let end_vote_bet_timestamp = self.current_bet.read().vote_date_limit;
        assert!(current_timestamp >= start_vote_bet_timestamp, "Vote has not started yet");
        assert!(current_timestamp <= end_vote_bet_timestamp, "Vote is over");
    }


    #[abi(embed_v0)]
    impl BitcoinImpl of IBitcoinPrice<ContractState> {
        fn vote_yes(ref self: ContractState, amount_eth: u256) {
            assert_bet_period_validity(@self);
            let caller_address = get_caller_address();
            if amount_eth > 0 {
                // call approve on UI
                self
                    .eth_token
                    .read()
                    .transferFrom(caller_address, get_contract_address(), amount_eth);

                    let mut current_bet : BetInfos = self.current_bet.read();
                    current_bet.total_amount += amount_eth;
                    current_bet.total_amount_yes += amount_eth;
                    self.current_bet.write(current_bet);
                    self.user_bet_yes_amount.write(caller_address, self.user_bet_yes_amount.read(caller_address) + amount_eth);
            }
        }

        fn vote_no(ref self: ContractState, amount_eth: u256) {
            assert_bet_period_validity(@self);
            let caller_address = get_caller_address();
            if amount_eth > 0 {
                // call approve on UI
                self
                    .eth_token
                    .read()
                    .transferFrom(caller_address, get_contract_address(), amount_eth);

                    let mut current_bet : BetInfos = self.current_bet.read();
                    current_bet.total_amount += amount_eth;
                    current_bet.total_amount_no += amount_eth;
                    self.current_bet.write(current_bet);
                    self.user_bet_no_amount.write(caller_address, self.user_bet_no_amount.read(caller_address) + amount_eth);
            }
        }

        fn claimRewards(ref self: ContractState) -> u256 {
            1_u256
        }


        fn get_current_bet(self: @ContractState) -> BetInfos {
            self.current_bet.read()
        }
        fn get_own_yes_amount(self: @ContractState) -> u256 {
            self.user_bet_yes_amount.read(get_caller_address())
        }
        fn get_own_no_amount(self: @ContractState) -> u256 {
            self.user_bet_no_amount.read(get_caller_address())
        }
    }
}