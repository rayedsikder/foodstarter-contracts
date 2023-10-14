// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract RecipeContract {
    struct Recipe {
        string name;
        string[] ingredients;
        uint256 fundAmount;
        address recipeOwnerAddress;
        uint256 fundRaisedSoFar;
        string timeForFund;
    }
    mapping(string => uint256) private recipeIdx;

    Recipe[] private recipes;

    function createRecipe(
        string memory _name,
        string[] memory _ingredients,
        uint256 _fundAmount,
        string memory _timeForFund
    ) public {
        recipeIdx[_name] = recipes.length;
        Recipe memory newRecipe;
        newRecipe.name = _name;
        newRecipe.ingredients = _ingredients;
        newRecipe.fundAmount = _fundAmount;
        newRecipe.timeForFund = _timeForFund;
        newRecipe.recipeOwnerAddress = msg.sender;
        newRecipe.fundRaisedSoFar = 0;
        recipes.push(newRecipe);
    }

    function getRecipe(
        string memory _name
    )
        public
        view
        returns (
            string memory name,
            string[] memory ingredients,
            uint256 fundAmount,
            address recipeOwnerAddress,
            uint256 fundRaisedSoFar,
            string memory timeForFund
        )
    {
        uint256 recipeIndex = recipeIdx[_name];
        require(recipeIndex < recipes.length, "Recipe does not exist");
        Recipe memory recipe = recipes[recipeIndex];
        return (
            recipe.name,
            recipe.ingredients,
            recipe.fundAmount,
            recipe.recipeOwnerAddress,
            recipe.fundRaisedSoFar,
            recipe.timeForFund
        );
    }

    function sendFunding(uint256 indexOfRecipe) public payable {
        require(msg.value > 0, "Please add more fund");
        recipes[indexOfRecipe].fundRaisedSoFar += msg.value;
    }

    function withdrawFunding(uint256 indexOfRecipe) public payable {
        require(indexOfRecipe < recipes.length, "Recipe does not exist");

        Recipe memory recipe = recipes[indexOfRecipe];

        require(
            msg.sender == recipe.recipeOwnerAddress,
            "You are not the owner of this recipe"
        );
        require(
            recipe.fundRaisedSoFar > 0,
            "No funds available for withdrawal"
        );

        uint256 amountToWithdraw = recipe.fundRaisedSoFar;
        recipe.fundRaisedSoFar = 0;

        payable(msg.sender).transfer(amountToWithdraw);
    }
}
