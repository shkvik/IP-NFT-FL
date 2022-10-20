// SPDX-License-Identifier: FarcanaLabs

pragma solidity ^0.8.0;
pragma abicoder v2;

import "../Donor/donor-contract.sol";
import "../GameStudio/gameStudio-contract.sol";
import "../Investor/investor-contract.sol";


contract CommonContract is DonorContract, GameStudioContract, InvestorContract {

    // function decodeExample(uint256 deviceId, string memory key) external view returns(bool) {
    //     bytes32 variable = keccak256(abi.encode(key));
    //     return registeredDevices[deviceId].key == variable ? true : false;
    // }
}