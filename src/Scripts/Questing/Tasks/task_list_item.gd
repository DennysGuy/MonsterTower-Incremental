class_name TaskListItem extends Control

@export  var task_data : Task
@export var label: RichTextLabel
@export var icon: TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const TASK_COMPLETED = preload("uid://u4g1ea4v5nkg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QuestManager.play_task_completion_animation.connect(play_completion_animation)
	QuestManager.play_undo_task_completion_animation.connect(undo_completion)
	QuestManager.update_task_list_item.connect(update_task_label)
	if task_data and task_data.completed:
		play_completion_animation(task_data.task_id)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_completion_animation(task_id : int) -> void:
	if task_data.task_id != task_id:
		return
	play_sfx(TASK_COMPLETED)
	animation_player.play("Complete")
	await animation_player.animation_finished
	QuestManager.check_for_quest_completion.emit()	

func undo_completion(task_id : int) -> void:
	if task_data.task_id != task_id:
		return
	animation_player.play("UndoCompletion")
	#we'll need to issue a signal that rebuilds the quest tasks

func update_task_label(task_id : int) -> void:
	if task_data.task_id != task_id:
		return
	
	if task_data is GatheringTask:
		label.text = "Gather %s: %s/%s" % [task_data.item_to_gather.item_name, task_data.current_count, task_data.number_to_get]
	elif task_data is HuntingTask:
		label.text = "Hunt %s: %s/%s" % [task_data.enemy_to_hunt.enemy_name, task_data.current_count, task_data.number_to_get]		
	elif task_data is LevelingTask:
		label.text = "Reach Level %s" % task_data.level_needed
	elif task_data is FacilityUnlockTask or task_data is NodeUnlockTask:
		label.text = "Unlock %s" % task_data.facility_name
	elif task_data is MapUnlockTask:
		label.text = "Reach %s" % task_data.map_name


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
