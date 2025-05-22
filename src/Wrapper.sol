// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Wrapper
 *
 * @notice A wrapper contract that allows users to wrap any ERC20 token into a new ERC20 token at a 1:1 ratio.
 *
 * @dev Users deposit an underlying token (Sinclair), and receive an equivalent amount of wrapped tokens (wTKN).
 * Wrapped tokens can be redeemed at any time by burning them and withdrawing the original token.
 */
contract Wrapper is ERC20 {
    using SafeERC20 for IERC20;

    /// @notice The ERC20 token being wrapped (e.g., Sinclair)
    IERC20 public immutable wrappedToken;

    /// @notice Error thrown when a zero amount is passed to deposit or withdraw
    error ZeroNotAllowed();

    /// @notice Error thrown when user's token balance is insufficient
    error InsufficentFunds();

    /**
     * @notice Emitted when a user deposits and receives wrapped tokens
     * @param user The address of the depositor
     * @param amount The amount of tokens deposited and wrapped
     */
    event Deposited(address indexed user, uint256 amount);

    /**
     * @notice Emitted when a user withdraws and burns wrapped tokens
     * @param user The address of the withdrawer
     * @param amount The amount of tokens unwrapped and returned
     */
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @notice Initializes the Wrapper contract
     *
     * @dev Sets the address of the ERC20 token to wrap.
     * The wrapped token minted will match the deposit 1:1.
     *
     * @param _wrappedToken The address of the ERC20 token to wrap (e.g., Sinclair)
     */
    constructor(address _wrappedToken) ERC20("Wrapped Sinclair", "wTKN") {
        wrappedToken = IERC20(_wrappedToken);
    }

    /**
     * @notice Deposits the original token and mints wrapped tokens to the sender
     *
     * @dev The user must approve this contract to spend `_amount` of the original token before calling this function.
     * Emits a {Deposited} event on success.
     *
     * Requirements:
     * - `_amount` must be greater than 0.
     *
     * @param _amount The amount of the original token to wrap
     */
    function deposit(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();

        wrappedToken.safeTransferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, _amount);

        emit Deposited(msg.sender, _amount);
    }

    /**
     * @notice Burns wrapped tokens and returns the original tokens to the user
     *
     * @dev The user must hold at least `_amount` of wrapped tokens. The same amount
     * of original tokens is returned after burning. Emits a {Withdrawn} event.
     *
     * Requirements:
     * - `_amount` must be greater than 0.
     * - The contract must hold enough original tokens to fulfill the withdrawal.
     *
     * @param _amount The amount of wrapped tokens to redeem for the original token
     */
    function withdraw(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();
        if (balanceOf(msg.sender) < _amount) revert InsufficentFunds();

        _burn(msg.sender, _amount);
        wrappedToken.safeTransfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }
}
