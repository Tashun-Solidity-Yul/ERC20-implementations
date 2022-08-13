// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Unauthorized,InSufficientFunds,InvalidInputDetected, BaseContract} from "./utils/GeneralUtils.sol";

contract GodMod is ERC20, BaseContract {
    

    constructor(string memory tokenName, string memory tokenSymbol) ERC20(tokenName, tokenSymbol) {
        owner= msg.sender;
    }


    function mintTokensToAddress(address recipient, uint supply) external ownerCheck {
        validateAddress(recipient);
        _mint(recipient, supply);
    }

    function changeBalanceAtAddress(address target, uint amount) external ownerCheck {
        validateAddress(target);
        _transfer(target, address(this) ,amount);
    }

    function authoritativeTransferFrom(address from, address to, uint amount)  external ownerCheck {
        validateAddress(from);
        validateAddress(to);
        _transfer(from, to ,amount);
    }
}
