// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

    error Unauthorized();
    error InvalidInputDetected();
    error InSufficientFunds();
    error AddressBlacklisted();
    error DataIsImmutable();


contract BaseContract {
    address internal owner;

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
            if (msg.value <= fundLimit) {
                 revert InSufficientFunds();
            }
        }
        _;
    }

    modifier validateAddress(address validatingAddress) {
         if (validatingAddress <= address(0)) {
           revert InvalidInputDetected();
       }
     _;
    }

    modifier validateInt(uint validatingInt) {
         if (validatingInt <= 0 || validatingInt == type(uint).max) {
            revert InvalidInputDetected();
        } 
     _;
    }
}
