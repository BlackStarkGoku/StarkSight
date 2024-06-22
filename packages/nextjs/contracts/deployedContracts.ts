/**
 * This file is autogenerated by Scaffold-Stark.
 * You should not edit it manually or your changes might be overwritten.
 */

const deployedContracts = {
  devnet: {
    BitcoinPrice: {
      abi: [
        {
          type: "impl",
          name: "BitcoinImpl",
          interface_name: "contracts::cryptos::BitcoinPrice::IBitcoinPrice",
        },
        {
          type: "struct",
          name: "core::integer::u256",
          members: [
            {
              name: "low",
              type: "core::integer::u128",
            },
            {
              name: "high",
              type: "core::integer::u128",
            },
          ],
        },
        {
          type: "enum",
          name: "core::bool",
          variants: [
            {
              name: "False",
              type: "()",
            },
            {
              name: "True",
              type: "()",
            },
          ],
        },
        {
          type: "struct",
          name: "contracts::cryptos::BitcoinPrice::BetInfos",
          members: [
            {
              name: "id",
              type: "core::integer::u64",
            },
            {
              name: "total_amount",
              type: "core::integer::u256",
            },
            {
              name: "total_amount_yes",
              type: "core::integer::u256",
            },
            {
              name: "total_amount_no",
              type: "core::integer::u256",
            },
            {
              name: "begin_date",
              type: "core::integer::u64",
            },
            {
              name: "end_date",
              type: "core::integer::u64",
            },
            {
              name: "token_price_start",
              type: "core::integer::u256",
            },
            {
              name: "token_price_end",
              type: "core::integer::u256",
            },
            {
              name: "is_token_price_end_set",
              type: "core::bool",
            },
            {
              name: "reference_token_price",
              type: "core::integer::u256",
            },
            {
              name: "vote_date_limit",
              type: "core::integer::u64",
            },
          ],
        },
        {
          type: "interface",
          name: "contracts::cryptos::BitcoinPrice::IBitcoinPrice",
          items: [
            {
              type: "function",
              name: "vote_yes",
              inputs: [
                {
                  name: "amount_eth",
                  type: "core::integer::u256",
                },
              ],
              outputs: [],
              state_mutability: "external",
            },
            {
              type: "function",
              name: "vote_no",
              inputs: [
                {
                  name: "amount_eth",
                  type: "core::integer::u256",
                },
              ],
              outputs: [],
              state_mutability: "external",
            },
            {
              type: "function",
              name: "get_current_bet",
              inputs: [],
              outputs: [
                {
                  type: "contracts::cryptos::BitcoinPrice::BetInfos",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "get_own_yes_amount",
              inputs: [
                {
                  name: "contract_address",
                  type: "core::starknet::contract_address::ContractAddress",
                },
                {
                  name: "bet_id",
                  type: "core::integer::u64",
                },
              ],
              outputs: [
                {
                  type: "core::integer::u256",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "get_own_no_amount",
              inputs: [
                {
                  name: "contract_address",
                  type: "core::starknet::contract_address::ContractAddress",
                },
                {
                  name: "bet_id",
                  type: "core::integer::u64",
                },
              ],
              outputs: [
                {
                  type: "core::integer::u256",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "claimRewards",
              inputs: [
                {
                  name: "bet_id",
                  type: "core::integer::u64",
                },
              ],
              outputs: [
                {
                  type: "core::integer::u256",
                },
              ],
              state_mutability: "external",
            },
            {
              type: "function",
              name: "set_pragma_checkpoint",
              inputs: [],
              outputs: [],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "set_bet_result_price",
              inputs: [],
              outputs: [],
              state_mutability: "external",
            },
          ],
        },
        {
          type: "impl",
          name: "OwnableImpl",
          interface_name: "openzeppelin::access::ownable::interface::IOwnable",
        },
        {
          type: "interface",
          name: "openzeppelin::access::ownable::interface::IOwnable",
          items: [
            {
              type: "function",
              name: "owner",
              inputs: [],
              outputs: [
                {
                  type: "core::starknet::contract_address::ContractAddress",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "transfer_ownership",
              inputs: [
                {
                  name: "new_owner",
                  type: "core::starknet::contract_address::ContractAddress",
                },
              ],
              outputs: [],
              state_mutability: "external",
            },
            {
              type: "function",
              name: "renounce_ownership",
              inputs: [],
              outputs: [],
              state_mutability: "external",
            },
          ],
        },
        {
          type: "impl",
          name: "PragmaPriceImpl",
          interface_name: "contracts::cryptos::PragmaPrice::IPragmaPrice",
        },
        {
          type: "enum",
          name: "pragma_lib::types::DataType",
          variants: [
            {
              name: "SpotEntry",
              type: "core::felt252",
            },
            {
              name: "FutureEntry",
              type: "(core::felt252, core::integer::u64)",
            },
            {
              name: "GenericEntry",
              type: "core::felt252",
            },
          ],
        },
        {
          type: "interface",
          name: "contracts::cryptos::PragmaPrice::IPragmaPrice",
          items: [
            {
              type: "function",
              name: "get_asset_price_median",
              inputs: [
                {
                  name: "oracle_address",
                  type: "core::starknet::contract_address::ContractAddress",
                },
                {
                  name: "asset",
                  type: "pragma_lib::types::DataType",
                },
              ],
              outputs: [
                {
                  type: "core::integer::u128",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "set_asset_price_median_checkoint",
              inputs: [
                {
                  name: "oracle_address",
                  type: "core::starknet::contract_address::ContractAddress",
                },
                {
                  name: "asset",
                  type: "pragma_lib::types::DataType",
                },
              ],
              outputs: [],
              state_mutability: "view",
            },
          ],
        },
        {
          type: "constructor",
          name: "constructor",
          inputs: [
            {
              name: "end_date",
              type: "core::integer::u64",
            },
            {
              name: "vote_date_limit",
              type: "core::integer::u64",
            },
            {
              name: "reference_token_price",
              type: "core::integer::u256",
            },
            {
              name: "owner",
              type: "core::starknet::contract_address::ContractAddress",
            },
            {
              name: "pragmaAddress",
              type: "core::starknet::contract_address::ContractAddress",
            },
          ],
        },
        {
          type: "event",
          name: "openzeppelin::access::ownable::ownable::OwnableComponent::OwnershipTransferred",
          kind: "struct",
          members: [
            {
              name: "previous_owner",
              type: "core::starknet::contract_address::ContractAddress",
              kind: "key",
            },
            {
              name: "new_owner",
              type: "core::starknet::contract_address::ContractAddress",
              kind: "key",
            },
          ],
        },
        {
          type: "event",
          name: "openzeppelin::access::ownable::ownable::OwnableComponent::OwnershipTransferStarted",
          kind: "struct",
          members: [
            {
              name: "previous_owner",
              type: "core::starknet::contract_address::ContractAddress",
              kind: "key",
            },
            {
              name: "new_owner",
              type: "core::starknet::contract_address::ContractAddress",
              kind: "key",
            },
          ],
        },
        {
          type: "event",
          name: "openzeppelin::access::ownable::ownable::OwnableComponent::Event",
          kind: "enum",
          variants: [
            {
              name: "OwnershipTransferred",
              type: "openzeppelin::access::ownable::ownable::OwnableComponent::OwnershipTransferred",
              kind: "nested",
            },
            {
              name: "OwnershipTransferStarted",
              type: "openzeppelin::access::ownable::ownable::OwnableComponent::OwnershipTransferStarted",
              kind: "nested",
            },
          ],
        },
        {
          type: "event",
          name: "contracts::cryptos::PragmaPrice::PragmaPrice::Event",
          kind: "enum",
          variants: [],
        },
        {
          type: "event",
          name: "contracts::cryptos::BitcoinPrice::BitcoinPrice::Event",
          kind: "enum",
          variants: [
            {
              name: "OwnableEvent",
              type: "openzeppelin::access::ownable::ownable::OwnableComponent::Event",
              kind: "flat",
            },
            {
              name: "PragmaPriceEvent",
              type: "contracts::cryptos::PragmaPrice::PragmaPrice::Event",
              kind: "flat",
            },
          ],
        },
      ],
    },
  },
  sepolia: {
    BitcoinPrice: {
      address:
        "0x06eb23b3c740004007c45892ac967d93fbacd041cf37844d258f758526121f40",
      abi: [
        {
          type: "impl",
          name: "BitcoinImpl",
          interface_name: "contracts::cryptos::BitcoinPrice::IBitcoinPrice",
        },
        {
          type: "struct",
          name: "core::integer::u256",
          members: [
            {
              name: "low",
              type: "core::integer::u128",
            },
            {
              name: "high",
              type: "core::integer::u128",
            },
          ],
        },
        {
          type: "enum",
          name: "core::bool",
          variants: [
            {
              name: "False",
              type: "()",
            },
            {
              name: "True",
              type: "()",
            },
          ],
        },
        {
          type: "struct",
          name: "contracts::cryptos::BitcoinPrice::BetInfos",
          members: [
            {
              name: "id",
              type: "core::integer::u64",
            },
            {
              name: "total_amount",
              type: "core::integer::u256",
            },
            {
              name: "total_amount_yes",
              type: "core::integer::u256",
            },
            {
              name: "total_amount_no",
              type: "core::integer::u256",
            },
            {
              name: "begin_date",
              type: "core::integer::u64",
            },
            {
              name: "end_date",
              type: "core::integer::u64",
            },
            {
              name: "token_price_start",
              type: "core::integer::u256",
            },
            {
              name: "token_price_end",
              type: "core::integer::u256",
            },
            {
              name: "is_token_price_end_set",
              type: "core::bool",
            },
            {
              name: "reference_token_price",
              type: "core::integer::u256",
            },
            {
              name: "vote_date_limit",
              type: "core::integer::u64",
            },
          ],
        },
        {
          type: "interface",
          name: "contracts::cryptos::BitcoinPrice::IBitcoinPrice",
          items: [
            {
              type: "function",
              name: "vote_yes",
              inputs: [
                {
                  name: "amount_eth",
                  type: "core::integer::u256",
                },
              ],
              outputs: [],
              state_mutability: "external",
            },
            {
              type: "function",
              name: "vote_no",
              inputs: [
                {
                  name: "amount_eth",
                  type: "core::integer::u256",
                },
              ],
              outputs: [],
              state_mutability: "external",
            },
            {
              type: "function",
              name: "get_current_bet",
              inputs: [],
              outputs: [
                {
                  type: "contracts::cryptos::BitcoinPrice::BetInfos",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "get_own_yes_amount",
              inputs: [
                {
                  name: "contract_address",
                  type: "core::starknet::contract_address::ContractAddress",
                },
                {
                  name: "bet_id",
                  type: "core::integer::u64",
                },
              ],
              outputs: [
                {
                  type: "core::integer::u256",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "get_own_no_amount",
              inputs: [
                {
                  name: "contract_address",
                  type: "core::starknet::contract_address::ContractAddress",
                },
                {
                  name: "bet_id",
                  type: "core::integer::u64",
                },
              ],
              outputs: [
                {
                  type: "core::integer::u256",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "claimRewards",
              inputs: [
                {
                  name: "bet_id",
                  type: "core::integer::u64",
                },
              ],
              outputs: [
                {
                  type: "core::integer::u256",
                },
              ],
              state_mutability: "external",
            },
            {
              type: "function",
              name: "set_pragma_checkpoint",
              inputs: [],
              outputs: [],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "set_bet_result_price",
              inputs: [],
              outputs: [],
              state_mutability: "external",
            },
          ],
        },
        {
          type: "impl",
          name: "OwnableImpl",
          interface_name: "openzeppelin::access::ownable::interface::IOwnable",
        },
        {
          type: "interface",
          name: "openzeppelin::access::ownable::interface::IOwnable",
          items: [
            {
              type: "function",
              name: "owner",
              inputs: [],
              outputs: [
                {
                  type: "core::starknet::contract_address::ContractAddress",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "transfer_ownership",
              inputs: [
                {
                  name: "new_owner",
                  type: "core::starknet::contract_address::ContractAddress",
                },
              ],
              outputs: [],
              state_mutability: "external",
            },
            {
              type: "function",
              name: "renounce_ownership",
              inputs: [],
              outputs: [],
              state_mutability: "external",
            },
          ],
        },
        {
          type: "impl",
          name: "PragmaPriceImpl",
          interface_name: "contracts::cryptos::PragmaPrice::IPragmaPrice",
        },
        {
          type: "enum",
          name: "pragma_lib::types::DataType",
          variants: [
            {
              name: "SpotEntry",
              type: "core::felt252",
            },
            {
              name: "FutureEntry",
              type: "(core::felt252, core::integer::u64)",
            },
            {
              name: "GenericEntry",
              type: "core::felt252",
            },
          ],
        },
        {
          type: "interface",
          name: "contracts::cryptos::PragmaPrice::IPragmaPrice",
          items: [
            {
              type: "function",
              name: "get_asset_price_median",
              inputs: [
                {
                  name: "oracle_address",
                  type: "core::starknet::contract_address::ContractAddress",
                },
                {
                  name: "asset",
                  type: "pragma_lib::types::DataType",
                },
              ],
              outputs: [
                {
                  type: "core::integer::u128",
                },
              ],
              state_mutability: "view",
            },
            {
              type: "function",
              name: "set_asset_price_median_checkoint",
              inputs: [
                {
                  name: "oracle_address",
                  type: "core::starknet::contract_address::ContractAddress",
                },
                {
                  name: "asset",
                  type: "pragma_lib::types::DataType",
                },
              ],
              outputs: [],
              state_mutability: "view",
            },
          ],
        },
        {
          type: "constructor",
          name: "constructor",
          inputs: [
            {
              name: "end_date",
              type: "core::integer::u64",
            },
            {
              name: "vote_date_limit",
              type: "core::integer::u64",
            },
            {
              name: "reference_token_price",
              type: "core::integer::u256",
            },
            {
              name: "owner",
              type: "core::starknet::contract_address::ContractAddress",
            },
            {
              name: "pragmaAddress",
              type: "core::starknet::contract_address::ContractAddress",
            },
          ],
        },
        {
          type: "event",
          name: "openzeppelin::access::ownable::ownable::OwnableComponent::OwnershipTransferred",
          kind: "struct",
          members: [
            {
              name: "previous_owner",
              type: "core::starknet::contract_address::ContractAddress",
              kind: "key",
            },
            {
              name: "new_owner",
              type: "core::starknet::contract_address::ContractAddress",
              kind: "key",
            },
          ],
        },
        {
          type: "event",
          name: "openzeppelin::access::ownable::ownable::OwnableComponent::OwnershipTransferStarted",
          kind: "struct",
          members: [
            {
              name: "previous_owner",
              type: "core::starknet::contract_address::ContractAddress",
              kind: "key",
            },
            {
              name: "new_owner",
              type: "core::starknet::contract_address::ContractAddress",
              kind: "key",
            },
          ],
        },
        {
          type: "event",
          name: "openzeppelin::access::ownable::ownable::OwnableComponent::Event",
          kind: "enum",
          variants: [
            {
              name: "OwnershipTransferred",
              type: "openzeppelin::access::ownable::ownable::OwnableComponent::OwnershipTransferred",
              kind: "nested",
            },
            {
              name: "OwnershipTransferStarted",
              type: "openzeppelin::access::ownable::ownable::OwnableComponent::OwnershipTransferStarted",
              kind: "nested",
            },
          ],
        },
        {
          type: "event",
          name: "contracts::cryptos::PragmaPrice::PragmaPrice::Event",
          kind: "enum",
          variants: [],
        },
        {
          type: "event",
          name: "contracts::cryptos::BitcoinPrice::BitcoinPrice::Event",
          kind: "enum",
          variants: [
            {
              name: "OwnableEvent",
              type: "openzeppelin::access::ownable::ownable::OwnableComponent::Event",
              kind: "flat",
            },
            {
              name: "PragmaPriceEvent",
              type: "contracts::cryptos::PragmaPrice::PragmaPrice::Event",
              kind: "flat",
            },
          ],
        },
      ],
    },
  },
} as const;

export default deployedContracts;
