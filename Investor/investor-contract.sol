// SPDX-License-Identifier: FarcanaLabs

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

struct Investor {
    uint256 id;
    address person;
    uint256 balance;
}

contract InvestorContract {
    uint256   public  investBalance;
    uint256   private investorsCount;
    uint256   private minimum = 0.05 ether;
    address[] public  investorWallets;

    mapping(address => Investor) public investors;
    
    function _investMoney() internal {
        require(msg.value > minimum, 'your investment amount is below the minimum');

        if(investors[msg.sender].id == 0){
            investorsCount++;
            Investor memory investor;
            investor.id = investorsCount;
            investor.person = msg.sender;
            investor.balance = msg.value;
            investors[msg.sender] = investor;
            investorWallets.push(msg.sender);
        }
        else {
            investors[msg.sender].balance += msg.value;
        }
    }

    function _returnMoney(address payable payer) internal {
        investors[msg.sender];
        require(investors[msg.sender].id > 0, 'zero id');
        require(investors[msg.sender].balance > minimum, ''); //Уточнить условия
        investBalance -= investors[msg.sender].balance;
        payable(payer).transfer(investors[msg.sender].balance);
        delete investors[msg.sender];
    }

    function _getInvestorWallets() internal view returns (address[] memory){
        return investorWallets;
    }
}

