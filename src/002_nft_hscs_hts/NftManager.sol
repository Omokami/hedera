// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

import './HederaResponseCodes.sol';
import './IHederaTokenService.sol';
import './HederaTokenService.sol';
import './ExpiryHelper.sol';


contract NftManager is ExpiryHelper {

    function createNft(
            string memory name, 
            string memory symbol, 
            string memory memo, 
            uint32 maxSupply,  
            uint32 autoRenewPeriod
        ) external payable returns (address){

        IHederaTokenService.TokenKey[] memory keys = new IHederaTokenService.TokenKey[](1);
        keys[0] = getSingleKey(HederaTokenService.FREEZE_KEY_TYPE, KeyHelper.CONTRACT_ID_KEY, address(this));
        //keys[1] = getSingleKey(HederaTokenService.SUPPLY_KEY_TYPE, KeyHelper.CONTRACT_ID_KEY, address(this));

        IHederaTokenService.HederaToken memory token;
        token.name = name;
        token.symbol = symbol;
        token.memo = memo;
        token.treasury = address(this);
        token.tokenSupplyType = true; // set supply to FINITE
        token.maxSupply = maxSupply;
        token.tokenKeys = keys;
        token.freezeDefault = true;
        token.expiry = getAutoRenewExpiry(address(this), autoRenewPeriod); // Contract automatically renew by himself

        (int responseCode, address createdToken) = HederaTokenService.createNonFungibleToken(token);

        if(responseCode != HederaResponseCodes.SUCCESS){
            revert("Failed to create non-fungible token");
        }
        return createdToken;
    }

    function mintNft() external {

    }

    function transferNft() external {

    }

}