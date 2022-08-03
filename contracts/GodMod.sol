// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GodMod is ERC20 {
    constructor(string memory tokenName, string memory tokenSymbol, uint256 initialSupply) ERC20(tokenName, tokenSymbol) {
        _mint(msg.sender, initialSupply);
    }


    function mintTokensToAddress(address recipient) public pure {}

    function changeBalanceAtAddress(address target) public pure {}

    function authoritativeTransferFrom(address from, address to)  public pure{}
}
