extends Node


#tier 1 cooking recipes
const COOKED_GAGOOTZ = preload("uid://calxpcwsw1ny1")

@warning_ignore("unused_signal")
signal populate_description_panel(recipe : CraftingRecipe)

var cooking_recipes : Dictionary[int,Array] = {
	1 : [COOKED_GAGOOTZ],
	2 : [],
	3 : [],
	4 : [],
	5 : [],
}
