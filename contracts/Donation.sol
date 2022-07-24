/*
1.Deposit amount
2.wrap eth
3.deposit wrapped eth in aave
4.get userData

 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

error Donation__userNotFound();
error Donation__paymentToCreatorFailed();
error Donation__notEnoughEthProvided();
error Donation__notCreator();

contract Donation {
    //state variables

    struct user {
        address userAddress;
        string name;
        string photo;
        string emailId;
        string websiteLink;
        string instagram;
        bool isCreator;
    }
    address[] private creatorsAddress;

    mapping(address => user) private myUser;
    mapping(address => uint256) private s_addressToAmountFunded;

    //events
    event CreatorPaid(address indexed paidCreator);

    //modifier
    modifier minPayment() {
        if (msg.value >= 0.01 ether) revert Donation__notEnoughEthProvided();
        _;
    }

    //functions
    function createUser(
        string memory _name,
        string memory _photo,
        string memory _emailId,
        string memory _websiteLink,
        string memory _instagram,
        bool _isCreator
    ) public {
        myUser[msg.sender] = user({
            userAddress: msg.sender,
            name: _name,
            photo: _photo,
            emailId: _emailId,
            websiteLink: _websiteLink,
            instagram: _instagram,
            isCreator: _isCreator
        });
        if (_isCreator) {
            creatorsAddress.push(msg.sender);
        }
    }

    function getUser(address _address) public view returns (user memory) {
        return myUser[_address];
    }

    function payContentCreator(address payable _receiver) public payable {
        require(msg.value >= 0.01 ether, "Not enough eth provided");
        user memory creator = myUser[_receiver];
        if (creator.isCreator) {
            (bool success, ) = _receiver.call{value: msg.value}("");
            s_addressToAmountFunded[_receiver] += msg.value;
            emit CreatorPaid(_receiver);
            if (!success) {
                revert Donation__paymentToCreatorFailed();
            }
        } else {
            revert Donation__notCreator();
        }
    }

    function getAddressToAmountFunder(address _address) public view returns (uint256) {
        return s_addressToAmountFunded[_address];
    }

    function getcreatorsAddresses() public view returns (address[] memory) {
        return creatorsAddress;
    }
}
