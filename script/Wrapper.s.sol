// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Wrapper} from "../src/Wrapper.sol";

//0x6395b37b7f966af183Af513FC0B956d2f288B1B6 token
//0xb674d916813f39Df0d716B06498bBca1bF482186 wrapped
contract WrapperScript is Script {
    Wrapper public wrapper;

    function setUp() external {}

    function run() external {
        vm.startBroadcast();
        wrapper = new Wrapper(0x6395b37b7f966af183Af513FC0B956d2f288B1B6);
        vm.stopBroadcast();
    }
}
