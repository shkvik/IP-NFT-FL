// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

import "../Donor/donor-contract.sol";
import "../GameStudio/gameStudio-contract.sol";
import "../Investor/investor-contract.sol";
import "../Scientist/scientist-contract.sol";

string constant  dnrImg = "Donor.com/";
string constant  invImg = "Investor.pic/";
string constant  gstImg = "Game Studio.pic/";
string constant  sciImg = "Scientist.pic/";

enum Role {
    Investor,
    Donor,
    GameStudio,
    Scientist
}

struct User {
    bool    isMinted;
    Role    role;
    uint256 tokenId;
}

abstract contract CommonContract is DonorContract, GameStudioContract, InvestorContract, ScientistContract {

    function _whenFirstInvestAmountReady() internal {
        scientist.wallet.transfer((initialNumberOfCoins - farcanaLabsShare) * coinCost);
    }

    function _whenGettingBigInvestment(uint256 amount) internal {
        coinCost = amount / initialNumberOfCoins;
    }

    function _guaranteedReturn(address payable to, Role role) internal {
        if(role == Role.Investor)
            to.transfer(registeredInvestors[to].coins * coinCost);
        if(role == Role.Donor)
            to.transfer(registeredDonors[to].coins * coinCost); 
        if(role == Role.GameStudio)
            to.transfer(registeredGameStudios[to].coins * coinCost);
    }

    function _giveMoneyToUser(address recievier, uint256 coinsCount, Role role) internal {
        require(maxSupplyCoins > coinsCount, 'this number of coins exceeds the current limit');
        if(role == Role.Donor) 
            registeredDonors[recievier].coins += coinsCount;
        if(role == Role.GameStudio)
            registeredGameStudios[recievier].coins += coinsCount;
        if(role == Role.Investor)
            registeredInvestors[recievier].coins += coinsCount;
        maxSupplyCoins -= coinsCount;
    }

    function _getURIpic(Role role) internal pure returns(string memory img){
        if(role == Role.Donor)
            return dnrImg;
        if(role == Role.Investor) 
            return invImg;
        if(role == Role.GameStudio)
            return gstImg;
        if(role == Role.Scientist)  
            return sciImg;
    }
}