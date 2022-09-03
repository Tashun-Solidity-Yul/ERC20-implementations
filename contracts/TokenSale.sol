// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import {SaleIsOver, InSufficientFunds, InSufficientTokens, BaseContract} from "./utils/GeneralUtils.sol";
import {Sanctions} from "./Sanctions.sol";

contract TokenSale is Sanctions {
    fallback() external payable {}

    receive() external payable {}

    constructor(string memory tokenName, string memory tokenSymbol)
        public
        Sanctions(tokenName, tokenSymbol)
    {}

    function mint1000Tokens(address mintingAddress) public payable {
        // if user sent wei which is not divisible by `pricePerOneToken` this will be added to the contract instead of sending to the user
        validateAddress(mintingAddress);
        // tokens sent to User
        uint256 tokensSentToUser = (msg.value / pricePerOneToken) * 10**18;
        if (totalSupply() + tokensSentToUser <= initialSalesSupply) {
            _mint(mintingAddress, tokensSentToUser);
        } else {
            if (totalSupply() < initialSalesSupply) {
                revert InSufficientTokens();
            }
            revert SaleIsOver();
        }
    }

    function getContractBalance() external view ownerCheck returns (uint256) {
        return address(this).balance;
    }

    function getFundsToOwnersAccount() external ownerCheck {
        // payable(msg.sender).transfer(address(this).balance);
        if (address(this).balance > 0) {
            payable(msg.sender).transfer(address(this).balance);
            //            (bool success,) = owner.call{value : address(this).balance}("");
            //            if (!success) {
            //                revert InSufficientFunds();
            //            }
        }
    }
}
