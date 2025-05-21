// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Wrapper is ERC20 {
    error ZeroNotAllowed();

    using SafeERC20 for IERC20;

    IERC20 public immutable wrappedToken;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _wrappedToken) ERC20("Wrapped Sinclair", "wTKN") {
        wrappedToken = IERC20(_wrappedToken);
    }

    function deposit(uint256 _amount) public {
        if (_amount < 0) revert ZeroNotAllowed();

        wrappedToken.safeTransferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, _amount);

        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) public {
        if (_amount < 0) revert ZeroNotAllowed();
        _burn(msg.sender, _amount);
        wrappedToken.safeTransfer(msg.sender, _amount);
        emit Withdrawn(msg.sender, _amount);
    }
}
