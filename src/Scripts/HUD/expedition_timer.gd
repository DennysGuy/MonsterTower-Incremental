extends Control

@onready var timer_label: RichTextLabel = $TimerLabel
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
				SignalBus.return_to_starshire.emit()
		
func start_timer() -> void:
	seconds = PlayerStats.player_stats["Expedition Time"]
	milliseconds = 0.99
	GameManager.expedition_timer_started = true


func set_time_for_hunt() -> void:
	seconds = PlayerStats.player_stats["Hunt Time"]
	milliseconds = 0.99

func start_hunt_timer() -> void:
	GameManager.expedition_timer_started = true
