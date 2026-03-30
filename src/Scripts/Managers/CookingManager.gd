extends Node


#tier 1 cooking recipes
const COOKED_GAGOOTZ = preload("uid://calxpcwsw1ny1")
const MOSSY_GOULASH = preload("uid://ewuj36wenyg")
const MUSHIE_FLAN = preload("uid://bl128q5qwa5a6")



#tier 1 smelting recipes
const BRONZE_BAR_RECIPE = preload("uid://bxa51f001ecsc")
const IRON_BAR_RECIPE = preload("uid://lt0tb247yewa")



@warning_ignore("unused_signal")
signal populate_description_panel(recipe : CraftingRecipe)

@warning_ignore("unused_signal")
signal can_craft_dish
@warning_ignore("unused_signal")
signal can_craft_bar

var cooking_recipes : Dictionary[int,Array] = {
	1 : [COOKED_GAGOOTZ,MOSSY_GOULASH],
	2 : [],
	3 : [],
	4 : [],
	5 : [],
}

func can_cook_recipe() -> bool:
	for tier in cooking_recipes.keys():
		for recipe in cooking_recipes[tier]:
			if InventoryManager.calculate_quantity(recipe) >= 1:
				return true
			
	return false

var smelting_recipes : Dictionary[int, Array] = {
	1: [BRONZE_BAR_RECIPE, IRON_BAR_RECIPE],
	2: [],
	3: [],
	4: [],
	5: []
}

func can_refine_bar() -> bool:
	for tier in smelting_recipes.keys():
		for recipe in smelting_recipes[tier]:
			if InventoryManager.calculate_quantity(recipe) >= 1:
				return true
			
	return false
