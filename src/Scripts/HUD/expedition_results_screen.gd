class_name ExpeditionResultsScreen extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var floor_reached: Label = $ResultsPanel/GoalPanel/ResultsLabel2

@onready var to_town: Button = $ResultsPanel/ToTown
@onready var new_run: Button = $ResultsPanel/NewRun
@onready var sfx_player: SFXPlayer = $SfxPlayer
@onready var inventory_label: Label = $ResultsPanel/InventoryLabel
@onready var transfering_tab_label: Label = $ResultsPanel/TransferingTabLabel
@onready var inventory_container: GridContainer = $ResultsPanel/InventoryContainer
@onready var bank_label: Label = $ResultsPanel/BankLabel
@onready var bank_notice: Label = $ResultsPanel/BankNotice
@onready var bank_container: GridContainer = $ResultsPanel/BankContainer
@onready var tips_and_tricks: Label = $ResultsPanel/TipsAndTricks

@onready var novelty_tab: TextureButton = $ResultsPanel/HBoxContainer/NoveltyTab
@onready var crafting_tab: TextureButton = $ResultsPanel/HBoxContainer/CraftingTab
@onready var cooking_tab: TextureButton = $ResultsPanel/HBoxContainer/CookingTab
@onready var ore_tab: TextureButton = $ResultsPanel/HBoxContainer/OreTab
@onready var gem_stone_tab: TextureButton = $ResultsPanel/HBoxContainer/GemStoneTab
@onready var use_tab: TextureButton = $ResultsPanel/HBoxContainer/UseTab

@onready var tabs : Array[TextureButton] = [novelty_tab,crafting_tab,cooking_tab,ore_tab,gem_stone_tab,use_tab]
@onready var to_town_bar: ProgressBar = $ResultsPanel/ToTownBar
@onready var to_tower_bar: ProgressBar = $ResultsPanel/ToTowerBar

const TRANSFER_TO_BANK = preload("uid://ddk7o6mnyi7ji")
const CLOSE_IN = preload("uid://dc3va7knibxnb")
const CLOSE_OUT = preload("uid://caj0oih8j2sty")

const TEMP_RESULTS_SCREEN_THEME = preload("uid://cpyx2c4kjhkag")
var can_go_back : bool = true
var tips : Array[String] = [
	"Can't reach a ledge? Upgrade your jump!",
	"Selling cooked items is the best way to make money!",
	"Enemies beating you down? Upgrade your attack stats!",
	"Low on inventory space? Unlock the bank! Upgrade your bag!",
	"Life is like a box chocolates. It's tasty.",
	"Feeling the grind? Yeah, so are we.",
	"Jumping up ladders is the fastest way, but look out for enemies above!",
	"Consecutive expedition runs are a great way to make money fast!",
	"Sometimes taking on harm to progress is necessary..",
	"Taking too much damage? Upgrade your health!",
	"Jumping up ladders can be a faster mode of traversal",
	"Trip too long to the bottom of a floor? Drop through platforms!"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_containers()
	init_tabs()
	animation_player.play("CloseOut")
	tips_and_tricks.text = tips.pick_random()
	floor_reached.text = "%s %s" %[GameManager.previous_map_data.biome, GameManager.previous_map_data.floor_name]
	MusicPlayer.play_song(TEMP_RESULTS_SCREEN_THEME)
	await get_tree().create_timer(2.5).timeout
	if PlayerStats.facilities_unlocked["Bank"]:
		move_inventory_to_bank()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("dash_attack") and !Input.is_action_just_pressed("pan_cam_right") and can_go_back:
		to_town_bar.value += delta * 100
		if to_town_bar.value >= to_tower_bar.max_value:
			go_to_starshire()
	else:
		to_town_bar.value = 0
	
	if Input.is_action_pressed("interact") and !Input.is_action_just_pressed("pan_cam_left") and can_go_back:
		to_tower_bar.value += delta * 100
		if to_tower_bar.value >= to_tower_bar.max_value:
			go_to_tower()
	else:
		to_tower_bar.value = 0

func go_to_starshire() -> void:
	GameManager.spawn_location = 0
	GameManager.resupply_character = true
	get_tree().change_scene_to_file("res://src/Scenes/NewStarshire/NewStarShire.tscn")

func go_to_tower() -> void:
	#Need to store the previous map we went to - or give them a way to select location
	GameManager.resupply_character = true
	get_tree().change_scene_to_file(GameManager.previous_map_path)

func _on_to_town_button_up() -> void:
	animation_player.play("CloseIn_Town")

func _on_new_run_button_up() -> void:
	animation_player.play("CloseIn_Tower")

func disable_tabs() -> void:
	for tab in tabs:
		tab.disabled = true

func enable_tabs() -> void:
	for tab in tabs:
		tab.disabled = false

func init_containers() -> void:
	InventoryManager.update_grid_container(inventory_container, "Novelty Items")
	
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container, "Bank")
	else:
		new_run.disabled = false
		to_town.disabled = false
		bank_notice.show()

