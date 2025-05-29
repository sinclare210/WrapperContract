// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {WrapperTest} from "test/Wrapper.t.sol";
import {WrapperContract} from "src/Wrapper.sol";

contract WhenAndGivenTestForWithdraw is WrapperTest {
    function test_Given_amountIs0() external {
        // it should revert with WithdrawAmountZero
        vm.startPrank(sinc);
        vm.expectRevert(WrapperContract.WithdrawAmountZero.selector);
        wrapperContract.withdraw(WrapperContract.AssetType.ETH, 0);
        vm.stopPrank();
    }

    modifier givenAssetIsETH() {
        assetType = WrapperContract.AssetType.ETH;
        _;
    }

    function test_Given_amountIsGreaterThanUserETHBalance() external givenAssetIsETH {
        // it should revert with InsufficientEthDeposit
        vm.startPrank(sinc);
        wrapperContract.deposit{value: 2 ether}(WrapperContract.AssetType.ETH, 0);
        vm.expectRevert(WrapperContract.InsufficientEthDeposit.selector);
        wrapperContract.withdraw(WrapperContract.AssetType.ETH, 3 ether);
        vm.stopPrank();
    }

    function test_Given_amountLessThanOrEqualToUserETHBalance() external givenAssetIsETH {
        // it should decrease balanceInETH by _amount
        // it should decrease balanceInETHForUser(msg sender) by _amount
        // it should burn _amount of wrapped tokens from msg sender
        // it should transfer _amount ETH to msg sender
        // it should emit EthWithdrawal(msg sender, _amount)
        vm.startPrank(sinc);
        wrapperContract.deposit{value: 2 ether}(WrapperContract.AssetType.ETH, 0);
        wrapperContract.withdraw(WrapperContract.AssetType.ETH, 1 ether);
        assertEq(wrapperContract.balanceInETH(), 1 ether);
        assertEq(wrapperContract.balanceInETHForUser(sinc), 1 ether);
        emit WrapperContract.EthWithdrawal(sinc, 1 ether);
        vm.stopPrank();
    }

    modifier givenAssetIsTOKEN() {
        assetType = WrapperContract.AssetType.TOKEN;
        _;
    }

    function test_GivenContractHasInsufficientTokenBalance() external givenAssetIsTOKEN {
        // it should revert with SafeERC20 error
        vm.startPrank(sinc);

        wrapperContract.deposit(WrapperContract.AssetType.TOKEN, 10000);
        vm.expectRevert();
        wrapperContract.withdraw(WrapperContract.AssetType.TOKEN, 10000000);
        vm.stopPrank();
    }

    function test_GivenContractHasSufficientTokenBalance() external givenAssetIsTOKEN {
        // it should burn _amount of wrapped tokens from msg sender
        // it should transfer _amount tokens to msg sender
        // it should emit TokenWithdrawal(msg sender, _amount)
        vm.startPrank(sinc);

        wrapperContract.deposit(WrapperContract.AssetType.TOKEN, 10000);

        wrapperContract.withdraw(WrapperContract.AssetType.TOKEN, 1000);
        assertEq(wrapperContract.balanceOf(sinc), 10000 - 1000);
        emit WrapperContract.TokenWithdrawal(sinc, 1000);
        vm.stopPrank();
    }
}
