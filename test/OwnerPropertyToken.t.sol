// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/OwnerPropertyToken.sol";

contract OwnerPropertyTokenTest is Test {
    OwnerPropertyToken public tokenContract;

    function setUp() public {
        tokenContract = new OwnerPropertyToken();
    }

    function testRegisterProperty() public {
        OwnerPropertyToken.RegisterPropertyParams memory params = OwnerPropertyToken.RegisterPropertyParams({
            urlPhoto: "https://example.com/photo.jpg",
            locationAddress: "123 Blockchain St.",
            buildingArea: 120,
            landArea: 300,
            postalCode: "12345",
            city: "Metropolis",
            province: "Crypto Province",
            nib: "NIB123456789",
            sertificateNumber: "CERT123456",
            subdistrict: "Central District"
        });

        vm.prank(address(1)); 
        tokenContract.registerProperty(params);


        uint256 tokenId = tokenContract.nextTokenId() - 1;

        (string memory urlPhoto, 
        string memory locationAddress, 
        uint32 buildingArea, 
        uint32 landArea, 
        string memory postalCode, 
        string memory city, 
        string memory province, 
        string memory nib, 
        string memory sertificateNumber, 
        string memory subdistrict) = tokenContract.properties(tokenId);

        assertEq(urlPhoto, "https://example.com/photo.jpg");
        assertEq(locationAddress, "123 Blockchain St.");
        assertEq(buildingArea, 120);
        assertEq(landArea, 300);
        assertEq(postalCode, "12345");
        assertEq(city, "Metropolis");
        assertEq(province, "Crypto Province");
        assertEq(nib, "NIB123456789");
        assertEq(sertificateNumber, "CERT123456");
        assertEq(subdistrict, "Central District");

        assertEq(tokenContract.ownerOf(tokenId), address(1));
    }

    function testRegisterMultipleProperties() public {
        OwnerPropertyToken.RegisterPropertyParams memory params1 = OwnerPropertyToken.RegisterPropertyParams({
            urlPhoto: "https://example.com/photo1.jpg",
            locationAddress: "123 Blockchain St.",
            buildingArea: 120,
            landArea: 300,
            postalCode: "12345",
            city: "Metropolis",
            province: "Crypto Province",
            nib: "NIB123456789",
            sertificateNumber: "CERT123456",
            subdistrict: "Central District"
        });

        OwnerPropertyToken.RegisterPropertyParams memory params2 = OwnerPropertyToken.RegisterPropertyParams({
            urlPhoto: "https://example.com/photo2.jpg",
            locationAddress: "456 Decentral Ave.",
            buildingArea: 150,
            landArea: 400,
            postalCode: "67890",
            city: "Blockchain City",
            province: "Smart Contract Province",
            nib: "NIB987654321",
            sertificateNumber: "CERT654321",
            subdistrict: "Decentral District"
        });

        vm.prank(address(1));
        tokenContract.registerProperty(params1);

        vm.prank(address(2));
        tokenContract.registerProperty(params2);

        uint256 tokenId1 = 0;
        uint256 tokenId2 = 1;

        (string memory urlPhoto1, 
        string memory locationAddress1, 
        uint32 buildingArea1, 
        uint32 landArea1, 
        string memory postalCode1, 
        string memory city1, 
        string memory province1, 
        string memory nib1, 
        string memory sertificateNumber1, 
        string memory subdistrict1) = tokenContract.properties(tokenId1);

        (string memory urlPhoto2, 
        string memory locationAddress2, 
        uint32 buildingArea2, 
        uint32 landArea2, 
        string memory postalCode2, 
        string memory city2, 
        string memory province2, 
        string memory nib2, 
        string memory sertificateNumber2, 
        string memory subdistrict2) = tokenContract.properties(tokenId2);

        assertEq(urlPhoto1, "https://example.com/photo1.jpg");
        assertEq(locationAddress1, "123 Blockchain St.");
        assertEq(urlPhoto2, "https://example.com/photo2.jpg");
        assertEq(locationAddress2, "456 Decentral Ave.");

        assertEq(tokenContract.ownerOf(tokenId1), address(1));
        assertEq(tokenContract.ownerOf(tokenId2), address(2));
    }

    function testFailIfNotOwnerTriesToRegister() public {
        OwnerPropertyToken.RegisterPropertyParams memory params = OwnerPropertyToken.RegisterPropertyParams({
            urlPhoto: "https://example.com/photo.jpg",
            locationAddress: "123 Blockchain St.",
            buildingArea: 120,
            landArea: 300,
            postalCode: "12345",
            city: "Metropolis",
            province: "Crypto Province",
            nib: "NIB123456789",
            sertificateNumber: "CERT123456",
            subdistrict: "Central District"
        });

        vm.expectRevert("Ownable: caller is not the owner"); 
        tokenContract.registerProperty(params);
    }

    function testPropertyRegisteredEvent() public {
        OwnerPropertyToken.RegisterPropertyParams memory params = OwnerPropertyToken.RegisterPropertyParams({
            urlPhoto: "https://example.com/photo.jpg",
            locationAddress: "123 Blockchain St.",
            buildingArea: 120,
            landArea: 300,
            postalCode: "12345",
            city: "Metropolis",
            province: "Crypto Province",
            nib: "NIB123456789",
            sertificateNumber: "CERT123456",
            subdistrict: "Central District"
        });

        vm.prank(address(1)); 

        vm.expectEmit(true, true, true, true);
        emit OwnerPropertyToken.PropertyRegistered(0, address(1));

        tokenContract.registerProperty(params);
    }
}
