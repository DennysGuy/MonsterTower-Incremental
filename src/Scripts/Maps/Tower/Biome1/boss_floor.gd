class_name MossyDungeonBossMap extends Map

@onready var activation_switch: GreySentinelActivationSwitch = $ActivationSwitch
@onready var sentinel_holding_platform: Sprite2D = $SentinelHoldingPlatform
@onready var grey_sentinel_mini: GreySentinelMini = $GreySentinelMini
@onready var god_rays: ColorRect = $GodRays

var boss : Boss
@onready var boss_spawn_point: Marker2D = $BossSpawnPoint
@onready var mini_boss_death_point: Marker2D = $MiniBossDeathPoint

const DELETE_SWITCH_PLATFORM = preload("uid://daadfftvbie32")
const WHOOSH_OUT = preload("uid://cvn02i878pp3e")
const BOSS_THEME = preload("uid://biynll3nsb3v7")
const GREY_SENTINEL_BOSS_INTRO = preload("uid://cmu23mgbyeh2w")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalBus.start_boss_fight.connect(start_boss_fight)
	SignalBus.play_boss_death_scene.connect(mini_boss_death_scene)
	SignalBus.go_to_outro_screen.connect(go_to_outro_screen)
	await get_tree().process_frame
	SignalBus.update_banner_info.emit(tower_entrance_data)
	CutsceneManager.fly_boss_out.connect(fly_boss_out)
	PlayerHudSignalBus.update_map_name_label.emit(map_name)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_boss_fight_timer() -> void:
	ExpeditionTimer.start_hunt_timer()

func load_boss_fight_timer() -> void:
	ExpeditionTimer.set_time_for_door_challenge(120)
	PlayerHudSignalBus.load_timer_label.emit()
	PlayerHudSignalBus.show_stop_watch.emit()
	
func delete_switch_and_platform() -> void:
	play_sfx(DELETE_SWITCH_PLATFORM,0.0)
	activation_switch.queue_free()
	sentinel_holding_platform.queue_free()
	
func start_boss_fight() -> void:
	await get_tree().create_timer(2.0).timeout
	delete_switch_and_platform()
	await get_tree().create_timer(2.0).timeout
	grey_sentinel_mini.play_activation_animation()
	await get_tree().create_timer(1.0).timeout
	grey_sentinel_mini.play_idle_animation()
	await get_tree().create_timer(3.0)
	Dialogic.start(GREY_SENTINEL_BOSS_INTRO)

func fly_boss_out() -> void:
	god_rays.hide()
	var tween : Tween = get_tree().create_tween()
	play_sfx(WHOOSH_OUT,0.0)
	tween.tween_property(grey_sentinel_mini, "global_position",Vector2(grey_sentinel_mini.global_position.x, -300), 1.0)
	await get_tree().create_timer(3.0).timeout
	boss = preload("uid://cd6yt6xvah0em").instantiate()
	boss.drop_scene = self
	boss.global_position = boss_spawn_point.global_position
	add_child(boss)
	await get_tree().create_timer(4.0).timeout
	PlayerHudSignalBus.issue_big_notification.emit("Ready?")
	MusicPlayer.play_song(BOSS_THEME)
	PlayerHudSignalBus.show_boss_hp_bar.emit()
	load_boss_fight_timer()
	await get_tree().create_timer(3.0).timeout
	PlayerHudSignalBus.issue_big_notification.emit("Fight!")
	boss.send_to_idle_state()
	start_boss_fight_timer()
	await get_tree().create_timer(3.0).timeout
	PlayerHudSignalBus.hide_big_notification.emit()

func mini_boss_death_scene() -> void:
	MusicPlayer.stop_player()
	PlayerHudSignalBus.flash_screen.emit()
	await get_tree().create_timer(0.5).timeout
	boss.queue_free()
	grey_sentinel_mini.global_position = mini_boss_death_point.global_position
	grey_sentinel_mini.play_death_animation()
	await get_tree().create_timer(5.0).timeout
	spawn_rewards_chest()
	
func go_to_outro_screen() -> void:
	PlayerHudSignalBus.play_close_out_animation.emit()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("uid://bhdmpf736ro3j")

func spawn_rewards_chest() -> void:
	var rewards_chest : BossRewaredsChest = preload("uid://cji2sopodl4w1").instantiate()
	rewards_chest.global_position = boss_spawn_point.global_position
	add_child(rewards_chest)
