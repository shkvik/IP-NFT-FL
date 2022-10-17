// SPDX-License-Identifier: FarcanaLabs

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

import "../Player/player-contract.sol";
import "../GameStudio/gameStudio-contract.sol";
import "../Investor/investor-contract.sol";

struct Scientist {
    address person;
}

enum Role {
    Player,
    Investor,
    GameStudio,
    Scientist
}


contract CommonContract is PlayerContract, GameStudioContract, InvestorContract {
    
    uint64 public investorsCount;
    uint64 public scientistsCount;
    uint256 public investedAmount;

    //Investor[]   internal registeredInvestors;
    Scientist[]  internal registeredScientist;

    // function decodeExample(uint256 deviceId, string memory key) external view returns(bool) {
    //     bytes32 variable = keccak256(abi.encode(key));
    //     return registeredDevices[deviceId].key == variable ? true : false;
    // }
}