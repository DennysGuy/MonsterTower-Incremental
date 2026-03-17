class_name GemStoneStation extends Control

@onready var gem_stone_container: GridContainer = $GemStoneContainer
@onready var socket_v_box_container: VBoxContainer = $SocketSword/SocketVBoxContainer

@onready var gem_title: Label = $GemDescription/GemTitle
@onready var gem_icon: TextureRect = $GemDescription/IconPanel/GemIcon
@onready var gem_description: RichTextLabel = $GemDescription/GemDescription

var stored_gem : GemStone
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_gem_station_sockets.connect(update_socket_vbox)
	InventoryManager.populate_market_menu.connect(populate_gem_details)
	update_gem_bag_container()
	update_socket_vbox()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

func update_gem_bag_container() -> void:
	InventoryManager.update_grid_container(gem_stone_container, "Gem Stones", true)

func close_out() -> void:
	GameManager.player_can_move = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()

func _on_close_button_button_up() -> void:
	close_out()

func _on_reset_button_button_up() -> void:
	pass # Replace with function body.

func clear_socket_v_box() -> void:
	for child in socket_v_box_container.get_children():
		child.queue_free()

func update_socket_vbox() -> void:
	clear_socket_v_box()
	for index in range(PlayerStats.get_current_sword().gem_stone_socket_count-1):
		var socket : Socket = preload("uid://bkyhhrkmtnn61").instantiate()
		
		if PlayerStats.get_gem_socket(index):
			socket.gem_stone = PlayerStats.get_gem_socket(index)
		
		socket_v_box_container.add_child(socket)


func populate_gem_details(item : Item, location : String) -> void:
	if item is GemStone:
		stored_gem = item
		gem_title.text = stored_gem.item_name
		gem_icon.texture = stored_gem.shop_icon
		
		


func _on_mount_button_button_up() -> void:
	PlayerStats.equip_gem_to_socket(stored_gem)
	update_socket_vbox()
