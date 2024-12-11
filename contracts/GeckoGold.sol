// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract GeckoGold is ERC20, Ownable, ReentrancyGuard {
    // Total supply: 420,690,000,000 tokens (with 18 decimals)
    uint256 public constant TOTAL_SUPPLY = 420_690_000_000 * 10 ** 18;

    uint256 public taxRate = 2; // 2% tax
    uint256 public constant MAX_TAX_RATE = 10; // Maximum allowed tax rate (10%)
    uint256 public constant MAX_TRANSFER_AMOUNT = 1_000_000 * 10 ** 18; // Maximum transfer per transaction
    uint256 public constant MAX_ENGAGEMENT_POINTS = 10000; // Maximum engagement points per user

    mapping(address => bool) private blacklistedAddresses;
    mapping(address => bool) private whitelistAddresses;
    mapping(address => uint256) public engagementPoints;
    mapping(address => uint256) private lastClaimed;
    uint256 public tradingStartBlock;
    bool public tradingEnabled = false;
    bool public paused = false;

    constructor() ERC20("GeckoGold", "GECKO") Ownable(msg.sender) {
        // Distribution of tokens

        // 25% Liquidity pool
        _mint(msg.sender, (TOTAL_SUPPLY * 25) / 100);

        // 15% Marketing and community rewards
        _mint(0x02bFf1B7B4e9F2483b429afbA11DDB474F552678, (TOTAL_SUPPLY * 25) / 100); // Replace with your marketing wallet address

        // 10% Team and development (vesting handled off-chain)
        _mint(0x78F48f0a33277Ac7ff8672f9a71596759cf489D2, (TOTAL_SUPPLY * 50) / 100); // Replace with your team wallet address
    }

    // Function to set an address as blacklisted
    function setBlacklist(address _address, bool _isBlacklisted) external onlyOwner {
        blacklistedAddresses[_address] = _isBlacklisted;
    }

    // Modifier to check if an address is blacklisted
    modifier notBlacklisted(address _address) {
        require(!blacklistedAddresses[_address], "Address is blacklisted");
        _;
    }

    // Modifier to check if trading is enabled or sender is whitelisted
    modifier tradingGuard(address sender) {
        require(tradingEnabled || whitelistAddresses[sender], "Trading is not enabled");
        _;
    }

    // Modifier to ensure transfers are not paused
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    // Modifier to enforce cooldown on claim rewards
    modifier cooldownPeriod(address user) {
        require(block.timestamp >= lastClaimed[user] + 1 days, "Claim cooldown active");
        _;
    }

    // Modifier to prevent self-transfer
    modifier noSelfTransfer(address recipient) {
        require(recipient != address(this), "Cannot transfer to the contract itself");
        _;
    }

    // Enable trading and set the start block
    function enableTrading() external onlyOwner {
        tradingEnabled = true;
        tradingStartBlock = block.number;
    }

    // Add an address to the whitelist
    function addToWhitelist(address _address) external onlyOwner {
        whitelistAddresses[_address] = true;
    }

    // Remove an address from the whitelist
    function removeFromWhitelist(address _address) external onlyOwner {
        whitelistAddresses[_address] = false;
    }

    // Update the tax rate
    function setTaxRate(uint256 newTaxRate) external onlyOwner {
        require(newTaxRate <= MAX_TAX_RATE, "Tax rate exceeds maximum limit");
        taxRate = newTaxRate;
    }

    // Overridden transfer function with additional checks
    function transfer(address recipient, uint256 amount) public override notBlacklisted(msg.sender) tradingGuard(msg.sender) whenNotPaused noSelfTransfer(recipient) returns (bool) {
        require(amount <= MAX_TRANSFER_AMOUNT, "Exceeds maximum transfer amount");

        uint256 tax = (amount * taxRate) / 100;
        uint256 amountAfterTax = amount - tax;

        // Tax sent to contract owner
        _transfer(msg.sender, owner(), tax);
        return super.transfer(recipient, amountAfterTax);
    }

    // Function to burn tokens (users can burn their own tokens)
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    // Function to burn supply (onlyOwner can call this)
    function burnSupply(uint256 amount) external onlyOwner {
        _burn(owner(), amount);
        emit TokensBurned(owner(), amount);
    }

    // Function to update engagement points
    function updateEngagementPoints(address user, uint256 points) external onlyOwner {
        require(engagementPoints[user] + points <= MAX_ENGAGEMENT_POINTS, "Exceeds maximum engagement points");
        engagementPoints[user] += points;
        emit EngagementPointsUpdated(user, engagementPoints[user]);
    }

    // Function to deduct engagement points
    function deductEngagementPoints(address user, uint256 points) external onlyOwner {
        require(engagementPoints[user] >= points, "Not enough points");
        engagementPoints[user] -= points;
        emit EngagementPointsUpdated(user, engagementPoints[user]);
    }

    // Function to claim rewards based on engagement points
    function claimReward() external whenNotPaused notBlacklisted(msg.sender) cooldownPeriod(msg.sender) {
        uint256 reward = engagementPoints[msg.sender];
        require(reward > 0, "No rewards available");
        require(balanceOf(owner()) >= reward, "Insufficient reward supply");

        // Reset engagement points
        engagementPoints[msg.sender] = 0;

        // Update last claimed timestamp
        lastClaimed[msg.sender] = block.timestamp;

        // Transfer reward tokens
        _transfer(owner(), msg.sender, reward);
        emit RewardClaimed(msg.sender, reward);
    }

    // Function to retrieve the balance of any address
    function balance(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    // Function to withdraw the contract's ETH balance (protected against reentrancy)
    function withdrawBalance() external onlyOwner nonReentrant {
        payable(owner()).transfer(address(this).balance);
    }

    // Rescue tokens sent to the contract
    function rescueTokens(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner(), amount);
    }

    // Emergency pause for transfers
    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    // Events for transparency
    event TokensBurned(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);
    event EngagementPointsUpdated(address indexed user, uint256 newPoints);
}
