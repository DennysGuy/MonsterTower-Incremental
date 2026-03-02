class_name NewCraftingStation extends Node2D

enum STATION_TYPE {SMELTING,COOKING}
@export var station_type : STATION_TYPE
@onready var menu_location: Marker2D = $MenuLocation
@export var station_graphic: TextureRect
@onready var name_tag: NameTag = $NameTag

var player_in_range : bool = false

const TEMP_COOKING_RANGE = preload("uid://bry4670ns2btd")
const TEMP_COOKING_RANGE_CONTSTRUCTION = preload("uid://53gha3pmge8a")

const SMELTING_STATION_CONTRUCTION_MODE = preload("uid://chhm5f5xmlr0j")
const SMELTING_STATION = preload("uid://btbqj1pb1hac")


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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		GameManager.player_can_attack = false
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
	add_child(cooking_menu)

func spawn_refinery_menu() -> void:
	var refinery_menu : NewCraftingStationMenu = preload("uid://dq1s8bd6w6dnv").instantiate()
	refinery_menu.set_as_refinery()
	refinery_menu.position = menu_location.position
	stored_crafting_menu = refinery_menu
	add_child(refinery_menu)
