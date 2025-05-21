// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

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

    /// @notice Error thrown when a zero amount is passed
    error ZeroNotAllowed();

    /// @notice The ERC20 token being wrapped
    IERC20 public immutable wrappedToken;

    /**
     * @notice Emitted when a user deposits and receives wrapped tokens
     * @param user The address of the depositor
     * @param amount The amount of tokens deposited and wrapped
     */
    event Deposited(address indexed user, uint256 amount);

    /// @notice Emitted when a user withdraws and burns wrapped tokens
    /// @param user The address of the withdrawer
    /// @param amount The amount of tokens unwrapped and returned
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @notice Initializes the Wrapper contract
     *
     * @dev Sets the address of the underlying ERC20 token that will be wrapped.
     * The wrapped token will mirror the deposited amount 1:1.
     *
     * @param _wrappedToken The address of the ERC20 token to wrap
     */
    constructor(address _wrappedToken) ERC20("Wrapped Sinclair", "wTKN") {
        wrappedToken = IERC20(_wrappedToken);
    }

    /**
     * @notice Deposits the original token and mints wrapped tokens
     *
     * @dev The user must approve this contract to spend `_amount` of the original token
     * before calling this function. The amount of wrapped tokens minted is equal to
     * the deposited amount.
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
     * @dev The user must have at least `_amount` of wrapped tokens. The same amount of
     * original tokens is transferred back to the user after burning.
     *
     * @param _amount The amount of wrapped tokens to redeem
     */
    function withdraw(uint256 _amount) public {
        if (_amount == 0) revert ZeroNotAllowed();

        _burn(msg.sender, _amount);
        wrappedToken.safeTransfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }
}
