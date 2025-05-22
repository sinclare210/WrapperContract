// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {WrapperTest} from "../Wrapper.t.sol";
import {Wrapper} from "../../src/Wrapper.sol";

contract WhenAndGivenTestForWithdraw is WrapperTest {

        event Withdrawn(address indexed user, uint256 amount);
    
    function test_Given_amountIs0() external {
        // it should revert with ZeroNotAllowed
        vm.startPrank(sinc);
        
        wrapper.deposit(depositAmount);
        vm.expectRevert();
        wrapper.withdraw(0);
        vm.stopPrank();
    }

    modifier given_amountGreaterThan0() {
        vm.startPrank(sinc);
        
        wrapper.deposit(depositAmount);
        
        wrapper.withdraw(withdrawAmount);
        vm.stopPrank();
        _;
    }

    function test_GivenUserBalanceOfWTKNLessThan_amount() external given_amountGreaterThan0 {
        // it should revert with ERC20: burn amount exceeds balance
        vm.startPrank(sinc);
        vm.expectRevert();
        wrapper.withdraw(depositAmount + withdrawAmount);
        vm.stopPrank();
        
        
    }

    function test_GivenUserBalanceOfWTKNGreaterThan_amount() external given_amountGreaterThan0 {
        // it should burn _amount of wTKN from msg.sender
        // it should transfer _amount of original token to msg.sender
        // it should decrease contract's original token balance by _amount
        // it should emit Withdrawn(msg sender, _amount)
    vm.startPrank(sinc);

    uint256 prevContractBal = wrapper.wrappedToken().balanceOf(address(wrapper));
    uint256 preUserBal = wrapper.wrappedToken().balanceOf(sinc);
    uint256 preUserWTKN = wrapper.balanceOf(sinc);

    
    emit  Wrapper.Withdrawn(sinc, withdrawAmount);

    wrapper.withdraw(withdrawAmount);

    assertEq(wrapper.balanceOf(sinc), preUserWTKN - withdrawAmount);
    assertEq(wrapper.wrappedToken().balanceOf(address(wrapper)), prevContractBal - withdrawAmount);
    assertEq(wrapper.wrappedToken().balanceOf(sinc), preUserBal + withdrawAmount);

    vm.stopPrank();

    }
}
