class_name MonsterPreviewCard extends Control


@export var locked_monster_graphic : TextureRect
@export var monster_graphic: TextureRect
@export var unlock_progress: ProgressBar
@export var progress_count: Label

var monster_stats : EnemyStats
var in_range : bool = false
var unlocked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monster_graphic.texture = monster_stats.idle_animation
	locked_monster_graphic.texture = monster_stats.idle_animation
	if unlocked:
		locked_monster_graphic.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and in_range:
		CodexManager.populate_monster_description_panel.emit(monster_stats)

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

func gray_out_graphic() -> void:
	var shader_material : ShaderMaterial = monster_graphic.material
	shader_material.set_shader_parameter("gray_strength", 1.0)

func show_graphic() -> void:
	var shader_material : ShaderMaterial = monster_graphic.material
	shader_material.set_shader_parameter("gray_strength", 0.0)