func init_tabs() -> void:
	if PlayerStats.facilities_unlocked["Crafting Tab"]:
		novelty_tab.show()
		crafting_tab.show()
	else:
		novelty_tab.hide()
		crafting_tab.hide()
	
	if PlayerStats.facilities_unlocked["Cooking Station"]:
		cooking_tab.show()
		use_tab.show()
	else:
		cooking_tab.hide()
		use_tab.hide()
		
	if PlayerStats.facilities_unlocked["Refinery Station"]:
		ore_tab.show()
		use_tab.show()
	else:
		ore_tab.hide()
		use_tab.hide()

func move_inventory_to_bank() -> void:
	can_go_back = false
	var inventory_names : Array[String] = ["Novelty Items", "Crafting Items", "Cooking Items", "Ore", "Gem Stones", "Use"]
	disable_tabs()
	
	for name in inventory_names:
		await transfer_tab_to_bank(name)
		await get_tree().create_timer(0.3).timeout
	
	enable_tabs()
	to_town.disabled = false
	new_run.disabled = false
	can_go_back = true

func transfer_tab_to_bank(tab_name : String) -> void:
	transfering_tab_label.text = "Tranfering %s to Bank..." % tab_name
	InventoryManager.update_grid_container(inventory_container, tab_name)
	var inventory_snapshot = InventoryManager.inventories[tab_name].duplicate(true)
	for slot in inventory_snapshot:
		var qty = slot["quantity"]
		var item = slot["item"]

		for i in range(qty):
			if InventoryManager.add_item("Bank", item):
				InventoryManager.remove_item(tab_name, item)
				InventoryManager.update_grid_container(inventory_container, tab_name)
				InventoryManager.update_grid_container(bank_container, "Bank")
				sfx_player.play_sfx(TRANSFER_TO_BANK, 0, true)
				await get_tree().create_timer(0.1).timeout

func play_close_out_sfx() -> void:
	sfx_player.play_sfx(CLOSE_OUT)

func play_close_in_sfx() -> void:
	MusicPlayer.stop_player(true)
	sfx_player.play_sfx(CLOSE_IN)


func _on_novelty_tab_button_up() -> void:
	InventoryManager.update_grid_container(inventory_container, "Novelty Items")


func _on_crafting_tab_button_up() -> void:
	InventoryManager.update_grid_container(inventory_container, "Crafting Items")


func _on_cooking_tab_button_up() -> void:
	InventoryManager.update_grid_container(inventory_container, "Cooking Items")

func _on_ore_tab_button_up() -> void:
	InventoryManager.update_grid_container(inventory_container, "Ore")


func _on_gem_stone_tab_button_up() -> void:
	InventoryManager.update_grid_container(inventory_container, "Gem Stones")


func _on_use_tab_button_up() -> void:
	InventoryManager.update_grid_container(inventory_container, "Use")
