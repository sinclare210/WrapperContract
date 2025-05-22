// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity 0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Sinclair is ERC20 {
    constructor(address recipient) ERC20("Sinclair", "SINCS") {
        _mint(recipient, 100000000000 * 10 ** decimals());
    }
}
