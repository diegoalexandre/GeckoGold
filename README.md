
# GeckoGold Token

GeckoGold ($GECKO) is an ERC-20 token developed to provide exclusive features, community rewards, and support integration in games and platforms.

---

## Main Features

### 1. **Total Supply**
- **Total Amount:** 420,690,000,000 tokens.
- **Initial Distribution:**
  - 40% will be burned periodically.
  - 35% for initial liquidity.
  - 15% for marketing and community rewards.
  - 10% for the team and development.

### 2. **Transaction Fees**
- **Standard Fee:** 2%.
- **Fee Destination:** Redirected to the contract owner.
- **Maximum Allowed Fee:** 10%.

### 3. **Engagement Rewards**
- Users can accumulate engagement points that can be converted into $GECKO tokens.
- **Maximum Points Limit:** 10,000 per user.
- **Cooldown for Redemption:** 24 hours between each redemption.

### 4. **Token Burn**
- Any user can burn their own tokens.
- The owner can burn additional tokens from the total supply.

### 5. **Additional Protections**
- **Blacklist:** Users can be prevented from making transactions.
- **Pause:** The owner can pause all transactions in case of emergency.
- **Maximum Transfer:** Each transaction is limited to 1,000,000 $GECKO at a time.
- **No Transfers to Contract:** Sending tokens to the contract address is prohibited.

---

## Important Functions

### **Community Engagement**
- **Update Points:**
  The owner can reward users with engagement points.

  ```solidity
  function updateEngagementPoints(address user, uint256 points) external onlyOwner;
  ```

- **Deduct Points:**
  The owner can remove engagement points if necessary.

  ```solidity
  function deductEngagementPoints(address user, uint256 points) external onlyOwner;
  ```

- **Claim Rewards:**
  Users can convert their points into $GECKO tokens.

  ```solidity
  function claimReward() external;
  ```

### **Contract Management**
- **Pause Transactions:**
  Allows the owner to pause or resume transactions.

  ```solidity
  function pause() external onlyOwner;
  function unpause() external onlyOwner;
  ```

- **Rescue Stuck Tokens:**
  The owner can recover tokens accidentally sent to the contract.

  ```solidity
  function rescueTokens(address token, uint256 amount) external onlyOwner;
  ```

- **Set Tax Rate:**
  Adjust the transaction fee within the allowed limit.

  ```solidity
  function setTaxRate(uint256 newTaxRate) external onlyOwner;
  ```

---

## How to Interact

### 1. **Deploy the Contract**
- Use Remix Ethereum or frameworks like Hardhat to deploy the contract.
- Make sure to have enough ETH or BNB to cover gas fees.

### 2. **Interaction Tools**
- **Etherscan/BscScan:** To interact directly with the contract functions.
- **Custom Frontend:** A user dashboard can be developed later.

---

## Security and Transparency
- **Audited Code:** The contract was designed with best security practices to avoid common exploits.
- **Events:** All important actions are logged on the blockchain to ensure transparency.

---

## License
This project is licensed under the **MIT License**.
