class_name PlayerHUD extends CanvasLayer

@export var player_health_bar: TextureProgressBar
@export var player_mp_bar: TextureProgressBar
@onready var player_hud: Control = $PlayerHUD
@export var animation_player: AnimationPlayer
@export var hp_label: Label 
@export var mp_label: Label
@export var map_name_label: Label
@onready var bag_animation_player: AnimationPlayer = $BagAnimationPlayer
var bag_showing : bool = false
var map_name : String = ""
@onready var quest_hub: QuestHub = $PlayerHUD/QuestHub

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

@onready var codex: Codex = $PlayerHUD/Codex

const CLOSE_IN = preload("uid://dc3va7knibxnb")
const CLOSE_OUT = preload("uid://caj0oih8j2sty")
const COUNTDOWN_BEEP = preload("uid://c6caiqmkt2lt0")
const BAG_CLOSED = preload("uid://bf3c8p3fgc0mh")
const BAG_OPEN = preload("uid://dlh2yqqt6l81t")
const QUEST_COMPLETED = preload("uid://om1y244uqbs")

@onready var monsters_left: RichTextLabel = $PlayerHUD/MonstersLeft
@onready var start_hunt_challenge_button: Button = $PlayerHUD/StartHuntChallengeButton

@onready var max_slot_stack: Label = $PlayerHUD/MaxSlotStack


@onready var pick_up_notifier: VBoxContainer = $PlayerHUD/PickUpNotifier
@onready var class_notice: RichTextLabel = $PlayerHUD/ClassNotice

@onready var open_bag_notice: Control = $PlayerHUD/OpenBagNotice

@onready var bag: InventoryBag = $PlayerHUD/Bag
@onready var codex_notification_panel: CodexNotificationPanel = $PlayerHUD/CodexNotificationPanel

@onready var ap_available_label: RichTextLabel = $PlayerHUD/ApAvailableLabel
@onready var open_tower_map_button: Button = $PlayerHUD/OpenTowerMapButton
@onready var quest_tracker_player: AnimationPlayer = $QuestTrackerPlayer

var quests_showing : bool = false
@onready var advance_class_notice: RichTextLabel = $PlayerHUD/AdvanceClassNotice

@onready var boss_hp_bar: BossHPBar = $PlayerHUD/BossHPBar

var codex_open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerHudSignalBus.update_player_health.connect(update_player_health)
	PlayerHudSignalBus.spawn_respawn_box.connect(spawn_respawn_box)
	PlayerHudSignalBus.issue_big_notification.connect(issue_big_notification)
	PlayerHudSignalBus.hide_big_notification.connect(hide_big_notification_label)
	PlayerHudSignalBus.play_close_out_animation.connect(play_close_out_animation)
	
	PlayerHudSignalBus.update_kill_quota_text.connect(update_kill_quota_text)
	PlayerHudSignalBus.update_monsters_left.connect(remaining_monsters)
	PlayerHudSignalBus.play_countdown_beep.connect(play_countdown_beep)
	
	PlayerHudSignalBus.update_player_mp.connect(update_player_mp)
	PlayerHudSignalBus.update_map_name_label.connect(update_map_name_level)
	
	PlayerHudSignalBus.enable_tower_map_button.connect(enable_tower_map_button)
	PlayerHudSignalBus.show_hunt_challenge_button.connect(show_hunt_challenge_button)
	PlayerHudSignalBus.flash_screen.connect(flash_screen)
	
	PlayerHudSignalBus.start_hunt_intro.connect(start_hunt_intro)
	SignalBus.hide_hunt_challenge_button.connect(hide_hunt_challenge_button)
	#PlayerHudSignalBus.show_stop_watch.connect(show_stop_watch)
	PlayerHudSignalBus.start_stop_watch.connect(start_expedition_timer)
	PlayerHudSignalBus.populate_item_notification_panel.connect(populate_pick_notification_panel)
	TechTreeManager.update_currency_label.connect(update_currency_label)
	#player_health_bar.max_value = PlayerStats.player_stats["Max Health"]
	#player_health_bar.value = PlayerStats.player_stats["Current Health"]
	
	PlayerHudSignalBus.show_boss_hp_bar.connect(show_boss_hp_bar)
	
	CodexManager.show_codex.connect(toggle_codex_on)
	CodexManager.hide_codex.connect(toggle_codex_off)
	CodexManager.show_codex_notification.connect(show_codex_message)
	
	LevelingManager.update_xp_bar.connect(update_xp_bar)
	PlayerHudSignalBus.show_class_notice.connect(show_class_notice)
	InventoryManager.show_open_bag_notice.connect(show_open_bag_notice)
	InventoryManager.hide_open_bag_notice.connect(hide_open_bag_notice)
	QuestManager.show_quest_complete_notice.connect(quest_complete_notice)
	#player_mp_bar.max_value = PlayerStats.player_stats["Current MP"]
	#player_mp_bar.value = player_mp_bar.max_value
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
			
	if Input.is_action_just_pressed("open_codex"):
		if !codex_open:
			open_codex()
		else:
			close_codex()
	
	if Input.is_action_just_pressed("open_player_stats"):
		CodexManager.open_a_codex_menu.emit(0)
	
	if Input.is_action_just_pressed("open_recipe_book"):
		CodexManager.open_a_codex_menu.emit(1)
	
	if Input.is_action_just_pressed("open_monsterpedia"):
		CodexManager.open_a_codex_menu.emit(2)
		
	if Input.is_action_just_pressed("open_quests_log"):
		CodexManager.open_a_codex_menu.emit(3)
	
func update_player_health() -> void:
	var current_hp : int = PlayerStats.player_stats["Current Health"]
	var max_hp : int = PlayerStats.player_stats["Max Health"] + PlayerStats.get_current_sword().get_total_hp_bonus()
	player_health_bar.value = current_hp
	player_health_bar.max_value = max_hp
	hp_label.text = "%s/%s" % [int(current_hp), int(max_hp)]

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

func toggle_codex_on() -> void:
	if !codex_open:
		open_codex()
		codex_open = true

func toggle_codex_off() -> void:
	close_codex()

func show_codex_message() -> void:
	play_sfx(QUEST_COMPLETED)
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(codex_notification_panel, "position", Vector2(26,453),0.1)
	await get_tree().create_timer(4.0).timeout
	var tween_2 : Tween = get_tree().create_tween()
	tween_2.tween_property(codex_notification_panel, "position", Vector2(-573,453),0.1)

func show_boss_hp_bar() -> void:
	boss_hp_bar.show()

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

func show_stop_watch() -> void:
	expedition_timer.show()

func start_hunt_intro() -> void:
	animation_player.play("StartHuntChallenge")

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
	expedition_timer.load_timer_label()

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
	play_sfx(COUNTDOWN_BEEP)

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

func update_map_name_level(name : String) -> void:
	map_name_label.text = name

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

func quest_complete_notice() -> void:
	big_notification_label.show()
	big_notification_label.text = "Quest Complete!"
	await get_tree().create_timer(3.0).timeout
	big_notification_label.hide()


func close_codex() -> void:
	GameManager.player_can_move = true
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(codex, "position", Vector2(-874,540),0.3)
	codex_open = false

func open_codex() -> void:
	GameManager.player_can_move = false
	CodexManager.update_monster_cards.emit()
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(codex, "position", Vector2(960,540),0.3)
	codex_open = true
