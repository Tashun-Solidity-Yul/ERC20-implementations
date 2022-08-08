// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

import {DataIsImmutable, AddressBlacklisted, InvalidInputDetected, InSufficientFunds, SaleIsOver, BaseContract} from "./utils/GeneralUtils.sol";
import {Sanctions} from "./Sanctions.sol";

contract TokenSale is Sanctions {

    fallback() external payable {}

    receive() external payable {}

    mapping(uint => uint)salesMapping;
    uint selectedSalesId;

    constructor(string memory tokenName, string memory tokenSymbol) Sanctions(tokenName, tokenSymbol) {
        salesMapping[1] = 1000000;
        selectedSalesId = 1;
    }

    function mint1000Tokens(address mintingAddress) public payable checkSufficientFunds(true, 1) {
        validateAddress(mintingAddress);
        if (totalSupply() + 1000 <= salesMapping[selectedSalesId]) {
            _mint(mintingAddress, 1000);
            unchecked {
                uint returningEther = msg.value - (1 ether);
                if (returningEther > 0 ) {
                    bool success = payUserEther(returningEther);
                    if (!success) {
                        revert InSufficientFunds();
                    }
                }
            }
            
        } else {
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




    /////////////////////////////////////////////////////////// Sales Limits ////////////////////////////////////////////////////////////////////////

    function setANewSalesLimit(uint salesId, uint salesLimit) external ownerCheck returns (bool success){
        success = false;
        if (salesId > 0 && salesMapping[salesId] == 0 && salesLimit > 0) {
            salesMapping[salesId] = salesLimit;
            success = true;
        }
        if (!success) {
            revert DataIsImmutable();
        }

    }

    function updateSalesLimit(uint salesId, uint salesLimit) external ownerCheck returns (bool success){
        success = false;
        if (salesId > 0 && salesMapping[salesId] > 0 && salesLimit > 0) {
            salesMapping[salesId] = salesLimit;
            success = true;
        }
        if (!success) {
            revert DataIsImmutable();
        }
    }

    function getSalesLimit(uint salesId) external view ownerCheck returns (uint){
        return salesMapping[salesId];
    }

    function setSales(uint salesId) external ownerCheck {
        selectedSalesId = salesId;
    }
}
