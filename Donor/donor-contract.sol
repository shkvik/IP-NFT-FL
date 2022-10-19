// SPDX-License-Identifier: FarcanaLabs

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

struct Donor {
    bool     isValue;
    bytes32  deviceKey;
    string   dataURI;
}

struct Device {
    bool    isValue;
    string  name;
    address owner;
}

contract DonorContract {

    uint256 public donorCount;
    
    mapping(bytes32 => Device) public registeredDevices;
    mapping(address => Donor)  public registeredDonors;

    event ePlayerRegistration(address indexed studioWallet, string  indexed studioName);
        
    function _getPlayersCount() internal view returns (uint256){
        return donorCount;
    }

    function _addDevice(string memory deviceName, string memory secretKey) internal returns (bytes32) {
        bytes32 deviceHash = keccak256(abi.encode(secretKey));
        require(!registeredDevices[deviceHash].isValue, 'your device already registered');
        Device memory device;
        device.isValue = true;
        device.name = deviceName;
        registeredDevices[deviceHash] = device;
        return deviceHash;
    }
    
    //Every person who have device hashcode can register
    function _donorRegistration(bytes32 deviceHashCode, string memory dataURI) internal {
        require(registeredDevices[deviceHashCode].isValue, 'this device code is not valid');
        require(registeredDevices[deviceHashCode].owner != msg.sender, 'this device already registered');
        require(!registeredDonors[msg.sender].isValue, 'you are already registered');
        registeredDevices[deviceHashCode].owner = msg.sender;

        Donor memory donor;
        donor.isValue = true;
        donor.dataURI = dataURI;
        donor.deviceKey = deviceHashCode;
        registeredDonors[msg.sender] = donor;
        donorCount++;
    }
}