# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a
script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

### eslint

```eslint
npm i eslint --save-dev 
npm init @eslint/config
npx eslint .\test\TokenSalesWithPartialRefundTest.js 
```
### only prettier
``` only prettier
npm install --save-dev prettier prettier-plugin-solidity
npx prettier --write 'contracts/**/*.sol'
```
### solhint prettier
```solhint prettier
npm install --save-dev solhint solhint-plugin-prettier prettier prettier-plugin-solidity @nomiclabs/hardhat-solhint

npx hardhat check
```