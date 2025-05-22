// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Wrapper} from "../src/Wrapper.sol";
import {Test} from "forge-std/Test.sol";
import {Sinclair} from "../src/Sinclair.sol";

contract WrapperTest is Test {
    uint256 depositAmount = 100000000;
    uint256 withdrawAmount = 1000000;
    uint256 approveAmount = 30000000000;
    Wrapper public wrapper;
    Sinclair public sinclair;
    address sinc = address(0x1);

    function setUp() external {
        vm.startBroadcast();
        sinclair = new Sinclair(sinc);

        vm.stopBroadcast();

        wrapper = new Wrapper(address(sinclair));
        vm.startPrank(sinc);
        sinclair.approve(address(wrapper), approveAmount);
        vm.stopPrank();
    }
}
