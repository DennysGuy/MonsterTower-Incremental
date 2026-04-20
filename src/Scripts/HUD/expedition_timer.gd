extends Control

@onready var sfx_player: SFXPlayer = preload("uid://d080wmb3mv021").instantiate()

var seconds : float = 0.0
var milliseconds : float = 0.0
const COUNTDOWN_BEEP = preload("uid://c6caiqmkt2lt0")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if GameManager.expedition_timer_started:
		milliseconds -= delta
		if milliseconds <= 0.0:
			seconds -= 1
			
			if seconds <= 10:
				SignalBus.play_countdown_beep.emit()
			
			milliseconds = 0.99
			if seconds <= 0:
				GameManager.expedition_timer_started = false
				if GameManager.hunt_challenge_selected or GameManager.on_boss_door_floor:
					SignalBus.go_to_failure_hunt_menu.emit()
				else:
					SignalBus.return_to_starshire.emit()

func start_timer() -> void:
	seconds = PlayerStats.player_stats["Expedition Time"]
	milliseconds = 0.99
	GameManager.expedition_timer_started = true

func stop_timer() -> void:
	GameManager.expedition_timer_started = false

func set_time_for_hunt(time : int) -> void:
	seconds = time
	milliseconds = 0.99

func set_time_for_door_challenge(time : int) -> void:
	seconds = time
	milliseconds = 0.99

func start_hunt_timer() -> void:
	GameManager.expedition_timer_started = true
