// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

contract DigitalIdentity {
    struct Identity {
        string id;
        string name;
        string dateOfBirth;
        string placeOfBirth;
    }

    error IdentityAlreadyExists();
    error IdentityNotFound(address user);

    address private officer;

    constructor() {
        officer = msg.sender;
    }

    modifier onlyOfficer() {
        require(officer == msg.sender, "Only officer can perform this action");
        _;
    }

    mapping(address => Identity) private identities;

    event IdentityCreated(address indexed user, string id, string name, string dateOfBirth, string placeOfBirth);
    event IdentityUpdated(address indexed user, string id, string name, string dateOfBirth, string placeOfBirth);

    function createIdentity(string calldata _id, string calldata _name, string calldata _dateOfBirth, string calldata _placeOfBirth) public {
        if (bytes(identities[msg.sender].id).length != 0) revert IdentityAlreadyExists();

        identities[msg.sender] = Identity(_id, _name, _dateOfBirth, _placeOfBirth);
        emit IdentityCreated(msg.sender, _id, _name, _dateOfBirth, _placeOfBirth);
    }

    function updateIdentity(address _user, string calldata _id, string calldata _name, string calldata _dateOfBirth, string calldata _placeOfBirth) public onlyOfficer {
        if (bytes(identities[_user].id).length == 0) revert IdentityNotFound(_user);

        identities[_user] = Identity(_id, _name, _dateOfBirth, _placeOfBirth);
        emit IdentityUpdated(_user, _id, _name, _dateOfBirth, _placeOfBirth);
    }

    function getIdentity(address _user) public view returns (string memory _id, string memory _name, string memory _dateOfBirth, string memory _placeOfBirth) {
        Identity memory identity = identities[_user];
        if (bytes(identity.id).length == 0) revert IdentityNotFound(_user);

        return (identity.id, identity.name, identity.dateOfBirth, identity.placeOfBirth);
    }
}