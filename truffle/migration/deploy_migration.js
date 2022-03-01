//Allows you to pass in variables from a .env as aparameters for the smart contract
//This is done using Truffle or Hardhat
const ContractName = NoryaTestNFT
const ContractName = artifacts.require(ContractName.toString)

module.exports = async function (deployer) {

    const IPFS_IMAGE_METADATA_URI = `ipfs://${process.env.IPFS_IMAGE_METADATA_CID}/`
    const IPFS_HIDDEN_IMAGE_METADATA_URI = `ipfs://${process.env.IPFS_HIDDEN_IMAGE_METADATA_CID}/hidden.json`
    const NFT_MINT_DATE = new Date(process.env.NFT_MINT_DATE).getTime().toString().slice(0, 10)

    await deployer.deploy(
        OpenPunks,
        process.env.PROJECT_NAME,
        process.env.PROJECT_SYMBOL,
        process.env.MINT_COST,
        process.env.MAX_SUPPLY,
        NFT_MINT_DATE,
        IPFS_IMAGE_METADATA_URI,
        IPFS_HIDDEN_IMAGE_METADATA_URI,
    )
};