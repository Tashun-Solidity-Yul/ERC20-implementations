// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import {DataIsImmutable, AddressBlacklisted, InvalidInputDetected, InSufficientFunds, InSufficientTokens, BaseContract} from "./utils/GeneralUtils.sol";
import {TokenSale} from "./TokenSale.sol";


contract TokenSaleWithPartialRefunds is TokenSale {
    constructor(string memory tokenName, string memory tokenSymbol) TokenSale(tokenName, tokenSymbol) {
    }

    function tokenSaleWithRefundSellBack(uint256 amount) external {
        uint contractTokenBalance = balanceOf(msg.sender);
        if (contractTokenBalance >= amount) {
            _transfer(msg.sender, address(this), amount);
        } else{
            revert InSufficientTokens();
        }
        if (amount >= minimumTransfer) {
            uint rewardFactor = amount / minimumTransfer;
            uint payBack = (oneEtherInWei * rewardFactor) / 2;
            if (address(this).balance > payBack) {
                bool success = payUserEther(payBack);
                if (!success) {
                    revert InSufficientFunds();
                }
            } else {
                revert InSufficientFunds();
            }
        }
    }

    function TokenSaleWithRefundBuyBack(uint256 amount) external payable  {
        checkSufficientFunds(false, pricePerOneToken * amount);
        uint contractTokenBalance = balanceOf(address(this));
        if (contractTokenBalance >= amount) {
            _transfer(address(this), msg.sender, amount);
        } else {
            revert InSufficientTokens();
        }
        unchecked {
            uint returningEther = msg.value - (pricePerOneToken * amount);
            if (returningEther > 0) {
                bool success = payUserEther(returningEther);
                if (!success) {
                    revert InSufficientFunds();
                }
            }
        }
    }


}
