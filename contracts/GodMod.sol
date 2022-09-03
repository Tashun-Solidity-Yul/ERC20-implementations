// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {BaseContract} from "./utils/GeneralUtils.sol";

contract GodMod is ERC20, BaseContract {
    constructor(string memory tokenName, string memory tokenSymbol)
        public
        ERC20(tokenName, tokenSymbol)
    {
        owner = msg.sender;
    }

    function mintTokensToAddress(address recipient, uint256 supply)
        public
        ownerCheck
    {
        // As there is no supply limit at this level not handled initialSalesSupply
        _mint(recipient, supply);
    }

    function changeBalanceAtAddress(
        address target,
        uint256 amount,
        bool isBurning
    ) external ownerCheck {
        // If burning will reduce from the supply
        require(amount > 0, "Invalid amount");
        if (isBurning) {
            require(balanceOf(target) > amount, "No Sufficient Amount To Burn");
            _burn(target, amount);
        } else {
            mintTokensToAddress(target, amount);
        }
        // Note ERC20 burn is alright as the supply reduces not assigning to zero address
    }

    function authoritativeTransferFrom(
        address from,
        address to,
        uint256 amount
    ) external ownerCheck {
        // when there is less supply
        require(amount > 0, "Invalid amount");
        _transfer(from, to, amount);
    }
}
