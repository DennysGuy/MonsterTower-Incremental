class_name WeaponRecipeTrackerListItem extends Control

@onready var icon: TextureRect = $PanelContainer/HBoxContainer/Icon
@onready var label: RichTextLabel = $PanelContainer/HBoxContainer/Label
@export var animation_player: AnimationPlayer

const TASK_WHOOSH_IN = preload("uid://bjtt00e54ppwb")

@export var item : Item
@export var needed_quantity : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_label()
	SignalBus.inventory_changed.connect(set_label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bring_in_task() -> void:
	animation_player.play("SlideIn")
	GameManager.play_sfx(TASK_WHOOSH_IN,-1.5)

func set_label() -> void:
	icon.texture = item.shop_icon
	var current_quantity : int = InventoryManager.get_quantity(item, item.get_inventory_name())
	if current_quantity >= needed_quantity:
		label.text = "[color=green]%s %s/%s[/color]" % [item.item_name, current_quantity, needed_quantity]
	else:
		label.text = "%s %s/%s" % [item.item_name, current_quantity, needed_quantity]
