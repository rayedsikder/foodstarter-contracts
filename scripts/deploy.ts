import { ethers } from "hardhat";

async function main() {
  // const [owner] = await ethers.getSigners();

  const RecipeContract = await ethers.getContractFactory("RecipeContract");
  const recipeContract = await RecipeContract.deploy();

  await recipeContract.deployed();

  console.log("RecipeContract deployed to:", recipeContract.address);

  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
