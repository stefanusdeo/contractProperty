// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/OwnerPropertyToken.sol";

contract OwnerPropertyTokenTest is Test {
    OwnerPropertyToken public tokenContract;

    function setUp() public {
        // Deploy contract before each test
        tokenContract = new OwnerPropertyToken();
    }

    function testRegisterProperty() public {
        // Test for successful property registration
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

        vm.prank(address(1)); // simulate transaction from address(1)
        tokenContract.registerProperty(params);

        // Validate the tokenId increment and property stored
        uint256 tokenId = tokenContract.nextTokenId() - 1;
        OwnerPropertyToken.Property memory property = tokenContract.properties(tokenId);

        assertEq(property.urlPhoto, "https://example.com/photo.jpg");
        assertEq(property.locationAddress, "123 Blockchain St.");
        assertEq(property.buildingArea, 120);
        assertEq(property.landArea, 300);
        assertEq(property.postalCode, "12345");
        assertEq(property.city, "Metropolis");
        assertEq(property.province, "Crypto Province");
        assertEq(property.nib, "NIB123456789");
        assertEq(property.sertificateNumber, "CERT123456");
        assertEq(property.subdistrict, "Central District");

        // Validate ownership
        assertEq(tokenContract.ownerOf(tokenId), address(1));
    }

    function testRegisterMultipleProperties() public {
        // Test for registering multiple properties and validate uniqueness of token IDs
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

        vm.prank(address(1)); // simulate transaction from address(1)
        tokenContract.registerProperty(params1);

        vm.prank(address(2)); // simulate transaction from address(2)
        tokenContract.registerProperty(params2);

        // Validate properties and ownership
        uint256 tokenId1 = 0;
        uint256 tokenId2 = 1;

        OwnerPropertyToken.Property memory property1 = tokenContract.properties(tokenId1);
        OwnerPropertyToken.Property memory property2 = tokenContract.properties(tokenId2);

        assertEq(property1.urlPhoto, "https://example.com/photo1.jpg");
        assertEq(property2.urlPhoto, "https://example.com/photo2.jpg");

        assertEq(tokenContract.ownerOf(tokenId1), address(1));
        assertEq(tokenContract.ownerOf(tokenId2), address(2));
    }

    function testFailIfNotOwnerTriesToRegister() public {
        // Test for failure when a non-owner tries to register a property
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

        vm.expectRevert("Ownable: caller is not the owner"); // expect revert from Ownable
        tokenContract.registerProperty(params);
    }

    function testPropertyRegisteredEvent() public {
        // Test that the PropertyRegistered event is emitted correctly
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

        vm.prank(address(1)); // simulate transaction from address(1)

        vm.expectEmit(true, true, true, true);
        emit tokenContract.PropertyRegistered(0, address(1));

        tokenContract.registerProperty(params);
    }
}
