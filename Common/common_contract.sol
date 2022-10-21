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

    function _guaranteedReturn(address payable to) internal {
        if(registeredInvestors[to].isValue){
            to.transfer(registeredInvestors[to].coins * coinCost);
        }
        else if(registeredDonors[to].isValue){
            to.transfer(registeredDonors[to].coins * coinCost);
        }
        else if(registeredGameStudios[to].isValue){
            to.transfer(registeredGameStudios[to].coins * coinCost);
        }
    }

    function _giveCoinsToGameStudio(address recievier, uint256 coinsCount) internal {
        require(maxSupplyCoins > coinsCount, 'this number of coins exceeds the current limit');
        require(registeredGameStudios[recievier].isValue, 'incorrect studio address');
        registeredGameStudios[recievier].coins += coinsCount;
        maxSupplyCoins -= coinsCount;
    }

    function _giveCoinsToDonor(address recievier, uint256 coinsCount) internal {
        require(maxSupplyCoins > coinsCount, 'this number of coins exceeds the current limit');
        require(registeredDonors[recievier].isValue, 'incorrect donor address');
        registeredDonors[recievier].coins += coinsCount;
        maxSupplyCoins -= coinsCount;
    }

    function _giveCoinsToInvestor(address recievier, uint256 coinsCount) internal {
        require(maxSupplyCoins > coinsCount, 'this number of coins exceeds the current limit');
        require(registeredInvestors[recievier].isValue, 'incorrect investor address');
        registeredInvestors[recievier].coins += coinsCount;
        maxSupplyCoins -= coinsCount;
    }

    function _giveCoinsToScientist(uint256 coinsCount) internal {
        require(maxSupplyCoins > coinsCount, 'this number of coins exceeds the current limit');
        scientist.coins += coinsCount;
        maxSupplyCoins -= coinsCount;
    }

    function _penaltyDeadlineScientist(uint256 coinsCount) internal {
        require(scientist.deadline < block.timestamp, 'the scientist did not violate the deadlines');
        require(scientist.coins > coinsCount, 'this number of coins exceeds the current limit');
        scientist.coins -= coinsCount;
        maxSupplyCoins += coinsCount;
    }
}