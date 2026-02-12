class_name PlayerHUD extends CanvasLayer

@onready var player_health_bar: TextureProgressBar = $PlayerHUD/PlayerHealthBar
@onready var player_mp_bar: TextureProgressBar = $PlayerHUD/PlayerMPBar
@onready var player_hud: Control = $PlayerHUD
@export var animation_player: AnimationPlayer
@onready var hp_label: Label = $PlayerHUD/HPLabel
@export var map_name_label: Label
@onready var bag_animation_player: AnimationPlayer = $BagAnimationPlayer
var bag_showing : bool = false
var map_name : String = ""

@onready var hunt_quota: RichTextLabel = $PlayerHUD/HuntQuota
@export var expedition_timer: ExpeditionTimerLocal
@onready var big_notification_label: Label = $PlayerHUD/BigNotificationLabel
@onready var sfx_player: SFXPlayer = $SfxPlayer
@onready var bag_2: OreBag = $PlayerHUD/Bag2

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

@onready var monsters_left: RichTextLabel = $PlayerHUD/MonstersLeft

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
	
	SignalBus.show_can_cook_dish_label.connect(show_can_cook_dish)
	SignalBus.show_can_smelt_bar_label.connect(show_can_smelt_bar)
	SignalBus.show_can_craft_sword.connect(show_can_craft_sword)
	
	SignalBus.hide_can_cook_dish_label.connect(hide_can_cook_dish)
	SignalBus.hide_can_smelt_bar_label.connect(hide_can_smelt_bar)
	SignalBus.hide_can_craft_sword.connect(hide_can_craft_sword)
	
	TechTreeManager.update_currency_label.connect(update_currency_label)
	#player_health_bar.max_value = PlayerStats.player_stats["Max Health"]
	#player_health_bar.value = PlayerStats.player_stats["Current Health"]
	
	LevelingManager.update_xp_bar.connect(update_xp_bar)
	
	player_mp_bar.max_value = PlayerStats.player_stats["Current MP"]
	player_mp_bar.value = player_mp_bar.max_value
	update_xp_bar()
	#update_player_health(int(PlayerStats.player_stats["Current Health"]))
	
	if PlayerStats.facilities_unlocked["Refinery Station"]:
		bag_2.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_bag"):
		show_bag()

func update_player_health(value : int) -> void:
	player_health_bar.value = value
	player_health_bar.max_value = PlayerStats.player_stats["Max Health"]
	hp_label.text = "%s/%s" % [int(player_health_bar.value), int(player_health_bar.max_value)]

func update_xp_bar() -> void:
	level_label.text = "Level %s" % [int(PlayerStats.player_stats["Level"])]
	xp_amount_label.text = "%s / %s XP" % [int(PlayerStats.player_stats["Current XP"]), int(PlayerStats.player_stats["Needed XP"])]
	xp_bar.max_value = PlayerStats.player_stats["Needed XP"]
	xp_bar.value = PlayerStats.player_stats["Current XP"]

func spawn_respawn_box() -> void:
	var respawn_box : RespawnBox = preload("uid://dv20tfcnkjyux").instantiate()
	player_hud.add_child(respawn_box)

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
		bag_animation_player.play("ShowBag")
	else:
		bag_animation_player.play("HideBag")

func start_expedition_timer() -> void:
	expedition_timer.show()
	if !GameManager.expedition_timer_started:
		ExpeditionTimer.start_timer()

func set_hunt_timer() -> void:
	expedition_timer.show()
	ExpeditionTimer.set_time_for_hunt()

func start_hunt_timer() -> void:
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

func show_can_cook_dish() -> void:
	can_cook_dish.show()

func show_can_smelt_bar() -> void:
	can_smelt_bar.show()

func show_can_craft_sword() -> void:
	can_craft_sword.show()

func hide_can_cook_dish() -> void:
	can_cook_dish.hide()

func hide_can_smelt_bar() -> void:
	can_smelt_bar.hide()

func hide_can_craft_sword() -> void:
	can_craft_sword.hide()

func remaining_monsters(text : String, out_of_enmies : bool) -> void:
	if !out_of_enmies:
		monsters_left.text = text
	else:
		monsters_left.text = "[color=yellow]Out of Monsters!\nIncrease Cap![/color]"

func start_timer() -> void:
	pass
