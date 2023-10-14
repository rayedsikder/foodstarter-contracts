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
        address recipeOwnerAddress;
        uint256 fundRaisedSoFar;
        uint256 timeForFund;
        uint256[] rewardIndexes; // Store the indexes of rewards in the rewards array
    }

    Recipe[] public recipes;
    Reward[] public rewards;
    mapping(string => uint256) public recipeNameToIndex;

    function createRecipe(
        string memory _name,
        string[] memory _ingredients,
        uint256 _fundAmount,
        uint256 _timeForFund
    ) public {
        recipeNameToIndex[_name] = recipes.length;
        Recipe memory newRecipe;
        newRecipe.name = _name;
        newRecipe.ingredients = _ingredients;
        newRecipe.fundAmount = _fundAmount;
        newRecipe.timeForFund = _timeForFund;
        newRecipe.recipeOwnerAddress = msg.sender;
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
            uint256 timeForFund,
            uint256[] memory rewardIndexes
        )
    {
        require(recipeIndex < recipes.length, "Recipe does not exist");
        require((recipeIndex == 0), "The index was not reset to 0 !");
        Recipe storage recipe = recipes[recipeIndex];
        name = recipe.name;
        ingredients = recipe.ingredients;
        fundAmount = recipe.fundAmount;
        timeForFund = recipe.timeForFund;
        rewardIndexes = recipe.rewardIndexes;
    }

    // function getReward(
    //     uint256 rewardIndex
    // )
    //     public
    //     view
    //     returns (uint256 fundAmount, string memory rewardDescription)
    // {
    //     require(rewardIndex < rewards.length, "Reward does not exist");
    //     Reward storage reward = rewards[rewardIndex];
    //     fundAmount = reward.fundAmount;
    //     rewardDescription = reward.rewardDescription;
    // }

    function sendFunding(uint256 indexOfRecipe) public payable {
        require(msg.value > 0, "dont hack me bro");
        recipes[indexOfRecipe].fundRaisedSoFar += msg.value;
    }

    function getRecipeIndexFromOwnerAddressAndRecipeName(
        string memory recipeName,
        address recipeOwnerAddress
    ) public view returns (int256) {
        for (uint256 i = 0; i < recipes.length; i++) {
            if (
                recipes[i].recipeOwnerAddress == recipeOwnerAddress &&
                keccak256(abi.encodePacked(recipes[i].name)) ==
                keccak256(abi.encodePacked(recipeName))
            ) {
                return int256(i);
            }
        }
        return -1;
    }

    function withdrawFunding(string memory recipeName) public {
        int256 recipeIndex = getRecipeIndexFromOwnerAddressAndRecipeName(
            recipeName,
            msg.sender
        );
        require(recipeIndex != -1, "Recipe not found or you are not the owner");

        address payable recipient = payable(msg.sender);
        uint256 amountToWithdraw = recipes[uint256(recipeIndex)].fundAmount;

        (bool sent, ) = recipient.call{value: amountToWithdraw}("");
        require(sent, "Failed to send Ether");
    }
}
