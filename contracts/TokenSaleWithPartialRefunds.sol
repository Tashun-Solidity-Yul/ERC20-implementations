// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import {BaseContract} from "./utils/GeneralUtils.sol";
import {TokenSale} from "./TokenSale.sol";


contract TokenSaleWithPartialRefunds is TokenSale {
    constructor(string memory tokenName, string memory tokenSymbol) TokenSale(tokenName, tokenSymbol) {
    }

    function SellBack(uint256 amount) external {
        // user sends a normal amount which is converted to 18 decimal places
        uint256 amountWithDecimals = (amount * 10 ** 18);
        require(userTokenBalance < amountWithDecimals, "Insufficient Tokens to sell");
        uint256 userTokenBalance = balanceOf(msg.sender);

        _transfer(msg.sender, address(this), amount);

        // if the amount is met the minimum amount user is eligible for th reward
        if (amountWithDecimals >= minimumTransfer) {
            // reward factor will be x factor floor value of the minimum transfer
            uint256 rewardFactor = amountWithDecimals / minimumTransfer;
            uint256 payBack = rewardFactor * payBackFactor;
            if (address(this).balance > payBack) {
                // if the reward is possible to pay, user will be paid
                bool success = payUserEther(payBack);
                if (!success) {
                    revert InSufficientFunds();
                }
            } else {
                revert InSufficientFunds();
            }
        }
    }

    function BuyBack(uint256 amount) external payable {
        checkSufficientFunds(false, pricePerOneToken * amount);
        uint256 contractTokenBalance = balanceOf(address(this));
        // check if there are tokens in the contract
        if (contractTokenBalance >= amount) {
            _transfer(address(this), msg.sender, amount);
        } else {
            revert InSufficientTokens();
        }
    }


}
