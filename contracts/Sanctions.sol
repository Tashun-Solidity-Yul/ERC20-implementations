// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import { InvalidInputDetected, AddressBlacklisted, BaseContract} from "./utils/GeneralUtils.sol";
import {GodMod} from "./GodMod.sol";

contract Sanctions is GodMod {


    constructor(string memory tokenName, string memory tokenSymbol) GodMod(tokenName, tokenSymbol) {
    }

    function blackListAddress(address blackListingAddress) external ownerCheck {
        validateAddress(blackListingAddress);
        if (blackListingAddress != owner) {
            revert InvalidInputDetected();
        }
        blacklistMap[blackListingAddress] = true;
    }

    function whiteListRestrictAddress(address whiteListingAddress) external ownerCheck {
        validateAddress(whiteListingAddress);
        blacklistMap[whiteListingAddress] = false;
    }

     function _beforeTokenTransfer(address from,address to,uint256 amount) internal override {
         validateAddress(to);
         if (blacklistMap[from] || blacklistMap[to]) {
             revert AddressBlacklisted();
         }
         super._beforeTokenTransfer(from, to, amount);
    }
    

}
