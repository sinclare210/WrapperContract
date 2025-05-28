// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {WrapperContract} from "src/Wrapper.sol";
import {Sinclair} from "src/Sinclair.sol";

contract WrapperTest is Test {
    WrapperContract public wrapperContract;
    Sinclair public sinclair;
    WrapperContract.AssetType internal assetType;
    address sinc = address(0x1);

    uint256 approveAmount = 1000000000000000;
    uint256 depositAmount = 200000;
    uint256 withdrawAmount = 100000;

    function setUp() public {
        sinclair = new Sinclair(sinc);

        wrapperContract = new WrapperContract(address(sinclair));

        assertEq(sinclair.balanceOf(sinc), 10000000000000000 * 10 ** 18);

        vm.startPrank(sinc);
        sinclair.approve(address(wrapperContract), approveAmount);
        assertEq(sinclair.allowance(sinc, address(wrapperContract)), approveAmount);
        vm.stopPrank();
    }
}
