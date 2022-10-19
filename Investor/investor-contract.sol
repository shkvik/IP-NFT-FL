// SPDX-License-Identifier: FarcanaLabs

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

struct Investor {
    bool    isValue;
    uint256 coins;
}

contract InvestorContract {
    uint256 public requiredInvestmentAmount;
    uint256 public maxSupplyCoins;
    uint256 public coinCost;
    uint256 public investorsCount;

    event purchaseCoins(address indexed investor, uint256 count);

    mapping(address => Investor) public registeredInvestors;
    
    function _setCoinBalance(uint256 coinsCount, uint256 amount) internal {
        maxSupplyCoins = coinsCount;
        requiredInvestmentAmount = amount;
        coinCost = (amount / coinsCount);
    }

    function _buyCoins(uint256 coinCount) internal {
        require(maxSupplyCoins > coinCount, 'this number of coins exceeds the current limit');
        require(msg.value == (coinCost * coinCount), 'incorrect amount');
        if(!registeredInvestors[msg.sender].isValue) addNewInvestor();
        else registeredInvestors[msg.sender].coins += coinCount;
        maxSupplyCoins -= coinCount;
        emit purchaseCoins(msg.sender, coinCount);
    }

    function addNewInvestor() private {
        investorsCount++;
        Investor memory investor;
        investor.isValue = true;
        registeredInvestors[msg.sender] = investor;
    }
}

