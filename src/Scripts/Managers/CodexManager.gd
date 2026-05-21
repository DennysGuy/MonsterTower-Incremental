extends Node
class_name CodexManagerScript

@warning_ignore("unused_signal")
signal populate_monster_description_panel(monster_stats : EnemyStats)
@warning_ignore("unused_signal")
signal update_monster_cards
@warning_ignore("unused_signal")
signal populate_recipe_description_panel(crafting_recipe : CraftingRecipe)
@warning_ignore("unused_signal")
signal open_a_codex_menu(menu_type : int)
@warning_ignore("unused_signal")
signal show_codex
@warning_ignore("unused_signal")
signal hide_codex
@warning_ignore("unused_signal")
signal send_codex_notification(codex_message : String)
@warning_ignore("unused_signal")
signal show_codex_notification
@warning_ignore("unused_signal")
signal update_stats_page
@warning_ignore("unused_signal")
signal populate_quest_panel(quest : Quest)

const WILLOW_SHRUB = preload("uid://e6ejdj1jwoj0")
const CORRUPTED_MUSHIE = preload("uid://bq0juubwkp8im")
const CORRUPTED_MUSHIE_LV_L_2 = preload("uid://dwtw24hgj7tub")
const BATCLOPSE = preload("uid://dsl20riisg4mk")
const BATCLOPSE_LVL_2 = preload("uid://d4h3fsu5cbkti")
const MOSS_GOLEM = preload("uid://dwook5wtmbf8g")
const BEETLE_KNIGHT = preload("uid://bq77ocfjc35gc")
const BEETLE_KNIGHT_LVL_2 = preload("uid://6q2nq8bgf2bm")
const SERPANT_MIMIC = preload("uid://0y733wkj0ion")
const SERPANT_MIMIC_LVL_2 = preload("uid://du4so306s4lte")
const GOBLIN_THIEF = preload("uid://cq7q6npjlayh1")
const ORC_WARLORD = preload("uid://cnwbnpkxv6bpd")

#Tier 1 Dishes
const COOKED_GAGOOTZ = preload("uid://calxpcwsw1ny1")
const HUNTERS_STEW = preload("uid://djnghsi47lfiv")
const LURKER_CABEZA = preload("uid://cf3i4kcwphgab")
const MOSSY_GOULASH = preload("uid://ewuj36wenyg")
const MUSHIE_FLAN = preload("uid://bl128q5qwa5a6")
const PUPIL_CAVIAR = preload("uid://ce00vbs14tnn6")
const SVIO = preload("uid://dvll2non4abwb")
const WRAPPED_KABAB = preload("uid://dw722w0co7qrn")

#Tier 1 Bars
const BRONZE_BAR_RECIPE = preload("uid://bxa51f001ecsc")
const IRON_BAR_RECIPE = preload("uid://lt0tb247yewa")
const STEEL_BAR_RECIPE = preload("uid://bpp8k8y7mogh")


const MONSTER_UNLOCK_THRESH_HOLD : int = 10
const RECIPE_THRESH_HOLD_1 : int = 1
const RECIPE_THRESH_HOLD_2 : int = 5

'''
Maybe tiers to unlocking recipe entries?

- crafting once to unveil name of recipe
- craft 5 times to unveil the recipe list

'''

var monster_list : Array[EnemyStats]= [
	WILLOW_SHRUB,
	CORRUPTED_MUSHIE,
	CORRUPTED_MUSHIE_LV_L_2,
	BATCLOPSE,
	BATCLOPSE_LVL_2,
	MOSS_GOLEM,
	BEETLE_KNIGHT,
	BEETLE_KNIGHT_LVL_2,
	SERPANT_MIMIC,
	SERPANT_MIMIC_LVL_2,
	GOBLIN_THIEF,
	ORC_WARLORD
]

var monster_unlock_status : Array = [
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
	{"Unlocked" : false, "Count": 0},
]

