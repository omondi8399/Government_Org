//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Government {
    address[] public citizens;
    address[] public officials;
    address payable owner;
    mapping(address => bool) public isOfficial;
    
    constructor() public {
    owner = payable(msg.sender);
}

    function registerAsCitizen() public {
        require(!isOfficial[msg.sender], "Cannot register as citizen, already registered as official");
        citizens.push(msg.sender);
    }

    function registerAsOfficial() public{
        require(!isOfficial[msg.sender], "Cannot register as official, already registered as citizen");
        officials.push(msg.sender);
        isOfficial[msg.sender] = true;
    }

    function vote(address candidate) public {
        require(!isOfficial[msg.sender], "Official cannot vote");
        require(isOfficial[msg.sender], "Candidate must be registered as official");  
    }

    function proposeLaw(string memory proposal) public {
        require(isOfficial[msg.sender], "Only officials can proposal laws");
    }

    function enactlaw(string memory proposal) public {
        require(msg.sender == owner, "Only the owner can enact laws");
    } 

    function getOfficials() public view returns (address[] memory) {
        return officials;
    }

    function getCitizens() public view returns (address[] memory) {
        return citizens;
    }

    function grantAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can grant access.");
        owner = user;
    }

    function revokeAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can revoke access.");
        require(user != owner, "Cannot revoke access for the current owner.");
        owner = payable(msg.sender);
    }

    function destroy() public {
        require(msg.sender == owner, "Only the owner can destroy the contract");
        selfdestruct(owner);
    }
}

