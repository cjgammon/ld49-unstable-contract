const hre = require("hardhat");
async function main() {
  const NFT = await hre.ethers.getContractFactory("MyNFT");
  const URI = "ipfs://QmTFg2Aou5ZvvNPFMM4kJRF4BgR9QohagGFesrfrQiqf3E"
  const WALLET_ADDRESS = "0xf4D70050eB0361a21348451d10aeBe7d80d9977e"
  const CONTRACT_ADDRESS = "0x1B9907FA9bab5b1dA6A6A37F49D270603fc45FF9"
  const contract = NFT.attach(CONTRACT_ADDRESS);
  await contract.mint(WALLET_ADDRESS, URI);
  console.log("NFT minted:", contract);
}
main().then(() => process.exit(0)).catch(error => {
  console.error(error);
  process.exit(1);
});