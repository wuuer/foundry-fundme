// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "./DeployFundMe.s.sol";

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 constant SEND_ETH = 0.01 ether;

    function fundFundMe(address mostRecentlyDeplyed) public {
        vm.prank(msg.sender);
        vm.deal(msg.sender, SEND_ETH);
        FundMe(payable(mostRecentlyDeplyed)).fund{value: SEND_ETH}();
        console.log("Funded FundMe with %s", SEND_ETH);
    }

    function fundFundMe(
        address mostRecentlyDeplyed,
        address funderAddress
    ) public {
        vm.startPrank(funderAddress);
        FundMe(payable(mostRecentlyDeplyed)).fund{value: SEND_ETH}();
        console.log("Funded FundMe with %s", SEND_ETH);
        vm.stopPrank();
    }

    function run() external {
        // address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
        //     "FundMe",
        //     block.chainid
        // );
        DeployFundMe deploy = new DeployFundMe();
        FundMe fundme = deploy.run();
        fundFundMe(address(fundme));
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeplyed) public {
        vm.startBroadcast(); //make the msg.sender is the default sender (same as deploy)
        FundMe(payable(mostRecentlyDeplyed)).withdraw();
        vm.stopBroadcast();
        console.log("WithdrawFundMe withdraw with");
    }

    function run() external {
        // address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
        //     "FundMe",
        //     block.chainid
        // );
        DeployFundMe deploy = new DeployFundMe();
        FundMe fundme = deploy.run();
        withdrawFundMe(address(fundme));
    }
}
