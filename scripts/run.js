const main = async () => {
    //compile our contract and generate necessary files
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    //create a local Ethereum network using hardhat
    const nftContact = await nftContractFactory.deploy();
    //wait until contract is officially minted
    await nftContact.deployed();
    //get the address of the deployed contract
    console.log("Contract deployed to:", nftContact.address);
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