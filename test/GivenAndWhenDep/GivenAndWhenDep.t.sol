// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {WrapperTest} from "../Wrapper.t.sol";
import {Wrapper} from "../../src/Wrapper.sol";

contract GivenAndWhenDep is WrapperTest {
    event Deposited(address indexed user, uint256 amount);

    function test_Given_amountIs0() external {
        // it should revert with ZeroNotAllowed
        vm.startPrank(sinc);
        vm.expectRevert(Wrapper.ZeroNotAllowed.selector);
        wrapper.deposit(0);
        vm.stopPrank();
    }

    modifier given_amountGreaterThan0() {
        vm.startPrank(sinc);

        wrapper.deposit(depositAmount);

        vm.stopPrank();
        _;
    }

    function test_GivenTransferFromSucceeds() external given_amountGreaterThan0 {
        // it should mint _amount of wTKN to msg.sender
        // it should not change msg sender's original token balance (after transfer)
        // it should increase Wrapper contract's original token balance by _amount
        // it should emit Deposited(msg sender, _amount)
        assertEq(wrapper.balanceOf(sinc), depositAmount);
        assertEq(sinclair.balanceOf(address(wrapper)), depositAmount);

        emit Wrapper.Deposited(sinc, depositAmount);
    }
}
