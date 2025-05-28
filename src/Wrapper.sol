// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @notice Thrown when ETH amount sent is zero in deposit or withdraw
error ZeroEthAmount();

/// @notice Thrown when token amount provided is zero in deposit or withdraw
error ZeroTokenAmount();

/// @notice Thrown when attempting to withdraw more ETH than deposited
error InsufficientEthDeposit();

/// @notice Thrown when attempting to withdraw more tokens than the wrapped balance
error InsufficientWrappedBalance();

/// @notice Thrown when attempting to withdraw zero tokens or ETH (withdraw amount cannot be zero)
error WithdrawAmountZero();

/// @title WrapperContract - Wrap ETH and an ERC20 token with minting and burning of wrapped tokens
/// @author
/// @notice Users can deposit ETH or a specific ERC20 token and receive wrapped tokens (WEST) 1:1
/// @dev Uses OpenZeppelin's ERC20 and SafeERC20 for safe transfers
contract WrapperContract is ERC20 {
    using SafeERC20 for IERC20;

    /// @notice Type of asset for deposit/withdrawal
    enum AssetType {ETH, TOKEN}

    /// @notice The ERC20 token accepted by this contract
    IERC20 public token;

    /// @notice Total ETH balance held by the contract from users
    uint256 public balanceInETH;

    /// @notice Tracks individual user ETH balances deposited
    mapping (address => uint256) balanceInETHForUser;

    /// @notice Emitted when a user deposits ETH
    /// @param sender The address of the depositor
    /// @param amount The amount of ETH deposited
    event EthDeposit(address indexed sender, uint256 amount);

    /// @notice Emitted when a user deposits ERC20 tokens
    /// @param sender The address of the depositor
    /// @param amount The amount of ERC20 tokens deposited
    event TokenDeposit(address indexed sender, uint256 amount);

    /// @notice Emitted when a user withdraws ETH
    /// @param receiver The address receiving the ETH
    /// @param amount The amount of ETH withdrawn
    event EthWithdrawal(address indexed receiver, uint256 amount);

    /// @notice Emitted when a user withdraws ERC20 tokens
    /// @param receiver The address receiving the tokens
    /// @param amount The amount of ERC20 tokens withdrawn
    event TokenWithdrawal(address indexed receiver, uint256 amount);

    /// @param _tokenAddress The address of the ERC20 token to accept
    constructor(address _tokenAddress) ERC20("Wrapped Sinclair", "WEST") {
        token = IERC20(_tokenAddress);
    }

    /**
     * @notice Deposit ETH or ERC20 tokens to receive wrapped tokens (1:1)
     * @dev If `msg.value > 0`, deposits ETH. Otherwise deposits ERC20 tokens.
     *      Mint wrapped tokens equal to deposited amount.
     * @param asset The type of asset to deposit (ETH or TOKEN)
     * @param _amount Amount of ERC20 tokens to deposit (0 if depositing ETH)
     */
    function deposit(AssetType asset, uint256 _amount) public payable {
        if (asset == AssetType.ETH) {
            if (msg.value == 0) revert ZeroEthAmount();
            balanceInETH += msg.value;
            balanceInETHForUser[msg.sender] += msg.value;
            _mint(msg.sender, msg.value);
            emit EthDeposit(msg.sender, msg.value);
        } else {
            if (_amount == 0) revert ZeroTokenAmount();
            token.safeTransferFrom(msg.sender, address(this), _amount);
            _mint(msg.sender, _amount);
            emit TokenDeposit(msg.sender, _amount);
        }
    }

    /**
     * @notice Withdraw ETH or ERC20 tokens by burning wrapped tokens
     * @dev Burns wrapped tokens equal to withdrawn amount.
     *      For ETH, ensures user has sufficient ETH deposited.
     *      For tokens, transfers tokens held by contract to user.
     * @param asset The type of asset to withdraw (ETH or TOKEN)
     * @param _amount The amount to withdraw
     */
    function withdraw(AssetType asset, uint256 _amount) public {
        if (_amount == 0) revert WithdrawAmountZero();

        if (asset == AssetType.ETH) {
            if (_amount > balanceInETHForUser[msg.sender]) revert InsufficientEthDeposit();
            balanceInETH -= _amount;
            balanceInETHForUser[msg.sender] -= _amount;
            _burn(msg.sender, _amount);

            (bool success,) = payable(msg.sender).call{value: _amount}("");
            require(success, "ETH transfer failed");

            emit EthWithdrawal(msg.sender, _amount);
        } else {
            // No need to check token balance of user, only contract's token balance matters
            _burn(msg.sender, _amount);
            token.safeTransfer(msg.sender, _amount);

            emit TokenWithdrawal(msg.sender, _amount);
        }
    }
}
