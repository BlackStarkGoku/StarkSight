//core import
use pragma_lib::abi::{IPragmaABIDispatcher, IPragmaABIDispatcherTrait};
use pragma_lib::types::{AggregationMode, DataType, PragmaPricesResponse};
use starknet::ContractAddress;
use starknet::contract_address::contract_address_const;


#[starknet::interface]
pub trait IPragmaPrice<TContractState> {
    fn get_asset_price_median(self: @TContractState, oracle_address: ContractAddress, asset : DataType) -> u128;
}

#[starknet::contract]
pub mod PragmaPrice {
    use super::IPragmaPrice;
    use super::{IPragmaABIDispatcher, IPragmaABIDispatcherTrait};
    use super::{AggregationMode, DataType, PragmaPricesResponse};
    use super::ContractAddress;
    use super::contract_address_const;

    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(ref self: ContractState) {  
    }

    #[abi(embed_v0)]
    impl PragmaImpl of IPragmaPrice<ContractState> {
        fn get_asset_price_median(self: @ContractState, oracle_address: ContractAddress, asset : DataType) -> u128  { 
            let oracle_dispatcher = IPragmaABIDispatcher{contract_address : oracle_address};
            let output : PragmaPricesResponse= oracle_dispatcher.get_data(asset, AggregationMode::Median(()));
            return output.price;
        }

    }
}