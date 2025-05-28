// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {WrapperTest} from "test/Wrapper.t.sol";
import {WrapperContract} from "src/Wrapper.sol";

contract WhenAndGivenTestForDeposit is WrapperTest {
    modifier givenAssetIsETH() {
        assetType = WrapperContract.AssetType.ETH;
        _;
    }

    function test_GivenMsgValueIs0() external givenAssetIsETH {
        // it should revert with ZeroEthAmount
    }

    function test_GivenMsgValueIsGreaterThan0() external givenAssetIsETH {
        // it should increase balanceInETH by msg.value
        // it should increase balanceInETHForUser(msgsender) by msg value
        // it should mint msg.value wrapped tokens to msg.sender
        // it should emit EthDeposit(msg sender, msg value)
    }

    modifier givenAssetIsTOKEN() {
        assetType = WrapperContract.AssetType.TOKEN;
        _;
    }

    function test_Given_amountIs0() external givenAssetIsTOKEN {
        // it should revert with ZeroTokenAmount
    }

    modifier given_amountGreaterThan0() {
        _;
    }

    function test_GivenTransferFromFails() external givenAssetIsTOKEN given_amountGreaterThan0 {
        // it should revert with SafeERC20 error
    }

    function test_GivenTransferFromSucceeds() external givenAssetIsTOKEN given_amountGreaterThan0 {
        // it should mint _amount wrapped tokens to msg sender
        // it should emit TokenDeposit(msg sender, _amount)
    }
}
