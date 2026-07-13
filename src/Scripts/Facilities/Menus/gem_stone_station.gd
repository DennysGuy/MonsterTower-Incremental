class_name GemStoneStation extends Control

@onready var gem_stone_container: GridContainer = $GemStoneContainer
@onready var socket_v_box_container: VBoxContainer = $SocketSword/SocketVBoxContainer
@onready var gem_can_mount_notice: TextureRect = $GemDescription/GemCanMountNotice

@onready var gem_title: Label = $GemDescription/GemTitle
@onready var gem_icon: TextureRect = $GemDescription/IconPanel/GemIcon
@onready var gem_description: RichTextLabel = $GemDescription/GemDescription

@onready var sword_name: Label = $SwordName
@onready var equipped_sword_graphic: TextureRect = $EquippedSwordGraphic
@onready var bag_bg_texture: TextureRect = $BagBGTexture
const MOUNT_ABILITY = preload("uid://bi0i27cx48wbe")

const GEM_STATION_BANK_BG = preload("uid://dqxjguhfoihw5")
const GEM_STATION_GEM_BAG_BG = preload("uid://chft1dsfmivtq")
@onready var sword_details: RichTextLabel = $DescriptionPanel/SwordDetails
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var stored_slot_index : int = -1
var stored_gem : GemStone
var selected_bag : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_gem_station_sockets.connect(update_socket_vbox)
	InventoryManager.populate_market_menu.connect(populate_gem_details)
	sword_name.text = PlayerStats.get_current_sword().sword_name
	equipped_sword_graphic.texture = PlayerStats.get_current_sword().graphic
	update_sword_stats_description()
	selected_bag = "Gem Stones"
	update_gem_bag_container(selected_bag)
	update_socket_vbox()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

func update_gem_bag_container(inventory : String) -> void:
	InventoryManager.update_grid_container(gem_stone_container, inventory, true, [], "Gem Stones")

func close_out() -> void:
	CutsceneManager.enable_player_functionality()
	
	if InventoryManager.inventories["Gem Stones"].size() <= 0:
		HubManager.hide_facility_notification.emit("Gem Stone Station")
		
	PlayerHudSignalBus.hub_menu_exited.emit()
	await get_tree().create_timer(0.3).timeout
	SignalBus.hide_tech_tree_canvas_layer.emit()

	queue_free()

func _on_close_button_button_up() -> void:
	close_out()

func _on_reset_button_button_up() -> void:
	animation_player.play("ResetSockets")

func clear_socket_v_box() -> void:
	for child in socket_v_box_container.get_children():
		child.queue_free()

func update_socket_vbox() -> void:
	GameManager.play_sfx(MOUNT_ABILITY)
	clear_socket_v_box()
	for index in range(PlayerStats.get_current_sword().gem_stone_socket_count):
		var socket : Socket = preload("uid://bkyhhrkmtnn61").instantiate()
		
		if PlayerStats.get_gem_socket(index):
			socket.gem_stone = PlayerStats.get_gem_socket(index)
		
		socket_v_box_container.add_child(socket)


func populate_gem_details(item : Item, location : String, slot_index : int) -> void:
	if item is GemStone:
		stored_gem = item
		stored_slot_index = slot_index
		gem_title.text = stored_gem.item_name
		gem_icon.texture = stored_gem.shop_icon
		gem_description.text = generate_gem_stats()
		if !PlayerStats.equipped_gem_sockets[3]:
			gem_can_mount_notice.show()
		else:
			gem_can_mount_notice.hide()

func _on_mount_button_button_up() -> void:
	var equipped_gem : bool = PlayerStats.equip_gem_to_socket(stored_gem)
	if equipped_gem and stored_slot_index != -1:
		InventoryManager.remove_item_from_slot(stored_slot_index, selected_bag)
		stored_gem = null
		stored_slot_index = -1
		update_sword_stats_description()
		
	gem_can_mount_notice.hide()
	update_gem_bag_container(selected_bag)
	update_socket_vbox()

func _on_gem_bag_button_button_up() -> void:
	bag_bg_texture.texture = GEM_STATION_GEM_BAG_BG
	selected_bag = "Gem Stones"
	update_gem_bag_container(selected_bag)
	print(selected_bag)

func _on_bank_button_button_up() -> void:
	bag_bg_texture.texture = GEM_STATION_BANK_BG
	selected_bag = "Bank"
	update_gem_bag_container(selected_bag)

func generate_gem_stats() -> String:
	
	var stats : String = ""
	
	for stat in stored_gem.get_stat_bonus_list().keys():
		var stat_bonus : float = stored_gem.get_stat_bonus(stat)
		if stat_bonus != 0:
			if stat_bonus > 0:
				if stat_bonus < 1.0:
					stats += "%s: +%s" % [stat, int(stat_bonus * 100)] + "%\n"
				else:
					stats += "%s: +%s\n" % [stat,int(stat_bonus)]
			elif stat_bonus < 0:
				if stat_bonus > -1.0:
					stats += "%s: %s" % [stat, int(stat_bonus * 100)] + "%\n"
				else:
					stats += "%s: %s\n" % [stat, int(stat_bonus)]
	return stats

func update_sword_stats_description() -> void:
	sword_details.text = PlayerStats.get_current_sword().get_stats_gem_bonus_description()

func reset_sockets() -> void:
	PlayerStats.reset_gem_sockets()
	update_socket_vbox()
	update_sword_stats_description()
	if stored_gem:
		gem_can_mount_notice.show()
	
