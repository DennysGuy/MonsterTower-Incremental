class_name ItemSlot extends TextureRect

@export var item : Item

enum SLOT_TYPE {BAG, BANK, SHOP}
enum SLOT_LOCALE {INVENTORY, BANK}
@export var slot_locale = SLOT_LOCALE.INVENTORY
@export var slot_type : SLOT_TYPE = SLOT_TYPE.BAG
@export var slot_index : int
@export var item_icon: TextureRect
@export var quantity_label: Label

@export var indicator_cooking: TextureRect
@export var indicator_novelty: TextureRect
@export var indicator_crafting: TextureRect
@export var indicator_na: TextureRect

const ITEM_CLICK_1 = preload("uid://0e5ni3t5cmhh")
const ITEM_CLICK_2 = preload("uid://dj4vrx0fpqy16")
const ITEM_CLICK_3 = preload("uid://cmwobqjdrj10t")
const ITEM_CLICK_4 = preload("uid://b68oki1240pw2")
const ITEM_CLICK_5 = preload("uid://c5y2qkkyypkf8")

@onready var clicks : Array[AudioStream] = [ITEM_CLICK_1,ITEM_CLICK_2,ITEM_CLICK_3,ITEM_CLICK_4,ITEM_CLICK_5]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_quantity_label(quantity : int) -> void:
	if slot_type == SLOT_TYPE.BAG or slot_locale == SLOT_LOCALE.INVENTORY:
		quantity_label.text = "%s/%s" % [quantity, int(PlayerStats.player_stats["Max Bag Stack"])]
	elif slot_type == SLOT_TYPE.BANK or slot_locale == SLOT_LOCALE.BANK:
		quantity_label.text = "%s/%s" % [quantity, int(PlayerStats.player_stats["Max Bank Stack"])]
	else:
		quantity_label.text = str(quantity)
	quantity_label.show()

func set_as_shop_slot() -> void:
	slot_type = SLOT_TYPE.SHOP

func set_locale_as_bank() -> void:
	slot_locale = SLOT_LOCALE.BANK

func set_as_bank_slot() -> void:
	slot_type = SLOT_TYPE.BANK

func set_indicator(potential_item : Item) -> void:
	match potential_item.item_type:
		potential_item.ITEM_TYPE.NOVELTY:
			indicator_novelty.show()
		potential_item.ITEM_TYPE.COOKING:
			indicator_cooking.show()
		potential_item.ITEM_TYPE.CRAFTING:
			indicator_crafting.show()
		potential_item.ITEM_TYPE.ORE:
			indicator_crafting.show()
		_:
			indicator_na.show()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if slot_type == SLOT_TYPE.BAG:
				InventoryManager.populate_inventory_description.emit(item,slot_index)
				play_sfx(clicks.pick_random())
				return
			var slot_location : String
			match slot_locale:
				SLOT_LOCALE.INVENTORY:
					if item:
						slot_location = item.get_inventory_name()
				SLOT_LOCALE.BANK:
					slot_location = "Bank"
					
			InventoryManager.populate_market_menu.emit(item,slot_location,slot_index)

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
