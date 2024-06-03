// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Item {
        address payable seller;
        string name;
        string description;
        uint256 price;
        bool sold;
    }

    uint256 public itemCount;
    mapping(uint256 => Item) public items;

    event ItemListed(uint256 itemId, address seller, string name, uint256 price);
    event ItemBought(uint256 itemId, address buyer);

    function listItem(string memory name, string memory description, uint256 price) external {
        require(price > 0, "Price must be greater than zero");

        itemCount++;
        items[itemCount] = Item(
            payable(msg.sender),
            name,
            description,
            price,
            false
        );

        emit ItemListed(itemCount, msg.sender, name, price);
    }

    function buyItem(uint256 itemId) external payable {
        Item storage item = items[itemId];
        require(itemId > 0 && itemId <= itemCount, "Item does not exist");
        require(msg.value == item.price, "Incorrect value sent");
        require(!item.sold, "Item already sold");

        item.sold = true;
        item.seller.transfer(msg.value);

        emit ItemBought(itemId, msg.sender);
    }

    function getItem(uint256 itemId) external view returns (address seller, string memory name, string memory description, uint256 price, bool sold) {
        Item storage item = items[itemId];
        return (item.seller, item.name, item.description, item.price, item.sold);
    }
}
