// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/**
 * @title ETHWrapper
 * @dev A contract that wraps ETH into an ERC20 token
 */
contract ETHWrapper is ERC20{
    

    // Events
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor() ERC20("Wrapped ETH", "WETH") {}

    /**
     * @dev Deposit ETH and receive wrapped WSIN
     */
    function deposit() public payable  {
        require(msg.value > 0, "Cannot deposit zero ETH");
        
        // Mint equal amount of tokens to the sender
        _mint(msg.sender, msg.value);
        
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @dev Allow direct ETH deposits
     */
    receive() external payable {
        deposit();
    }

    /**
     * @dev Withdraw ETH by burning wrapped tokens
     * @param amount Amount of wrapped tokens to burn
     */
    function withdraw(uint256 amount) public  {
        require(amount > 0, "Cannot withdraw zero ETH");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        // Burn tokens first 
        _burn(msg.sender, amount);
        
        // Send ETH to user
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "ETH transfer failed");
        
        emit Withdrawn(msg.sender, amount);
    }
}