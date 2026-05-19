class_name MonsterPreviewCard extends Control


@onready var monster_graphic: TextureRect = $MonsterGraphic
@onready var unlock_progress: ProgressBar = $UnlockProgress
@onready var progress_count: Label = $ProgressCount

var monster_stats : EnemyStats
var in_range : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monster_graphic.texture = monster_stats.idle_animation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and in_range:
		CodexManager.populate_monster_description_panel.emit(monster_stats)


func _on_mouse_entered() -> void:
	in_range = true
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)
	

func _on_mouse_exited() -> void:
	in_range = false
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)
	
