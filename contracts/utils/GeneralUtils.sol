// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

error Unauthorized();
error InvalidInputDetected();
error InSufficientFunds();
error InSufficientTokens();
error AddressBlacklisted();
error DataIsImmutable();
error SaleIsOver();

/**
Notes : Every token has fractional Tokens
meaning if you are having 1 ERC20 on 18 decimal that means your supply would be
1* 10**18 (there is no decimal points although it is kinda considered ...)
*/

contract BaseContract {
    address internal owner;
    uint256 internal immutable oneEtherInWei = 1 * 10**18;
    uint256 internal immutable minimumTransfer = 1_000 * 10**18;
    uint256 internal immutable pricePerOneToken = 1_000_000_000_000_000;
    uint256 internal immutable initialSalesSupply = 10_000_000 * 10**18;
    uint256 internal immutable payBackFactor = 0.5 ether;
    mapping(address => bool) internal blacklistMap;

    modifier ownerCheck() {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        _;
    }

    function checkSufficientFunds(bool isLimitEther, uint256 fundLimit)
        internal
        view
    {
        if (isLimitEther && msg.value < (fundLimit * (1 ether))) {
            revert InSufficientFunds();
        } else {
            if (msg.value < fundLimit) {
                revert InSufficientFunds();
            }
        }
    }

    function validateAddress(address validatingAddress) internal pure {
        if (validatingAddress == address(0)) {
            revert InvalidInputDetected();
        }
    }

    function payUserEther(uint256 returningEther)
        internal
        returns (bool success)
    {
        success = false;
        if (returningEther > 0 && returningEther < type(uint256).max) {
            //            (success,) = (msg.sender).call{value : returningEther}("");
            payable(msg.sender).transfer(address(this).balance);
            success = true;
        }
    }
}
