// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OwnerPropertyToken is ERC721, Ownable {
    uint256 public nextTokenId;

    struct Property {
        string urlPhoto;
        string locationAddress;
        uint32 buildingArea;
        uint32 landArea;
        string postalCode;
        string city;
        string province;
        string nib;
        string sertificateNumber;
        string subdistrict;
    }

    mapping(uint256 => Property) public properties;

    event PropertyRegistered(
        uint256 indexed tokenId,
        address indexed owner
    );

    constructor() ERC721("PropertyToken", "PTKN") Ownable(msg.sender) {}

    error RegisterYourIdentityFirst();

    struct RegisterPropertyParams {
        string urlPhoto;
        string locationAddress;
        uint32 buildingArea;
        uint32 landArea;
        string postalCode;
        string city;
        string province;
        string nib;
        string sertificateNumber;
        string subdistrict;
    }

    function registerProperty(
        RegisterPropertyParams calldata params
    ) external {
        uint256 tokenId = nextTokenId;
        Property memory newProperty = Property({
            urlPhoto: params.urlPhoto,
            locationAddress: params.locationAddress,
            buildingArea: params.buildingArea,
            landArea: params.landArea,
            postalCode: params.postalCode,
            city: params.city,
            province: params.province,
            nib: params.nib,
            sertificateNumber: params.sertificateNumber,
            subdistrict: params.subdistrict
        });
        properties[tokenId] = newProperty;
        _safeMint(msg.sender, tokenId);
        nextTokenId++;

        emit PropertyRegistered(
            tokenId,
            msg.sender
        );
    }
}
