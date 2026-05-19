class_name MonsterPreviewCard extends Control


@onready var monster_graphic: TextureRect = $MonsterGraphic
@onready var unlock_progress: ProgressBar = $UnlockProgress
@onready var progress_count: Label = $ProgressCount
var monster_stats : EnemyStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
