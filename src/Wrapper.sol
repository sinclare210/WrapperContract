// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Wrapper is ERC20 {

    using SafeERC20 for IERC20;

    IERC20 public immutable wrappedToken;

   

    constructor(address _sinclair) ERC20("Wrapped Sinclair", "WSIN"){
       wrappedToken = IERC20(_sinclair);
    }
    


}