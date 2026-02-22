class_name ClassSelectionMenu extends Control

var selected_class : String = "Tyro"
@onready var select_button: Button = $Panel/SelectButton

@onready var mage_panel: TextureRect = $Panel/MagePanel
@onready var warrior_panel: TextureRect = $Panel/WarriorPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_warrior_select_2_button_up() -> void:
	GameManager.player_can_move = true
	queue_free()

func _on_warrior_select_button_up() -> void:
	GameManager.player_can_move = true
	PlayerStats.player_stats["Class"] = "Tyro"
	SignalBus.update_player_uniform.emit("Idle")
	queue_free()

func _on_warrior_select_button_button_up() -> void:
	selected_class = "Tyro"
	warrior_panel.show()
	mage_panel.hide()
	select_button.disabled = false

func _on_mage_select_button_button_up() -> void:
	selected_class = "Mage"
	mage_panel.show()
	warrior_panel.hide()
	select_button.disabled = true
	
func _on_select_button_button_up() -> void:
	PlayerStats.player_stats["Class"] = selected_class
	SignalBus.update_player_uniform.emit("Idle")
	GameManager.player_can_move = true
	#Go to class tech tree
	queue_free()


func _on_exit_button_button_up() -> void:
	GameManager.player_can_move = true
	queue_free()
