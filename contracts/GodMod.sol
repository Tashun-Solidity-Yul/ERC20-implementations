// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import {Unauthorized,InSufficientFunds,InvalidInputDetected, BaseContract} from "./utils/GeneralUtils.sol";

contract GodMod is ERC20, BaseContract {
    

    constructor(string memory tokenName, string memory tokenSymbol) ERC20(tokenName, tokenSymbol) {
        owner= msg.sender;
    }


    function mintTokensToAddress(address recipient, uint supply) external ownerCheck {
        validateAddress(recipient);
        validateInt(supply);
        _mint(recipient, supply);
    }

    function changeBalanceAtAddress(address target, uint supply) external ownerCheck {
        validateAddress(target);
        validateInt(supply);
        _burn(target, supply);
    }

    function authoritativeTransferFrom(address from, address to, uint amount)  external ownerCheck {
        validateAddress(from);
        validateAddress(to);
        validateInt(amount);
        _transfer(from, to ,amount);
    }
}
