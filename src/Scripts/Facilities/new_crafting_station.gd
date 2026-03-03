class_name NewCraftingStation extends Node2D

enum STATION_TYPE {SMELTING,COOKING}
@export var station_type : STATION_TYPE
@onready var menu_location: Marker2D = $MenuLocation
@export var station_graphic: TextureRect
@onready var name_tag: NameTag = $NameTag

@onready var idle: CraftingStationIdle = $StateMachine/Idle
@onready var transfer_resources: CraftingStationTransferResources = $StateMachine/TransferResources
@onready var crafting: CraftingStationCrafting = $StateMachine/Crafting
@onready var ending_area: Area2D = $EndingArea

@onready var crafting_progressbar: TextureProgressBar = $CraftingProcessIcon/CraftingProgressbar
@onready var crafting_station_menu_item: CraftingStationMenuItem = $CraftingProcessIcon/CraftingStationMenuItem

@onready var sfx_player: SFXPlayer = $SfxPlayer

var crafting_started : bool = false
var crafting_quantity : int = 0
var stored_recipe : CraftingRecipe

var player_in_range : bool = false
var player : Player

const TEMP_COOKING_RANGE = preload("uid://bry4670ns2btd")
const TEMP_COOKING_RANGE_CONTSTRUCTION = preload("uid://53gha3pmge8a")

const SMELTING_STATION_CONTRUCTION_MODE = preload("uid://chhm5f5xmlr0j")
const SMELTING_STATION = preload("uid://btbqj1pb1hac")

const FAILURE = preload("uid://cv5p7ufgqluno")
const SUCCESS = preload("uid://dj3e1mi4ks8sr")

@export var state_machine : StateMachine

@onready var crafting_tracker_player: AnimationPlayer = $CraftingTrackerPlayer

var stored_crafting_menu : NewCraftingStationMenu = null
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match station_type:
		STATION_TYPE.SMELTING:
			name_tag.tag.text = "Refinery"
			station_graphic.texture = SMELTING_STATION
		STATION_TYPE.COOKING:
			name_tag.tag.text = "Cooking Range"
			station_graphic.texture = TEMP_COOKING_RANGE
	
	state_machine.init(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		player = body
		GameManager.player_can_attack = false

		if not crafting_started:
			match station_type:
				STATION_TYPE.SMELTING:
					spawn_refinery_menu()
				STATION_TYPE.COOKING:
					spawn_cooking_station_menu()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		GameManager.player_can_attack = true
		player_in_range = false
		if stored_crafting_menu:
			stored_crafting_menu.play_spawn_out()

func spawn_cooking_station_menu() -> void:
	var cooking_menu : NewCraftingStationMenu = preload("uid://dq1s8bd6w6dnv").instantiate()
	cooking_menu.set_as_cooking_range()
	cooking_menu.position = menu_location.position
	stored_crafting_menu = cooking_menu
	stored_crafting_menu.station = self
	add_child(cooking_menu)

func spawn_refinery_menu() -> void:
	var refinery_menu : NewCraftingStationMenu = preload("uid://dq1s8bd6w6dnv").instantiate()
	refinery_menu.set_as_refinery()
	refinery_menu.position = menu_location.position
	refinery_menu.station = self
	stored_crafting_menu = refinery_menu
	add_child(refinery_menu)

func start_crafting(recipe : CraftingRecipe, quantity : int) -> void:

	stored_recipe = recipe
	for num in range(quantity):
		InventoryManager.remove_resources_from_inventory(stored_recipe.recipe_list)	
	crafting_quantity = quantity
	crafting_started = true
	show_crafting_tracker()
	state_machine.change_state(transfer_resources)
	
const PULL_ITEM_1 = preload("uid://dqgwyjvft1l47")

func move_resources_to_station() -> void:
	if not stored_recipe:
		return
	for ingredient in stored_recipe.recipe_list:
		for num in range(crafting_quantity):
			for key in ingredient.keys():
				var spawn : CraftingItemSpawn = preload("uid://w3hqvcw0cv2q").instantiate()
				spawn.icon.texture = key.shop_icon
				spawn.starting_ending_area = player.ending_area
				spawn.ending_area = ending_area
				play_sfx(PULL_ITEM_1)
				get_parent().add_child(spawn)
				await get_tree().create_timer(0.1).timeout

func move_resources_from_station() -> void:
	if not stored_recipe:
		return
		
	for ingredient in stored_recipe.recipe_list:
		for num in range(crafting_quantity):
			for key in ingredient.keys():
				var spawn : CraftingItemSpawn = preload("uid://w3hqvcw0cv2q").instantiate()
				spawn.icon.texture = key.shop_icon
				spawn.starting_ending_area = ending_area
				spawn.ending_area = player.ending_area
				play_sfx(PULL_ITEM_1)
				get_parent().add_child(spawn)
				await get_tree().create_timer(0.1).timeout

func show_crafting_tracker() -> void:
	crafting_station_menu_item.item_icon.texture = stored_recipe.output_item.shop_icon
	crafting_station_menu_item.count_label.text = str(crafting_quantity)
	crafting_progressbar.max_value = stored_recipe.crafting_time
	crafting_tracker_player.play("Phase In")

func hide_crafting_tracker() -> void:
	crafting_tracker_player.play("Phase Out")

func update_quantity_details() -> void:
	crafting_station_menu_item.count_label.text = str(crafting_quantity)

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func play_success_sfx() -> void:
	play_sfx(SUCCESS)

func play_failure_sfx() -> void:
	play_sfx(FAILURE)

func _on_cancel_crafting_button_button_up() -> void:
	crafting_progressbar.value = 0
	hide_crafting_tracker()
	state_machine.change_state(idle)
	crafting_started = false
	move_resources_from_station()
	for num in range(crafting_quantity):
		InventoryManager.add_resources_to_inventory(stored_recipe.recipe_list)
	stored_recipe = null
