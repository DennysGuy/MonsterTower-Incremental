class_name JobBoardMenu extends Control

@onready var jobs_container: VBoxContainer = $JobsContainer
@onready var quest_title: Label = $QuestTitle
@onready var quest_line_title: Label = $QuestLineTitle
@onready var xp_reward: Label = $XPReward
@onready var currency_reward: Label = $CurrencyReward
@onready var title: Label = $Title

@onready var job_description: RichTextLabel = $JobDescription
@onready var accept_quest_button: Button = $AcceptQuestButton

@export var stored_quest_data : Quest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_can_move = false
	QuestManager.populate_job_board_description_box.connect(populate_description_panel)
	initialize_available_jobs()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

func populate_description_panel(quest_data : Quest) -> void:
	title.text = quest_data.quest_title
	quest_line_title.text = "- %s -" % quest_data.quest_line
	job_description.text = quest_data.description
	xp_reward.text = "XP Reward: %s" % quest_data.xp_reward
	currency_reward.text = "Currency Reward: %s" % quest_data.currency_reward
	stored_quest_data = quest_data
	set_accept_job_button(quest_data)
	#will also do item reward

func close_out() -> void:
	GameManager.player_can_move = true
	GameManager.can_open_bag = true
	GameManager.can_open_tower_map = true
	SignalBus.hide_tech_tree_canvas_layer.emit()
	queue_free()

func initialize_available_jobs() -> void:
	for job in QuestManager.quests["Job"]["Introduction"]:
		var selected_job : Quest = QuestManager.get_quest(job)
		if !selected_job.is_completed():
			var job_board_button : JobBoardButton = preload("uid://crntn4mm7ex6s").instantiate()
			job_board_button.quest_data = selected_job
			job_board_button.job_board_button.text = selected_job.quest_title
			jobs_container.add_child(job_board_button)

func _on_close_menu_button_button_up() -> void:
	close_out()


func _on_accept_quest_button_button_up() -> void:
	if stored_quest_data.is_available():
		#add quest to active quest
		QuestManager.add_quest_to_active(stored_quest_data)
		#update UI to reflect in progress
		populate_description_panel(stored_quest_data)
		#update the button text to read disband
		set_accept_job_button(stored_quest_data)
		#send signal to update the UI button hold quest
		PlayerHudSignalBus.update_job_board_button.emit(stored_quest_data)


	elif stored_quest_data.is_in_progress():
		#disband the quest
		#update UI to reflect disbanded (back to available state)
		pass
	elif stored_quest_data.is_ready_for_turn_in():
		#turn in quest -> set to completed, remove from available quest list
		#clear quest data
		#clear details
		#unlock next quest in sequence if possible
		pass

func set_accept_job_button(quest_data : Quest) -> void:
	if quest_data.is_available():
		accept_quest_button.text = "Accept"
	elif quest_data.is_in_progress():
		accept_quest_button.text = "Disband"
	elif quest_data.is_ready_for_turn_in():
		accept_quest_button.text = "Turn In"
