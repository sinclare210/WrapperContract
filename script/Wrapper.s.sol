// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {WrapperContract} from "src/Wrapper.sol";
//https://sepolia.etherscan.io/address/0xa0793eaab89e4f80616cca222ede8d720bef077b

contract CounterScript is Script {
    WrapperContract public wrapperContract;

    function run() external {
        vm.startBroadcast();
        wrapperContract = new WrapperContract(0x1dD05d3CD0D639b19D183d1A7464E9618C06911f);
        vm.stopBroadcast();
    }
}
