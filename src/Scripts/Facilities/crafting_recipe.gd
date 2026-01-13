class_name CraftingRecipe extends Resource

@export var recipe_name : String
@export var menu_icon : Texture2D
enum RECIPE_TYPE {
	CRAFTING_MATERIAL,
	DISH,
	SWORD
}

@export var recipe_tier : int
@export var recipe_type : RECIPE_TYPE = RECIPE_TYPE.CRAFTING_MATERIAL
@export var success_rate : float
@export var output_item : Item
@export var recipe_list : Array[Dictionary] #stored item and quantity
