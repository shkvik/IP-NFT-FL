// SPDX-License-Identifier: FarcanaLabs

pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

struct Player {
    uint256 id;
    address person;
    bytes32 deviceKey;
    uint256 scores;
    string[] games;
    string dataURI;
}

struct Device {
    uint256 id;
    bytes32 key;
    string name;
}

contract PlayerContract {

    Device[] internal registeredDevices;
    Player[] internal registeredPlayers;

    mapping(bytes32 => uint256) public deviceHash;

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

    function _addDevice(string memory deviceName, string memory secretKey) internal {
        Device memory device;
        device.key = keccak256(abi.encode(secretKey));
        device.name = deviceName;
        registeredDevices.push(device);
        deviceHash[device.key]++;
    }

    function _playerRegistration(bytes32 personalHashCode, string memory dataURI) internal {
        require(deviceHash[personalHashCode] > 0, 'the device code is not valid');
        Player memory player;
        player.person = msg.sender;
        player.deviceKey = personalHashCode;
        player.dataURI = dataURI;
        registeredPlayers.push(player);
        registeredPlayers[registeredPlayers.length].id = registeredPlayers.length;
    }
}