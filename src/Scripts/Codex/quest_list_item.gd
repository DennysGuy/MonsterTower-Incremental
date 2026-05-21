class_name QuestListItem extends Label


@export var quest : Quest
var in_range : bool = false
var unlocked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if unlocked:
		text = "- %s" % quest.quest_title
	else:
		text = "- ???????????"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	if not unlocked:
		return
	
	in_range = true
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)

func _on_mouse_exited() -> void:
	if not unlocked:
		return
		
	in_range = false
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and in_range:
		CodexManager.populate_quest_panel.emit(quest)
