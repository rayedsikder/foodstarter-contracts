import { ethers } from "hardhat";

async function main() {
  // const [owner] = await ethers.getSigners();

  const RecipeContract = await ethers.getContractFactory("RecipeContract");
  const recipeContract = await RecipeContract.deploy();

  await recipeContract.deployed();

  console.log("RecipeContract deployed to:", recipeContract.address);

  const recipeName = "My first recipe";
  const recipeIngredients = ["Ingredient 1", "Ingredient 2"];
  const recipeFundAmount = ethers.utils.parseEther("0.1");
  // 7 days from now in uint256
  const recipeFundDeadline = Math.floor(Date.now() / 1000) + 7 * 24 * 60 * 60;

  let createRecipe = await recipeContract.createRecipe(
    recipeName,
    recipeIngredients,
    recipeFundAmount,
    recipeFundDeadline
  );

  await createRecipe.wait();

  const getRecipe = await recipeContract.getRecipe(recipeName);

  console.log("Recipe:", getRecipe);

  createRecipe = await recipeContract.createRecipe("H", recipeIngredients, recipeFundAmount, recipeFundDeadline);  
  await createRecipe.wait();

  console.log("Recipe:", await recipeContract.getRecipe("H"));

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
