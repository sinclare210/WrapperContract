// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {WrapperTest} from "test/Wrapper.t.sol";
import {WrapperContract} from "src/Wrapper.sol";

contract WhenAndGivenTestForWithdraw is WrapperTest {
    function test_Given_amountIs0() external {
        // it should revert with WithdrawAmountZero
    }

    modifier givenAssetIsETH() {
        assetType = WrapperContract.AssetType.ETH;
        _;
    }

    function test_Given_amountIsGreaterThanUserETHBalance() external givenAssetIsETH {
        // it should revert with InsufficientEthDeposit
    }

    function test_Given_amountLessThanOrEqualToUserETHBalance() external givenAssetIsETH {
        // it should decrease balanceInETH by _amount
        // it should decrease balanceInETHForUser(msg sender) by _amount
        // it should burn _amount of wrapped tokens from msg sender
        // it should transfer _amount ETH to msg sender
        // it should emit EthWithdrawal(msg sender, _amount)
    }

    modifier givenAssetIsTOKEN() {
        assetType = WrapperContract.AssetType.TOKEN;
        _;
    }

    function test_GivenContractHasInsufficientTokenBalance() external givenAssetIsTOKEN {
        // it should revert with SafeERC20 error
    }

    function test_GivenContractHasSufficientTokenBalance() external givenAssetIsTOKEN {
        // it should burn _amount of wrapped tokens from msg sender
        // it should transfer _amount tokens to msg sender
        // it should emit TokenWithdrawal(msg sender, _amount)
    }
}
