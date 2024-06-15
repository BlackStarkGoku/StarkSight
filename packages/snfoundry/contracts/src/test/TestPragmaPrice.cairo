use contracts::cryptos::PragmaPrice::{IPragmaPriceDispatcher, IPragmaPriceDispatcherTrait};
use openzeppelin::tests::utils::constants::OWNER;
use openzeppelin::utils::serde::SerializedAppend;
use snforge_std::{declare, ContractClassTrait};
use starknet::ContractAddress;
use pragma_lib::abi::{IPragmaABIDispatcher, IPragmaABIDispatcherTrait};
use pragma_lib::types::{AggregationMode, DataType, PragmaPricesResponse};
use starknet::contract_address::contract_address_const;


const KEY :felt252 = 18669995996566340; // felt252 conversion of "BTC/USD",

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap();
    let mut calldata = array![];
    let (contract_address, _) = contract.deploy(@calldata).unwrap();
    contract_address
}

#[test]
fn test_deployment_values() {
   

    let contract_address = deploy_contract("PragmaPrice");

    let dispatcher = IPragmaPriceDispatcher { contract_address };

    let oracle_address : ContractAddress = contract_address_const::<0x06df335982dddce41008e4c03f2546fa27276567b5274c7d0c1262f3c2b5d167>();

    let price = dispatcher.get_asset_price_median(oracle_address, DataType::SpotEntry(KEY));
}
