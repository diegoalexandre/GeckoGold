# GeckoGold Token

GeckoGold ($GECKO) é um token ERC-20 desenvolvido para proporcionar funcionalidades exclusivas, recompensas para a comunidade e suporte à integração em jogos e plataformas.

---

## Características Principais

### 1. **Total Supply**
- **Quantidade Total:** 420,690,000,000 tokens.
- **Distribuição Inicial:**
  - 50% queimados no momento do deploy.
  - 25% para liquidez inicial.
  - 15% para marketing e recompensas comunitárias.
  - 10% para a equipe e desenvolvimento.

### 2. **Taxas de Transação**
- **Taxa padrão:** 2%.
- **Destino da Taxa:** Redirecionada ao proprietário do contrato.
- **Taxa máxima permitida:** 10%.

### 3. **Recompensas de Engajamento**
- Usuários podem acumular pontos de engajamento que podem ser convertidos em tokens $GECKO.
- **Limite máximo de pontos:** 10,000 por usuário.
- **Cooldown para resgate:** 24 horas entre cada resgate.

### 4. **Queima de Tokens**
- Qualquer usuário pode queimar seus próprios tokens.
- O proprietário pode queimar tokens adicionais do supply total.

### 5. **Proteções Adicionais**
- **Blacklist:** Usuários podem ser impedidos de realizar transações.
- **Pause:** O proprietário pode pausar todas as transações em casos de emergência.
- **Máximo de transferência:** Cada transação é limitada a 1,000,000 $GECKO por vez.
- **Sem transferências para o contrato:** Proibido enviar tokens para o endereço do contrato.

---

## Funções Importantes

### **Engajamento Comunitário**
- **Atualizar Pontos:**
  O proprietário pode premiar usuários com pontos de engajamento.

  ```solidity
  function updateEngagementPoints(address user, uint256 points) external onlyOwner;
  ```

- **Deduzir Pontos:**
  O proprietário pode remover pontos de engajamento se necessário.

  ```solidity
  function deductEngagementPoints(address user, uint256 points) external onlyOwner;
  ```

- **Resgatar Recompensas:**
  Usuários podem converter seus pontos em tokens $GECKO.

  ```solidity
  function claimReward() external;
  ```

### **Gerenciamento do Contrato**
- **Pausar Transações:**
  Permite ao proprietário pausar ou retomar transações.

  ```solidity
  function pause() external onlyOwner;
  function unpause() external onlyOwner;
  ```

- **Resgate de Tokens Presos:**
  O proprietário pode recuperar tokens enviados acidentalmente ao contrato.

  ```solidity
  function rescueTokens(address token, uint256 amount) external onlyOwner;
  ```

- **Configurar Taxa:**
  Ajustar a taxa de transação dentro do limite permitido.

  ```solidity
  function setTaxRate(uint256 newTaxRate) external onlyOwner;
  ```

---

## Como Interagir

### 1. **Deploy do Contrato**
- Utilize o Remix Ethereum ou frameworks como Hardhat para realizar o deploy.
- Certifique-se de possuir saldo suficiente em ETH ou BNB para cobrir as taxas de gás.

### 2. **Ferramentas de Interação**
- **Etherscan/BscScan:** Para interagir diretamente com as funções do contrato.
- **Frontend Personalizado:** Um painel de controle para usuários pode ser desenvolvido posteriormente.

---

## Segurança e Transparência
- **Código Auditado:** O contrato foi projetado com boas práticas de segurança para evitar exploits comuns.
- **Eventos:** Todas as ações importantes são registradas na blockchain para garantir transparência.

---

## Licença
Este projeto está licenciado sob a **MIT License**.