var bar_recipes : Array[CraftingRecipe] = [
	BRONZE_BAR_RECIPE,
	IRON_BAR_RECIPE,
	STEEL_BAR_RECIPE
]

var bar_recipe_unlocks : Array = [
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
]

var dish_recipes : Array[CraftingRecipe] = [
	COOKED_GAGOOTZ,
	MOSSY_GOULASH,
	PUPIL_CAVIAR,
	WRAPPED_KABAB,
	LURKER_CABEZA,
	HUNTERS_STEW,
	SVIO,
]

var dish_recipe_unlocks : Array = [
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
	{"Unlocked 1": false, "Unlocked 2": false, "Count": 0},
]

func increment_monster_card_count(index : int) -> void:
	if monster_unlock_status[index]["Unlocked"]:
		return
	monster_unlock_status[index]["Count"] += 1
		
	if monster_unlock_status[index]["Count"] >= MONSTER_UNLOCK_THRESH_HOLD:
		monster_unlock_status[index]["Unlocked"] = true
		#issue notification on HUD that is unlocked, 
		#player can check codex and card should be unlocked
		var message : String = "[color=light_cyan]%s[/color] entered\ninto [color=light_green]Monsterpedia[/color]" % monster_list[index].enemy_name
		CodexManager.send_codex_notification.emit(message)
	SaveManager.save_monster_unlocks_status()
	
func increment_bar_recipe_list_item_count(index : int) -> void:
	if bar_recipe_unlocks[index]["Unlocked 1"] and bar_recipe_unlocks[index]["Unlocked 2"]:
		return
		
	bar_recipe_unlocks[index]["Count"] += 1
	
	if not bar_recipe_unlocks[index]["Unlocked 1"] and bar_recipe_unlocks[index]["Count"] >= RECIPE_THRESH_HOLD_1:
		bar_recipe_unlocks[index]["Unlocked 1"] = true
		var message : String = "[color=tan]%s[/color] entered into\n[color=salmon]Recipe Book![/color]" % bar_recipes[index].output_item.item_name
		CodexManager.send_codex_notification.emit(message)
		SaveManager.save_bar_unlocks_status()
	
	if not bar_recipe_unlocks[index]["Unlocked 2"] and bar_recipe_unlocks[index]["Count"] >= RECIPE_THRESH_HOLD_2:
		bar_recipe_unlocks[index]["Unlocked 2"] = true
		var message : String = "[color=tan]%s[/color] Recipe Entry\n[color=pale_green]Completed![/color]" % dish_recipes[index].output_item.item_name
		CodexManager.send_codex_notification.emit(message)
		SaveManager.save_bar_unlocks_status()

func increment_dish_recipe_list_item_count(index : int) -> void:
	if dish_recipe_unlocks[index]["Unlocked 1"] and dish_recipe_unlocks[index]["Unlocked 2"]:
		return
		
	dish_recipe_unlocks[index]["Count"] += 1
	
	if not dish_recipe_unlocks[index]["Unlocked 1"] and dish_recipe_unlocks[index]["Count"] >= RECIPE_THRESH_HOLD_1:
		dish_recipe_unlocks[index]["Unlocked 1"] = true
		var message : String = "[color=lemon_chiffon]%s[/color] entered into\n[color=salmon]Recipe Book![/color]" % dish_recipes[index].output_item.item_name
		CodexManager.send_codex_notification.emit(message)
		SaveManager.save_dish_unlocks_status()
	
	if not dish_recipe_unlocks[index]["Unlocked 2"] and dish_recipe_unlocks[index]["Count"] >= RECIPE_THRESH_HOLD_2:
		var message : String = "[color=lemon_chiffon]%s[/color] Recipe Entry\n[color=pale_green]Completed![/color]" % dish_recipes[index].output_item.item_name
		CodexManager.send_codex_notification.emit(message)
		dish_recipe_unlocks[index]["Unlocked 2"] = true
		SaveManager.save_dish_unlocks_status()
