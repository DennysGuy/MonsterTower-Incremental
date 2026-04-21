class_name PlayerHUD extends CanvasLayer

@onready var player_health_bar: TextureProgressBar = $PlayerHUD/PlayerHealthBar
@onready var player_mp_bar: TextureProgressBar = $PlayerHUD/PlayerMPBar
@onready var player_hud: Control = $PlayerHUD
@export var animation_player: AnimationPlayer
@onready var hp_label: Label = $PlayerHUD/HPLabel
@onready var mp_label: Label = $PlayerHUD/MPLabel
@export var map_name_label: Label
@onready var bag_animation_player: AnimationPlayer = $BagAnimationPlayer
var bag_showing : bool = false
var map_name : String = ""

@onready var hunt_quota: RichTextLabel = $PlayerHUD/HuntQuota
@export var expedition_timer: ExpeditionTimerLocal
@onready var big_notification_label: Label = $PlayerHUD/BigNotificationLabel
@onready var sfx_player: SFXPlayer = $SfxPlayer

@onready var can_cook_dish: RichTextLabel = $PlayerHUD/CanCookDish
@onready var can_smelt_bar: RichTextLabel = $PlayerHUD/CanSmeltBar
@onready var can_craft_sword: RichTextLabel = $PlayerHUD/CanCraftSword

@onready var xp_amount_label: Label = $PlayerHUD/XPAmountLabel
@onready var xp_bar: TextureProgressBar = $PlayerHUD/XPBar
@onready var level_label: Label = $PlayerHUD/LevelLabel
@onready var currency_label: RichTextLabel = $PlayerHUD/CurrencyLabel


const CLOSE_IN = preload("uid://dc3va7knibxnb")
const CLOSE_OUT = preload("uid://caj0oih8j2sty")
const COUNTDOWN_BEEP = preload("uid://c6caiqmkt2lt0")
const BAG_CLOSED = preload("uid://bf3c8p3fgc0mh")
const BAG_OPEN = preload("uid://dlh2yqqt6l81t")

@onready var monsters_left: RichTextLabel = $PlayerHUD/MonstersLeft
@onready var start_hunt_challenge_button: Button = $PlayerHUD/StartHuntChallengeButton

@onready var max_slot_stack: Label = $PlayerHUD/MaxSlotStack


@onready var pick_up_notifier: VBoxContainer = $PlayerHUD/PickUpNotifier
@onready var class_notice: RichTextLabel = $PlayerHUD/ClassNotice

@onready var open_bag_notice: Control = $PlayerHUD/OpenBagNotice

@onready var bag: InventoryBag = $PlayerHUD/Bag

@onready var ap_available_label: RichTextLabel = $PlayerHUD/ApAvailableLabel
@onready var open_tower_map_button: Button = $PlayerHUD/OpenTowerMapButton
@onready var quest_tracker_player: AnimationPlayer = $QuestTrackerPlayer

var quests_showing : bool = false
@onready var advance_class_notice: RichTextLabel = $PlayerHUD/AdvanceClassNotice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_player_health.connect(update_player_health)
	SignalBus.spawn_respawn_box.connect(spawn_respawn_box)
	SignalBus.issue_big_notification.connect(issue_big_notification)
	SignalBus.hide_big_notification.connect(hide_big_notification_label)
	SignalBus.play_close_out_animation.connect(play_close_out_animation)
	
	SignalBus.update_kill_quota_text.connect(update_kill_quota_text)
	SignalBus.update_monsters_left.connect(remaining_monsters)
	SignalBus.play_countdown_beep.connect(play_countdown_beep)
	
	SignalBus.update_player_mp.connect(update_player_mp)
	
	SignalBus.enable_tower_map_button.connect(enable_tower_map_button)
	SignalBus.show_hunt_challenge_button.connect(show_hunt_challenge_button)
	SignalBus.flash_screen.connect(flash_screen)
	
	SignalBus.populate_item_notification_panel.connect(populate_pick_notification_panel)
	TechTreeManager.update_currency_label.connect(update_currency_label)
	#player_health_bar.max_value = PlayerStats.player_stats["Max Health"]
	#player_health_bar.value = PlayerStats.player_stats["Current Health"]
	
	LevelingManager.update_xp_bar.connect(update_xp_bar)
	SignalBus.show_class_notice.connect(show_class_notice)
	InventoryManager.show_open_bag_notice.connect(show_open_bag_notice)
	InventoryManager.hide_open_bag_notice.connect(hide_open_bag_notice)
	
	player_mp_bar.max_value = PlayerStats.player_stats["Current MP"]
	player_mp_bar.value = player_mp_bar.max_value
	
	update_xp_bar()
	#update_ap_label()
	#update_player_health(int(PlayerStats.player_stats["Current Health"]))
	#show_class_notice()
	animation_player.play("CloseIn")
	if GameManager.can_unlock_class():
		show_class_notice()
	
	#quest_tracker_player.play("QuestHubQuickView")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_bag") and GameManager.can_open_bag:
		show_bag()
	
	if Input.is_action_just_pressed("show_quests"):
		quests_showing = !quests_showing
		if quests_showing:
			show_quests()
		else:
			hide_quests()

func update_player_health(value : int) -> void:
	player_health_bar.value = value
	player_health_bar.max_value = PlayerStats.player_stats["Max Health"] + PlayerStats.get_current_sword().get_total_hp_bonus()
	hp_label.text = "%s/%s" % [int(player_health_bar.value), int(player_health_bar.max_value)]

