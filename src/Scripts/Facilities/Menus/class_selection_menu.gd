class_name ClassSelectionMenu extends Control

var selected_class : String = "Tyro"
@onready var select_button: Button = $Panel/SelectButton

@onready var mage_panel: TextureRect = $Panel/MagePanel
@onready var warrior_panel: TextureRect = $Panel/WarriorPanel
const WARRIOR_CLASS_SELECTION_SCENE = preload("uid://casnupgin4eo")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_to_new_class_outfit.connect(set_new_class_outfit_graphic)
	GameManager.can_pause_game = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

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


func _on_mage_select_button_button_up() -> void:
	selected_class = "Scribe Assistant"
	mage_panel.show()
	warrior_panel.hide()

	
func _on_select_button_button_up() -> void:
	MusicPlayer.pause_music()
	var class_up_sequence : CraftingAnimation = preload("uid://2bfb4gmhtb7").instantiate()
	get_parent().add_child(class_up_sequence)
	hide()
	class_up_sequence.play_class_upgrade_sequence()
	await get_tree().create_timer(11.0).timeout
	QuestManager.check_general_task_for_completion.emit("Select Your Class")
	SignalBus.spawn_warrior_tech_tree.emit()
	MusicPlayer.unpause_music()
	Dialogic.start(WARRIOR_CLASS_SELECTION_SCENE)
	GameManager.first_class_just_unlocked = true
	queue_free()

func set_new_class_outfit_graphic() -> void:
	PlayerStats.player_stats["Class"] = selected_class
	SignalBus.update_player_uniform.emit("Idle")
	SaveManager.save_player_stats()

func _on_exit_button_button_up() -> void:
	close_out()

func close_out() -> void:
	CutsceneManager.enable_player_functionality()
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()
