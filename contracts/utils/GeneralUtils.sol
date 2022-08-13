// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

    error Unauthorized();
    error InvalidInputDetected();
    error InSufficientFunds();
    error InSufficientTokens();
    error AddressBlacklisted();
    error DataIsImmutable();
    error SaleIsOver();


contract BaseContract {
    address internal owner;
    uint256 immutable oneEtherInWei = 1_000_000_000_000_000_000;
    uint256 immutable minimumTransfer = 1_000;
    uint256 immutable pricePerOneToken = 1_000_000_000_000_000;
    uint256 immutable initialSalesSupply = 10_000_000;
    mapping(address => bool) internal blacklistMap;

    modifier ownerCheck()  {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        _;
    }
    function checkSufficientFunds(bool isLimitEther, uint fundLimit) internal view{
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
    }

    function validateAddress(address validatingAddress) internal pure {
         if (validatingAddress != address(0)) {
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
