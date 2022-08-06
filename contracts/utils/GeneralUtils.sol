// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

    error Unauthorized();
    error InvalidInputDetected();
    error InSufficientFunds();
    error AddressBlacklisted();


contract BaseContract {
    address internal owner;

    modifier ownerCheck()  {
        if (msg.sender == owner) {
            revert Unauthorized();
        }
        _;
    }
}
