const {expect} = require("chai");
const {ethers} = require("hardhat");
const hre = require("hardhat");
const {BigNumber, utils} = ethers;


describe("TokenSaleWithPartialRefund", () => {
    const user1 = 1;

    let contract = null;
    let accounts = null;
    let provider = null;
    beforeEach(async () => {
        accounts = await ethers.getSigners();
        const contractFactory = await ethers.getContractFactory('TokenSaleWithPartialRefunds');
        contract = await contractFactory.deploy('TokenName', 'TokenSymbol');
        await contract.deployed();
        provider = await ethers.provider


    })
    it("Insufficient Tokens to sell", async () => {
        await expect(contract.sellBack(100)).to.be.revertedWith("Insufficient Tokens to sell")
    })

    it("Minting from sales one time without payment", async () => {
        const tnx = await contract.mint1000Tokens(accounts[user1].address);
        await tnx.wait();
        const balance = await contract.balanceOf(accounts[user1].address);
        expect(balance).to.be.equal(new BigNumber.from("0"));
    })

    it("Minting from sales one time", async () => {
        const payment = hre.ethers.utils.parseEther("2");
        const tnx = await contract.mint1000Tokens(accounts[user1].address, {value: payment});
        await tnx.wait();
        const balance = await contract.balanceOf(accounts[user1].address);
        expect(balance).to.be.equal(new BigNumber.from("2000000000000000000000"));
    })

    it("Sell back a little amount No payback reward", async () => {
        const payment = hre.ethers.utils.parseEther("1");
        const tnx = await contract.mint1000Tokens(accounts[user1].address, {value: payment});
        await tnx.wait();
        const balance = await contract.balanceOf(accounts[user1].address);
        expect(balance).to.be.equal(new BigNumber.from("1000000000000000000000"));

        const tnx1 = await contract.connect(accounts[user1]).sellBack(1);
        await tnx1.wait();

        const balance1 = await contract.balanceOf(accounts[user1].address);
        expect(balance1).to.be.equal(new BigNumber.from("999999999999999999999"));
    })


    it("Sell back a little amount with payback reward", async () => {
        const payment = hre.ethers.utils.parseEther("2");
        const tnx = await contract.mint1000Tokens(accounts[user1].address, {value: payment});
        await tnx.wait();

        const userBalance = await provider.getBalance(accounts[user1].address);
        console.log(userBalance);
        const tnx1 = await contract.connect(accounts[user1]).sellBack(1000);
        await tnx1.wait();

        const checkBal = await provider.getBalance(accounts[user1].address);

        console.log(checkBal);
        // expect(checkBal).to.be.closeTo(
        //     userBalance.add(new BigNumber.from(utils.parseEther("0.5"))),
        //     new BigNumber.from(utils.parseEther("0.01"))
        // )
    })

    it.only("Sell back a little amount with payback reward more", async () => {
        const payment = hre.ethers.utils.parseEther("3");
        const tnx = await contract.mint1000Tokens(accounts[user1].address, {value: payment});
        await tnx.wait();

        const userBalance = await provider.getBalance(accounts[user1].address);
        const tnx1 = await contract.connect(accounts[user1]).sellBack(2000);

        await tnx1.wait();

        const checkBal = await provider.getBalance(accounts[user1].address);
        expect(checkBal).to.be.closeTo(
            userBalance.add(new BigNumber.from(utils.parseEther("1"))),
            new BigNumber.from(utils.parseEther("0.01"))
        )
    })
})