func update_player_mp() -> void:
	var current_mp : int = PlayerStats.player_stats["Current MP"]
	var max_mp : int = PlayerStats.player_stats["Max MP"]
	player_mp_bar.value = current_mp
	player_mp_bar.max_value = max_mp
	mp_label.text = "%s/%s" % [current_mp,max_mp]


func update_xp_bar() -> void:
	level_label.text = "Level %s" % [int(PlayerStats.player_stats["Level"])]
	xp_amount_label.text = "%s / %s XP" % [int(PlayerStats.player_stats["Current XP"]), int(PlayerStats.player_stats["Needed XP"])]
	xp_bar.max_value = PlayerStats.player_stats["Needed XP"]
	xp_bar.value = PlayerStats.player_stats["Current XP"]

func spawn_respawn_box() -> void:
	var respawn_box : RespawnBox = preload("uid://dv20tfcnkjyux").instantiate()
	player_hud.add_child(respawn_box)

func show_open_bag_notice() -> void:
	open_bag_notice.show()

func hide_open_bag_notice() -> void:
	open_bag_notice.hide()

func show_quests() -> void:
	quest_tracker_player.play("ShowQuestHub")

func hide_quests() -> void:
	quest_tracker_player.play("HideQuestHub")

func quick_quests_preview() -> void:
	quest_tracker_player.play("QuestHubQuickView")

func enable_tower_map_button() -> void:
	open_tower_map_button.disabled = false

func update_kill_quota_text(message : String, quota_met : bool, challenge_unlocked : bool) -> void:
	if is_inside_tree():
		await get_tree().process_frame
		if GameManager.hunt_challenge_selected:
			if quota_met:
				hunt_quota.text = "[color=green]Hunt Completed! Head to the Exit Elevator![/color]"
			else:
				hunt_quota.text = message
		else:
			if !quota_met:
				if challenge_unlocked:
					hunt_quota.text = "Beat the Hunt Challenge to unlock the next floor!"
				else:
					hunt_quota.text = "Discover all campfires to unlock Challenge Hunt!"
			else:
			
				hunt_quota.text = "[color=green]Next Floor Unlocked![/color]"

func update_currency_label() -> void:
	currency_label.text = "[color=aqua]Currency: %s[/color]" % TechTreeManager.currency

func show_bag() -> void:
	bag_showing = !bag_showing
	if bag_showing:
		InventoryManager.hide_open_bag_notice.emit()
		SignalBus.stop_player.emit()
		GameManager.player_can_move = false
		bag.enable_tabs()
		bag.update_bag()
		play_sfx(BAG_OPEN)
		bag_animation_player.play("ShowBag")
	else:
		GameManager.player_can_move = true
		play_sfx(BAG_CLOSED)
		bag.disable_tabs()
		bag_animation_player.play("HideBag")

func start_expedition_timer() -> void:
	expedition_timer.show()
	if !GameManager.expedition_timer_started:
		ExpeditionTimer.start_timer()

func set_hunt_timer() -> void:
	expedition_timer.show()
	ExpeditionTimer.set_time_for_hunt(90)

func start_hunt_timer() -> void:
	GameManager.enemies_can_move = true
	ExpeditionTimer.start_hunt_timer()

func load_expedition_timer_with_hunt_time() -> void:
		expedition_timer.show()

func issue_big_notification(message : String) -> void:
	big_notification_label.text = message
	big_notification_label.show()
	
func hide_big_notification_label() -> void:
	big_notification_label.text = ""
	big_notification_label.hide()

func play_close_out_animation() -> void:
	animation_player.play("CloseOut")

func play_close_out_sfx() -> void:
	sfx_player.play_sfx(CLOSE_OUT)

func play_close_in_sfx() -> void:
	sfx_player.play_sfx(CLOSE_IN)

func play_countdown_beep() -> void:
	sfx_player.play_sfx(COUNTDOWN_BEEP)

func show_class_notice() -> void:
	advance_class_notice.show()
	
func remaining_monsters(text : String, out_of_enmies : bool) -> void:
	if !out_of_enmies:
		monsters_left.text = text
	else:
		monsters_left.text = "[color=yellow]Out of Monsters!\nIncrease Cap![/color]"

func start_timer() -> void:
	pass


func show_hunt_challenge_button() -> void:
	start_hunt_challenge_button.show()

func hide_hunt_challenge_button() -> void:
	start_hunt_challenge_button.hide()

func _on_start_hunt_challenge_button_button_up() -> void:
	GameManager.hunt_challenge_selected = true
	GameManager.resupply_character = true
	GameManager.spawn_location = 0
	get_tree().change_scene_to_file(GameManager.previous_map_data.scene_path)

func populate_pick_notification_panel(item_data : Item) -> void:
	var notification_item : PickupNotificationItem = preload("uid://b1s1ecflwq2pn").instantiate()
	if item_data is EnemyDrop:
		notification_item.icon.texture = item_data.drop_icon
	else:
		notification_item.icon.texture = item_data.shop_icon
	
	notification_item.label.text = "Picked up 1 %s" % item_data.item_name
	pick_up_notifier.add_child(notification_item)

func flash_screen() -> void:
	animation_player.play("Flash")

func _on_open_tower_map_button_button_up() -> void:
	if !GameManager.can_open_tower_map:
		return
	
	SignalBus.spawn_tower_map.emit()

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
