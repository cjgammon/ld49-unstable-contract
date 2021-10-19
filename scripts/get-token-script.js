const hre = require("hardhat");
async function main() {
  const NFT = await hre.ethers.getContractFactory("OldGuys");
  const CONTRACT_ADDRESS = "0x1B9907FA9bab5b1dA6A6A37F49D270603fc45FF9"
  const contract = NFT.attach(CONTRACT_ADDRESS);
  const owner = await contract.ownerOf(1);
  console.log("Owner:", owner);
  const uri = await contract.tokenURI(1);
  console.log("URI: ", uri);
}
main().then(() => process.exit(0)).catch(error => {
  console.error(error);
  process.exit(1);
});