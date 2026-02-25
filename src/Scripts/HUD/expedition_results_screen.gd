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


const TRANSFER_TO_BANK = preload("uid://ddk7o6mnyi7ji")
const CLOSE_IN = preload("uid://dc3va7knibxnb")
const CLOSE_OUT = preload("uid://caj0oih8j2sty")

const TEMP_RESULTS_SCREEN_THEME = preload("uid://cpyx2c4kjhkag")

var tips : Array[String] = [
	"Can't reach a ledge? Upgrade your jump!",
	"Selling cooked items is the best way to make money!",
	"Enemies beating you down? Upgrade your attack stats!",
	"Low on inventory space? Unlock the bank! Upgrade your bag!",
	"Life is like a box chocolates. It's tasty.",
	"Feeling the grind? Yeah, so are we.",
	"Jumping up ladders is the fastest way, but look out for enemies above!",
	"Consecutive expedition runs are a great way to make money fast!",
	"Sometimes taking on harm to progress is necessary.."
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_containers()
	animation_player.play("CloseOut")
	tips_and_tricks.text = tips.pick_random()
	floor_reached.text = "%s %s" %[GameManager.previous_map_data.biome, GameManager.previous_map_data.floor_name]
	MusicPlayer.play_song(TEMP_RESULTS_SCREEN_THEME)
	await get_tree().create_timer(2.5).timeout
	if PlayerStats.facilities_unlocked["Bank"]:
		move_inventory_to_bank()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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

func init_containers() -> void:
	InventoryManager.update_grid_container(inventory_container, "Novelty Items")
	
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container, "Bank")
	else:
		new_run.disabled = false
		to_town.disabled = false
		bank_notice.show()

func move_inventory_to_bank() -> void:
	var inventory_names : Array[String] = ["Novelty Items", "Crafting Items", "Cooking Items", "Ore", "Gem Stones", "Use"]
	
	for name in inventory_names:
		await transfer_tab_to_bank(name)
	
	to_town.disabled = false
	new_run.disabled = false

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
