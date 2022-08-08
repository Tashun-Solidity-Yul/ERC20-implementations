// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

    error Unauthorized();
    error InvalidInputDetected();
    error InSufficientFunds();
    error InSufficientTokens();
    error AddressBlacklisted();
    error DataIsImmutable();
    error SaleIsOver();


contract BaseContract {
    address internal owner;
    uint constant oneEtherInWei = 1000000000000000000;
    uint constant minimumTransfer = 1000;
    uint constant pricePerOneToken = 1000000000000000;

    modifier ownerCheck()  {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        _;
    }
    modifier checkSufficientFunds(bool isLimitEther, uint fundLimit) {
        if (fundLimit >= type(uint).max){
            revert InvalidInputDetected();
        }
        if (isLimitEther && msg.value < (fundLimit * (1 ether))) {
            revert InSufficientFunds();
        } else {
            if (msg.value < fundLimit) {
                 revert InSufficientFunds();
            }
        }
        _;
    }

    function validateAddress(address validatingAddress) internal pure {
         if (validatingAddress <= address(0)) {
           revert InvalidInputDetected();
       }
    }

    function validateInt(uint validatingInt) internal pure {
         if (validatingInt <= 0 || validatingInt == type(uint).max) {
            revert InvalidInputDetected();
        } 
    }

    function payUserEther(uint returningEther) internal returns (bool success){
        success = false;
        if (returningEther > 0 && returningEther < type(uint).max) {
                (success,) = (msg.sender).call{value: returningEther}("");
        }
    }
}
