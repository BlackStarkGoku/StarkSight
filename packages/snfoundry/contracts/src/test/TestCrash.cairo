use contracts::cryptos::BitcoinPrice::BetInfos;
use contracts::cryptos::BitcoinPrice::{IBitcoinPriceDispatcher, IBitcoinPriceDispatcherTrait};
use core::traits::TryInto;
use openzeppelin::tests::utils::constants::OWNER;
use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
use openzeppelin::utils::serde::SerializedAppend;
use snforge_std::{
    declare, ContractClassTrait, prank, CheatTarget, CheatSpan, start_warp, stop_warp
};
use starknet::ContractAddress;
use starknet::contract_address::contract_address_const;


const ETH_CONTRACT_ADDRESS: felt252 =
    0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap();
    let mut calldata = array![];

    let oracle_address: ContractAddress = contract_address_const::<
    0x60c69136b39319547a4df303b6b3a26fab8b2d78de90b6bd215ce82e9cb515c
    >();
    calldata.append_serde(OWNER());
    calldata.append_serde(oracle_address);
    let (contract_address, _) = contract.deploy(@calldata).unwrap();
    contract_address
}

fn setup() -> IERC20CamelDispatcher {
    //let contract_address = deploy_contract("BitcoinPrice");
    //contract_address.print();
    //let dispatcher = IBitcoinPriceDispatcher { contract_address };

    let eth_contract_address = ETH_CONTRACT_ADDRESS.try_into().unwrap();
    let eth_token = IERC20CamelDispatcher { contract_address: eth_contract_address };
    eth_token
} 

#[test]
#[fork("TEST")]
fn test_start_game() {
    let contract_address = deploy_contract("CrashContract");
    let eth_token = setup();
    prank(
        CheatTarget::One(contract_address),
        0x0213c67ed78bc280887234fe5ed5e77272465317978ae86c25a71531d9332a2d.try_into().unwrap(),
        CheatSpan::TargetCalls(3)
    );
    let dispatcher = ICrashContractDispatcher { contract_address };
    

}