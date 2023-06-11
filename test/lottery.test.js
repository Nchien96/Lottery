const { assert } = require("chai");
const { ethers } = require("hardhat");
const Web3 = require("web3");

let lottery;
let accounts;

beforeEach(async () => {
  accounts = await ethers.getSigners();
  const Token = await ethers.getContractFactory("lottery");
  lottery = await Token.deploy();
});

describe("lottery contract", () => {
  it("allow one account to enter", async () => {
    await lottery.enter().send({
      from: accounts[0],
      value: Web3.utils.toWei("0.02", "ether"),
    });
    const players = await lottery.getPlayers().call({
      from: accounts[0],
    });

    assert.equal(accounts[0], players[0]);
    assert.equal(1, players.length);
  });
});
