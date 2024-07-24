// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import "forge-std/console.sol";
import {MockV3Aggregator} from "../lib/chainlink-contract/src/v0.8/tests/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeedAddress; // ETH/USD price feed address
    }

    NetworkConfig public i_activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        // sepolia online testnet
        if (block.chainid == 11155111) {
            i_activeNetworkConfig = getSepoliaEthConfig();
        }
        // anvil local testnet
        else {
            i_activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() private pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    function getAnvilEthConfig() private returns (NetworkConfig memory) {
        if (i_activeNetworkConfig.priceFeedAddress != address(0)) {
            return i_activeNetworkConfig;
        }

        console.log("Deploying mockV3Aggreagator ...");
        // deploy the mock
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggreagator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        return NetworkConfig({priceFeedAddress: address(mockV3Aggreagator)});
    }
}
