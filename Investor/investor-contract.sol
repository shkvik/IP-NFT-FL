// SPDX-License-Identifier: FarcanaLabs
pragma solidity ^0.8.0;

struct Investor {
    bool    isValue;
    uint256 coins;
}

contract InvestorContract {

    uint256 public farcanaLabsShare;
    uint256 public requiredInvestmentAmount;
    uint256 public initialNumberOfCoins;
    uint256 public maxSupplyCoins;
    uint256 public coinCost;
    uint256 public investorsCount;

    event purchaseCoins(address indexed investor, uint256 count);

    mapping(address => Investor) public registeredInvestors;
    
    function farcanaLabsTake(uint256 coinsCount) internal {
        farcanaLabsShare = coinsCount;
        maxSupplyCoins -= coinsCount;
    }

    function setCoinBalance(uint256 coinsCount, uint256 amount) internal {
        initialNumberOfCoins = coinsCount;
        maxSupplyCoins = coinsCount;
        requiredInvestmentAmount = amount;
        coinCost = (amount / coinsCount);
    }

    function _buyCoins(uint256 coinCount) internal {
        require(maxSupplyCoins > coinCount, 'this number of coins exceeds the current limit');
        require(msg.value == (coinCost * coinCount), 'incorrect amount');
        if(!registeredInvestors[msg.sender].isValue) addNewInvestor(coinCount);
        else registeredInvestors[msg.sender].coins += coinCount;
        maxSupplyCoins -= coinCount;
        emit purchaseCoins(msg.sender, coinCount);
    }

    function addNewInvestor(uint256 coins) private {
        investorsCount++;
        Investor memory investor;
        investor.isValue = true;
        investor.coins += coins;
        registeredInvestors[msg.sender] = investor;
    }
}

