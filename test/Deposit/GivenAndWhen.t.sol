// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {WrapperTest} from "test/Wrapper.t.sol";
import {WrapperContract} from "../../src/Wrapper.sol";

contract WhenAndGivenTestForDeposit is WrapperTest {
    modifier givenAssetIsETH() {
        assetType = WrapperContract.AssetType.ETH;
        _;
    }

    function test_GivenMsgValueIs0() external givenAssetIsETH {
        // it should revert with ZeroEthAmount
        vm.startPrank(sinc);
        vm.expectRevert(WrapperContract.ZeroEthAmount.selector);
        wrapperContract.deposit{value: 0 ether}(WrapperContract.AssetType.ETH, 0);
        vm.stopPrank();
    }

    function test_GivenMsgValueIsGreaterThan0() external givenAssetIsETH {
        // it should increase balanceInETH by msg.value
        // it should increase balanceInETHForUser(msgsender) by msg value
        // it should mint msg.value wrapped tokens to msg.sender
        // it should emit EthDeposit(msg sender, msg value)
        vm.startPrank(sinc);

        wrapperContract.deposit{value: 1 ether}(WrapperContract.AssetType.ETH, 0);
        assertEq(wrapperContract.balanceInETH(), 1 ether);
        assertEq(wrapperContract.balanceInETHForUser(sinc), 1 ether);

        emit WrapperContract.EthDeposit(sinc, 1 ether);
        vm.stopPrank();
    }

    modifier givenAssetIsTOKEN() {
        assetType = WrapperContract.AssetType.TOKEN;
        _;
    }

    function test_Given_amountIs0() external givenAssetIsTOKEN {
        // it should revert with ZeroTokenAmount
        vm.startPrank(sinc);
        vm.expectRevert(WrapperContract.ZeroTokenAmount.selector);
        wrapperContract.deposit(WrapperContract.AssetType.TOKEN, 0);
        vm.stopPrank();
    }

    modifier given_amountGreaterThan0() {
        vm.startPrank(sinc);

        wrapperContract.deposit(WrapperContract.AssetType.TOKEN, depositAmount);

        vm.stopPrank();
        _;
    }

    function test_GivenTransferFromSucceeds() external givenAssetIsTOKEN given_amountGreaterThan0 {
        // it should mint _amount wrapped tokens to msg sender
        // it should emit TokenDeposit(msg sender, _amount)
        assertEq(wrapperContract.balanceOf(sinc), depositAmount);
        emit WrapperContract.TokenDeposit(sinc, depositAmount);
    }
}
