const main = async () => {
    //compile our contract and generate necessary files
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    //create a local Ethereum network using hardhat
    const nftContract = await nftContractFactory.deploy();
    //wait until contract is officially minted
    await nftContract.deployed();
    //get the address of the deployed contract
    console.log("Contract deployed to:", nftContract.address);

    let txn = await nftContract.makeAnEpicNFT();
    //Wait for it to be minted
    await txn.wait();
    console.log("Minted NFT #1");

    // //Mint another NFT for fun
    // txn = await nftContract.makeAnEpicNFT();
    // //Wait for it to be minted
    // await txn.wait();
    // console.log("Minted NFT #2");

};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    }
    catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();