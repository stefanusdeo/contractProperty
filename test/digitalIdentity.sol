// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/DigitalIdentity.sol";

contract DigitalIdentityTest is Test {
    DigitalIdentity public digitalIdentity;

    address officer = address(1);
    address user1 = address(2);
    address user2 = address(3);

    function setUp() public {
        vm.prank(officer);
        digitalIdentity = new DigitalIdentity();
    }

    function testCreateIdentity() public {
        vm.prank(user1);
        digitalIdentity.createIdentity("ID001", "Alice", "01-01-1990", "New York");

        (string memory id, string memory name, string memory dateOfBirth, string memory placeOfBirth) = digitalIdentity.getIdentity(user1);
        assertEq(id, "ID001");
        assertEq(name, "Alice");
        assertEq(dateOfBirth, "01-01-1990");
        assertEq(placeOfBirth, "New York");
    }

    function testCreateIdentityAlreadyExists() public {
        vm.prank(user1);
        digitalIdentity.createIdentity("ID001", "Alice", "01-01-1990", "New York");

        vm.prank(user1);
        vm.expectRevert(DigitalIdentity.IdentityAlreadyExists.selector);
        digitalIdentity.createIdentity("ID002", "Alice", "02-02-1991", "Los Angeles");
    }

    function testUpdateIdentity() public {
        vm.prank(user1);
        digitalIdentity.createIdentity("ID001", "Alice", "01-01-1990", "New York");


        vm.prank(officer);
        digitalIdentity.updateIdentity(user1, "ID002", "Alice Updated", "02-02-1991", "Los Angeles");


        (string memory id, string memory name, string memory dateOfBirth, string memory placeOfBirth) = digitalIdentity.getIdentity(user1);
        assertEq(id, "ID002");
        assertEq(name, "Alice Updated");
        assertEq(dateOfBirth, "02-02-1991");
        assertEq(placeOfBirth, "Los Angeles");
    }

    function testUpdateIdentityNotFound() public {
        vm.prank(officer);
        vm.expectRevert(abi.encodeWithSelector(DigitalIdentity.IdentityNotFound.selector, user2));
        digitalIdentity.updateIdentity(user2, "ID003", "Bob", "03-03-1992", "Chicago");
    }

    function testOnlyOfficerCanUpdateIdentity() public {
        vm.prank(user1);
        digitalIdentity.createIdentity("ID001", "Alice", "01-01-1990", "New York");

        vm.prank(user2);
        vm.expectRevert("Only officer can perform this action");
        digitalIdentity.updateIdentity(user1, "ID002", "Alice Updated", "02-02-1991", "Los Angeles");
    }

    function testGetIdentityNotFound() public {
        vm.expectRevert(abi.encodeWithSelector(DigitalIdentity.IdentityNotFound.selector, user1));
        digitalIdentity.getIdentity(user1);
    }
}
