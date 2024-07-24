// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

contract FundMeIntergrationTest is Test {
    FundMe private fundme;
    // faked user
    address private fakedUser = makeAddr("user");
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 public constant GAS_PRICe = 1;

    // deploy
    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundme = deploy.run();
        vm.deal(fakedUser, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundme), fakedUser);

        assertNotEq(address(fundme).balance, 0);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundme));

        assertEq(address(fundme).balance, 0);
    }
}
