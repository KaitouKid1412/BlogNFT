const { expect } = require("chai");
const { ethers } = require("hardhat");



describe("BlogNFT", function () {
    it("Mint Blog NFT", async function() {
        const blogNFTContract = await ethers.getContractFactory("BlogNFT");
        const blogNFT = await blogNFTContract.deploy();
        await blogNFT.deployed();
        
        testBlogURI = "https://www.google.com";
        const [owner] = await ethers.getSigners();

        //Check if token mint event has been emitted
        await expect(blogNFT.mintToken(owner.address
            , testBlogURI))
        .to.emit(blogNFT, "newBlogToken")
        .withArgs(0, testBlogURI);

        //Check if the tokenId mapping has been created and function works as expected
        const tokenId = await blogNFT.getTokenIds(owner.address);
        expect(tokenId).to.deep.equal([ethers.BigNumber.from("0")]);

        //Check if the tokenURI mapping is created and the function works as expected
        const tokenURI = await blogNFT.gettokenURI(0);
        expect(tokenURI).to.deep.equal(testBlogURI);

        //Check if duplicate tokenURI check if working as expected
        await expect(blogNFT.mintToken(owner.address
            , testBlogURI))
        .to.emit(blogNFT, "blogTokenCreationError")
        .withArgs("Couldnot create Token because token with the URI mentioned already exists");
    });
});