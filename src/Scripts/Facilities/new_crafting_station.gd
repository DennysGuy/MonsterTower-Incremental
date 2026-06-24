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
@onready var station_animation_player: AnimationPlayer = $StationAnimationPlayer

var crafting_started : bool = false
var crafting_quantity : int = 0
var stored_recipe : CraftingRecipe

var player_in_range : bool = false
var player : Player

const TEMP_COOKING_RANGE = preload("uid://bhoricf6h50pj")
const TEMP_COOKING_RANGE_CONTSTRUCTION = preload("uid://lqprwtlaufoc")

const SMELTING_STATION_CONTRUCTION_MODE = preload("uid://chhm5f5xmlr0j")
const SMELTING_STATION = preload("uid://btbqj1pb1hac")

const FAILURE = preload("uid://cv5p7ufgqluno")
const SUCCESS = preload("uid://dj3e1mi4ks8sr")
const CRIT_SUCCESS_FAN_FARE = preload("uid://dg17w86m3muje")

const TURN_OUT_ITEM = preload("uid://bd2rssv5wcn04")


@onready var arrow_at_ore: Sprite2D = $ArrowAtOre


@onready var cant_open_notice: Label = $CantOpenNotice

@export var state_machine : StateMachine

@onready var crafting_tracker_player: AnimationPlayer = $CraftingTrackerPlayer

var stored_crafting_menu : NewCraftingStationMenu = null
var current_pitch : float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match station_type:
		STATION_TYPE.SMELTING:
			name_tag.tag.text = "Refinery"
			station_graphic.texture = SMELTING_STATION
			if PlayerStats.facilities_unlocked["Refinery Station"]:
				station_graphic.texture = SMELTING_STATION
				arrow_at_ore.show()
			else:
				station_graphic.texture = SMELTING_STATION_CONTRUCTION_MODE
			
		STATION_TYPE.COOKING:
			name_tag.tag.text = "Junk-a-Tron"
			station_graphic.texture = TEMP_COOKING_RANGE
			if PlayerStats.facilities_unlocked["Junk-A-Tron"]:
				station_graphic.texture = TEMP_COOKING_RANGE
				arrow_at_ore.show()
			else:
				station_graphic.texture = TEMP_COOKING_RANGE_CONTSTRUCTION
				
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
		var can_open_station : bool
		match station_type:
			STATION_TYPE.COOKING:
				can_open_station = PlayerStats.facilities_unlocked["Junk-A-Tron"]
			STATION_TYPE.SMELTING:
				can_open_station = PlayerStats.facilities_unlocked["Refinery Station"]

		if not crafting_started and can_open_station:
			match station_type:
				STATION_TYPE.SMELTING:
					spawn_refinery_menu()
				STATION_TYPE.COOKING:
					spawn_cooking_station_menu()
		else:
			match station_type:
				STATION_TYPE.SMELTING:
					cant_open_notice.text = "Unlock Refinery Node to access"
				STATION_TYPE.COOKING:
					cant_open_notice.text = "Unlock Junk-A-Tron Node to access"
			cant_open_notice.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		GameManager.player_can_attack = true
		player_in_range = false
		if stored_crafting_menu:
			stored_crafting_menu.play_spawn_out()
		else:
			cant_open_notice.hide()
			
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

func unlock_cooking_station() -> void:
	station_graphic.texture = TEMP_COOKING_RANGE
	arrow_at_ore.show()

func unlock_refinery() -> void:
	station_graphic.texture = SMELTING_STATION
	arrow_at_ore.show()

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
				for i in range(ingredient[key]):
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

func activate() -> void:
	station_animation_player.play("Active")

func deactivate() -> void:
	station_animation_player.play("Deactive")

func play_sfx(sound: AudioStream, volume: float = 0.0, pitch_scale : float = 1.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	player.pitch_scale = pitch_scale
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func play_success_sfx() -> void:
	play_sfx(SUCCESS)

func play_failure_sfx() -> void:
	play_sfx(FAILURE)

func play_crit_success_sfx() -> void:
	play_sfx(CRIT_SUCCESS_FAN_FARE)

func _on_cancel_crafting_button_button_up() -> void:
	crafting_progressbar.value = 0
	hide_crafting_tracker()
	state_machine.change_state(idle)
	crafting_started = false
	move_resources_from_station()
	for num in range(crafting_quantity):
		InventoryManager.add_resources_to_inventory(stored_recipe.recipe_list)
	stored_recipe = null

func spawn_item(item : Item, offset : Vector2 = Vector2.ZERO) -> void:
	craft_finished_tween()
	var item_interactable : ItemInteractable = preload("uid://dgtobkubdjq27").instantiate()
	item_interactable.item = item
	item_interactable.perishable = false
	item_interactable.icon.texture = item.shop_icon
	item_interactable.global_position = global_position + offset
	
	match station_type:
		STATION_TYPE.SMELTING:
			if stored_recipe:
				CodexManager.increment_bar_recipe_list_item_count(stored_recipe.index)
		STATION_TYPE.COOKING:
			item_interactable.is_junk_drop = true
			if stored_recipe:
				CodexManager.increment_dish_recipe_list_item_count(stored_recipe.index)
	
	#check if free range/heat hits
	spawn_crafting_recipe_items()
	play_sfx(TURN_OUT_ITEM, 1.0, current_pitch)
	if current_pitch < 2.0:
		current_pitch += 0.2
	get_parent().add_child(item_interactable)

func spawn_crafting_recipe_items() -> void:
	if !check_for_free_craft():
		return
	
	for ingredient in stored_recipe.recipe_list:
		var offset = -50
		for num in range(crafting_quantity):
			for key in ingredient.keys():
				for i in range(ingredient[key]):
					spawn_item(key,Vector2(offset,self.global_position.y))
					play_sfx(PULL_ITEM_1)
					offset += 5
					await get_tree().create_timer(0.1).timeout
				
func check_for_free_craft() -> bool:
	var rand_num : int = randi_range(0,100)
	
	match station_type:
		STATION_TYPE.COOKING:
			var chance : int = int(PlayerStats.player_stats["Free Range Chance"]*100)
			if chance > 0 and rand_num <= chance:
				return true
		STATION_TYPE.SMELTING:
			var chance : int = int(PlayerStats.player_stats["Free Heat Chance"]*100)
			if chance > 0 and rand_num <= chance:
				return true
		
	return false

func craft_finished_tween() -> void:
	var tween := create_tween()

	tween.tween_property(
		station_graphic,
		"scale",
		Vector2(0.9, 0.9),
		0.1
	)

	tween.tween_property(
		station_graphic,
		"scale",
		Vector2(1.1, 1.1),
		0.1
	)

	tween.tween_property(
		station_graphic,
		"scale",
		Vector2(1.0, 1.0),
		0.1
	)

	await tween.finished
