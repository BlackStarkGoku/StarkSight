use contracts::cryptos::PragmaPrice::{IPragmaPriceDispatcher, IPragmaPriceDispatcherTrait};
use openzeppelin::tests::utils::constants::OWNER;
use openzeppelin::utils::serde::SerializedAppend;
use snforge_std::{declare, ContractClassTrait, prank, CheatTarget, CheatSpan};
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
#[fork("TEST")]
fn test_get_bitcoin_price_from_pragma() {
    let contract_address = deploy_contract("PragmaPrice");

    let dispatcher = IPragmaPriceDispatcher { contract_address };
    
    let oracle_address : ContractAddress = contract_address_const::<0x2a85bd616f912537c50a49a4076db02c00b29b2cdc8a197ce92ed1837fa875b>();
    let price = dispatcher.get_asset_price_median(oracle_address, DataType::SpotEntry(KEY));

    assert!(price != 0, "Price is 0");
}
