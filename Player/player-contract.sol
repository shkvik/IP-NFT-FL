// SPDX-License-Identifier: FarcanaLabs

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

struct Player {
    uint256  id;
    address  person;
    bytes32  deviceKey;
    //uint256  scores;
    //string[] games;
    string   dataURI;
}

struct Device {
    uint256 id;
    bytes32 key;
    string  name;
}

contract PlayerContract {
    uint256 private playerCount;
    
    Device[] internal registeredDevices;
    Player[] internal registeredPlayers;
    
    mapping(bytes32 => uint256) public deviceHash;
    mapping(bytes32 => uint256) public diviceWithPlayerIdHash;

    event ePlayerRegistration(address indexed studioWallet, string  indexed studioName);
        
    function _getPlayers() internal view returns(Player[] memory){
        return registeredPlayers;
    }
    function _getPlayersCount() internal view returns (uint256){
        return registeredPlayers.length;
    }
    function _getDevices() internal view returns(Device[] memory){
        return registeredDevices;
    }
    function _getDevicesCount() internal view returns (uint256){
        return registeredDevices.length;
    }

    function _addDevice(string memory deviceName, string memory secretKey) internal returns (bytes32) {
        Device memory device;
        device.key = keccak256(abi.encode(secretKey));
        device.name = deviceName;
        registeredDevices.push(device);
        deviceHash[device.key]++;
        return device.key;
    }

    //Every person who have device hashcode can register
    function _playerRegistration(bytes32 personalHashCode, string memory dataURI) internal {
        require(deviceHash[personalHashCode] > 0, 'this device code is not valid');
        require(diviceWithPlayerIdHash[personalHashCode] == 0, 'this device already registered');

        Player memory player;
        player.id = playerCount;
        player.person = msg.sender;
        player.deviceKey = personalHashCode;
        player.dataURI = dataURI;
        registeredPlayers.push(player);
        diviceWithPlayerIdHash[personalHashCode]++;
        playerCount++;
    }
}