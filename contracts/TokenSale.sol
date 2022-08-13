// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;



import { SaleIsOver, InSufficientFunds, InSufficientTokens, BaseContract} from "./utils/GeneralUtils.sol";
import {Sanctions} from "./Sanctions.sol";

contract TokenSale is Sanctions {

    fallback() external payable {}

    receive() external payable {}

    constructor(string memory tokenName, string memory tokenSymbol) Sanctions(tokenName, tokenSymbol) {
    }

    function mint1000Tokens(address mintingAddress) public payable {
        checkSufficientFunds(false,  msg.value / pricePerOneToken);
        validateAddress(mintingAddress);
        uint256 supplyingTokens = msg.value / pricePerOneToken;
        if (totalSupply() + supplyingTokens <= initialSalesSupply) {
            _mint(mintingAddress, supplyingTokens);
        } else {
            if (totalSupply() < initialSalesSupply) {
                revert InSufficientTokens();
            }
            revert SaleIsOver();
        }
    }

    function getContractBalance() external view ownerCheck returns (uint){
        return address(this).balance;
    }

    function getFundsToOwnersAccount() external ownerCheck {
        if (address(this).balance > 0 && owner != address(0)) {
            (bool success,) = owner.call{value : address(this).balance}("");
            if (!success) {
                revert InSufficientFunds();
            }
        }
    }





}
