// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

import "../Donor/donor-contract.sol";
import "../GameStudio/gameStudio-contract.sol";
import "../Investor/investor-contract.sol";
import "../Scientist/scientist-contract.sol";

enum Role {
    None,
    Donor,
    Investor,
    GameStudio,
    Scientist
}

struct User {
    bool    isMinted;
    Role    role;
    uint256 tokenId;
}

contract CommonContract is DonorContract, GameStudioContract, InvestorContract, ScientistContract {

    function _whenFirstInvestAmountReady() internal {
        address payable sci_wallet = payable(scientist.wallet);
        uint256 finalAmount = (initialNumberOfCoins - farcanaLabsShare) * coinCost;
        sci_wallet.transfer(finalAmount);
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
}