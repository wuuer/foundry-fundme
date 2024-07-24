// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe private fundme;

    // faked user
    address private fakedUser = makeAddr("user");
    uint256 constant SEND_ETH = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 public constant GAS_PRICe = 1;

    // deploy
    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundme = deploy.run();
        vm.deal(fakedUser, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        uint256 minusd = fundme.MINIMUM_USD();
        assertEq(minusd, 5e18);
    }

    function testOwnerIsMsgSender() public view {
        address owner = fundme.getOwner();
        assertEq(owner, msg.sender);
    }

    function testFundFailsWithoutEnoughEth() public {
        // https://book.getfoundry.sh/cheatcodes/expect-revert
        vm.expectRevert(); //the next line should be reverted
        fundme.fund();
    }

    function testFundUpdateFunderDataStructure() public {
        // https://book.getfoundry.sh/cheatcodes/prank
        vm.prank(fakedUser); //the next transaction will be sent by fakeUser
        // https://book.getfoundry.sh/cheatcodes/deal
        vm.deal(fakedUser, SEND_ETH); // give the fakedUser 0.1 eth
        fundme.fund{value: SEND_ETH}();
        uint256 fundedAmount = fundme.getAmountFunded(fakedUser);
        address newFunder = fundme.getFunders(0);
        assertEq(newFunder, fakedUser);
        assertEq(fundedAmount, SEND_ETH);
    }

    modifier funded() {
        vm.prank(fakedUser);
        vm.deal(fakedUser, SEND_ETH);
        fundme.fund{value: SEND_ETH}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(fakedUser);
        fundme.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        // Arrange
        address owner = fundme.getOwner();
        uint256 startingOwnerBalance = owner.balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        // Act
        vm.prank(owner);
        fundme.withdraw();

        uint256 endingOwnerBalance = owner.balance;
        uint256 endingFundMeBalance = address(fundme).balance;

        // Assert

        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawWithMultipleFunders() public funded {
        uint256 numberOfFunders = 6;
        uint160 startingFunderIndex = 1;

        // Arrange
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // https://book.getfoundry.sh/reference/forge-std/hoax
            hoax(address(i), SEND_ETH);
            fundme.fund{value: SEND_ETH}();
        }

        address owner = fundme.getOwner();
        uint256 startingOwnerBalance = owner.balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        // Act
        // uint256 gasStart = gasleft();
        // https://book.getfoundry.sh/cheatcodes/tx-gas-price
        // vm.txGasPrice(GAS_PRICe);
        // https://book.getfoundry.sh/cheatcodes/start-prank
        vm.startPrank(owner);
        fundme.withdraw();
        // https://book.getfoundry.sh/cheatcodes/stop-prank
        vm.stopPrank();

        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log(gasUsed);

        uint256 endingOwnerBalance = owner.balance;
        uint256 endingFundMeBalance = address(fundme).balance;

        // Assert

        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }
}
