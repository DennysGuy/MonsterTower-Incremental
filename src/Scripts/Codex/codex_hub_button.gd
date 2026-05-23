class_name CodexHUBButton extends Control

const CRAFTING_RECIPE_BOOK = preload("uid://b315u3ix0ox8f")
const QUESTS_LOG_BUTTON = preload("uid://elvpq15fjh2f")
const MONSTER_PEDIA_BUTTON = preload("uid://bwsvb4youc6bv")
const PLAYER_STATS_BUTTON = preload("uid://c6gv8laq666r4")

const NEW_HUD_KEYBOARD_ICON_F_1_PNG = preload("uid://g2ytxb3fdj58")
const NEW_HUD_KEYBOARD_ICON_F_2 = preload("uid://dxnvy427ne054")
const NEW_HUD_KEYBOARD_ICON_F_3 = preload("uid://k80bu37xtrna")
const NEW_HUD_KEYBOARD_ICON_F_4 = preload("uid://bnebuppkwk3ju")

@onready var button_icon: TextureRect = $ButtonIcon
@onready var short_cut_key_icon: TextureRect = $ShortCutKeyIcon
@onready var panel_container: PanelContainer = $PanelContainer
@onready var description: Label = $PanelContainer/Description


enum BUTTON_TYPE {PLAYER_STATS, CRAFTING_RECIPE_BOOK, MONSTERPEDIA, QUESTS_LOG}
@export var button_type : BUTTON_TYPE = BUTTON_TYPE.PLAYER_STATS

var in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match button_type:
		BUTTON_TYPE.CRAFTING_RECIPE_BOOK:
			button_icon.texture = CRAFTING_RECIPE_BOOK
			short_cut_key_icon.texture = NEW_HUD_KEYBOARD_ICON_F_2 
		BUTTON_TYPE.PLAYER_STATS:
			button_icon.texture = PLAYER_STATS_BUTTON
			short_cut_key_icon.texture = NEW_HUD_KEYBOARD_ICON_F_1_PNG
		BUTTON_TYPE.MONSTERPEDIA:
			button_icon.texture = MONSTER_PEDIA_BUTTON
			short_cut_key_icon.texture = NEW_HUD_KEYBOARD_ICON_F_3 
		BUTTON_TYPE.QUESTS_LOG:
			button_icon.texture = QUESTS_LOG_BUTTON
			short_cut_key_icon.texture = NEW_HUD_KEYBOARD_ICON_F_4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	in_range = true
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1),0.1)
	
	match button_type:
		BUTTON_TYPE.CRAFTING_RECIPE_BOOK:
			description.text = "Recipe Book"
		BUTTON_TYPE.MONSTERPEDIA:
			description.text = "Monsterpedia"
		BUTTON_TYPE.PLAYER_STATS:
			description.text = "Player Stats"
		BUTTON_TYPE.QUESTS_LOG:
			description.text = "Quests Log"
	
	panel_container.show()

func _on_mouse_exited() -> void:
	in_range = false
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0),0.1)
	panel_container.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and in_range:
		CodexManager.open_a_codex_menu.emit(button_type)
