class_name JobBoard extends Node2D

var player_in_range : bool = false
@onready var notice: Label = $Notice
@onready var jobs_available_notice: Label = $JobsAvailableNotice
@onready var notice_icon: Sprite2D = $NoticeIcon
@onready var notice_icon_2: Sprite2D = $NoticeIcon2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mapping : String = GameManager.get_control_mapping("interact")
	notice.text = "Press %s to access Job Board" % mapping
	if GameManager.new_jobs_available:
		notice_icon.show()
		notice_icon_2.show()
		jobs_available_notice.show()
		HubManager.show_facility_notification.emit("Job Requests Board")
	
	await get_tree().process_frame
	
	if QuestManager.check_for_available_job():
		HubManager.show_facility_notification.emit("Job Requests Board")
		
	show_notice_on_turn_in()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in_range:
		CutsceneManager.disable_player_functionality()
		PlayerHudSignalBus.spawn_job_board_menu.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		notice.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		notice.hide()

func show_notice_on_turn_in() -> void:
	for quest_name in QuestManager.active_quests["Job"]:
		if QuestManager.get_quest(quest_name).is_ready_for_turn_in():
			notice_icon.show()
			notice_icon_2.show()
			HubManager.show_facility_notification.emit("Job Requests Board")
