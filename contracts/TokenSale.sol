// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenSale is ERC20 {
    constructor(string memory tokenName, string memory tokenSymbol, uint256 initialSupply) ERC20(tokenName, tokenSymbol) {
        _mint(msg.sender, initialSupply);
    }

}
