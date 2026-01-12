class_name ExpeditionResultsScreen extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var inventory_container: GridContainer = $ResultsPanel/InventoryPanel/InventoryContainer
@onready var bank_container: GridContainer = $ResultsPanel/InventoryPanel/BankContainer
@onready var bank_notice: Label = $ResultsPanel/InventoryPanel/BankNotice

@onready var to_town: Button = $ResultsPanel/ToTown
@onready var new_run: Button = $ResultsPanel/NewRun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_containers()
	animation_player.play("CloseOut")
	await get_tree().create_timer(2.5).timeout
	if PlayerStats.facilities_unlocked["Bank"]:
		move_inventory_to_bank()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to_starshire() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/NewStarshire/NewStarShire.tscn")

func go_to_tower() -> void:
	get_tree().change_scene_to_file("res://src/Scenes/Tower/TowerFloors/TestFloor/TestFloor.tscn")

func _on_to_town_button_up() -> void:
	animation_player.play("CloseIn_Town")

func _on_new_run_button_up() -> void:
	animation_player.play("CloseIn_Tower")

func init_containers() -> void:
	InventoryManager.update_grid_container(inventory_container, "Inventory")
	if PlayerStats.facilities_unlocked["Bank"]:
		InventoryManager.update_grid_container(bank_container, "Bank")
	else:
		new_run.disabled = false
		to_town.disabled = false
		bank_notice.show()

func move_inventory_to_bank() -> void:
	var inventory : Array = InventoryManager.inventories["Inventory"]
	
	while !inventory.is_empty() and !InventoryManager.check_if_bank_full():
		for slot in inventory:
			for i in range(slot["quantity"]):
				var added : bool = InventoryManager.add_item("Bank",slot["item"])
				if added:
					InventoryManager.remove_item("Inventory", slot["item"])
					InventoryManager.update_grid_container(inventory_container, "Inventory")
					InventoryManager.update_grid_container(bank_container, "Bank")
					await get_tree().create_timer(0.12).timeout
		
	to_town.disabled = false
	new_run.disabled = false
