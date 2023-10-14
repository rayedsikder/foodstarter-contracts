// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract RecipeContract {
    struct Reward {
        uint256 fundAmount;
        string rewardDescription;
    }

    struct Recipe {
        string name;
        string[] ingredients;
        uint256 fundAmount;
        uint256 timeForFund;
    }

    Recipe[] public recipes;
    Reward[] public rewards;

    function createReward(
        uint256 _fundAmount,
        string memory _rewardDescription
    ) public {
        Reward memory newReward;
        newReward.fundAmount = _fundAmount;
        newReward.rewardDescription = _rewardDescription;
        rewards.push(newReward);
    }

    function createRecipe(
        string memory _name,
        string[] memory _ingredients,
        uint256 _fundAmount,
        uint256 _timeForFund
    ) public // uint256[] memory _rewardIndexes
    {
        Recipe memory newRecipe;
        newRecipe.name = _name;
        newRecipe.ingredients = _ingredients;
        newRecipe.fundAmount = _fundAmount;
        newRecipe.timeForFund = _timeForFund;

        recipes.push(newRecipe);
    }

    function getRecipe(
        uint256 recipeIndex
    )
        public
        view
        returns (
            string memory name,
            string[] memory ingredients,
            uint256 fundAmount,
            uint256 timeForFund
        )
    {
        require(recipeIndex < recipes.length, "Recipe does not exist");
        Recipe storage recipe = recipes[recipeIndex];
        name = recipe.name;
        ingredients = recipe.ingredients;
        fundAmount = recipe.fundAmount;
        timeForFund = recipe.timeForFund;
    }

    function getReward(
        uint256 rewardIndex
    )
        public
        view
        returns (uint256 fundAmount, string memory rewardDescription)
    {
        require(rewardIndex < rewards.length, "Reward does not exist");
        Reward storage reward = rewards[rewardIndex];
        fundAmount = reward.fundAmount;
        rewardDescription = reward.rewardDescription;
    }
}
