class_name JobBoardMenu extends Control

@onready var jobs_container: VBoxContainer = $JobsContainer
@onready var quest_title: Label = $QuestTitle
@onready var quest_line_title: Label = $QuestLineTitle
@onready var xp_reward: Label = $XPReward
@onready var currency_reward: Label = $CurrencyReward
@onready var title: Label = $Title
@onready var item_rewards_container: GridContainer = $ItemRewardsContainer
@onready var max_jobs_notice: Label = $MaxJobsNotice

@onready var job_description: RichTextLabel = $JobDescription
@onready var accept_quest_button: Button = $AcceptQuestButton

@export var stored_quest_data : Quest

const JOB_BOARD_INTRO_SCENE = preload("uid://d2dt4jjtg5jil")

const JOB_TURN_IN = preload("uid://crytbgxiowkp4")
const JOB_ACCEPT_JINGLE = preload("uid://dinxl1rs2y55v")

@onready var inventory_full_notice: Label = $InventoryFullNotice

@onready var jobs_accepted_count_label: Label = $JobsAcceptedCountLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_can_move = false
	QuestManager.populate_job_board_description_box.connect(populate_description_panel)
	GameManager.new_jobs_available = false
	clear_description_panel()
	initialize_available_jobs()
	if SaveManager.get_floor_count("Floor 1-3") == 1 and QuestManager.active_quests["Job"].size() == 0:
		Dialogic.start(JOB_BOARD_INTRO_SCENE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		close_out()

func populate_description_panel(quest_data : Quest) -> void:
	inventory_full_notice.hide()
	title.text = quest_data.quest_title
	quest_line_title.text = "- %s -" % quest_data.quest_line
	
	if !quest_data.is_ready_for_turn_in():
		job_description.text = quest_data.description
	else:
		job_description.text = quest_data.turn_in_description
	
	populate_item_rewards_container(quest_data)
	xp_reward.text = "XP Reward: %s" % quest_data.xp_reward
	currency_reward.text = "Currency Reward: %s" % quest_data.currency_reward
	stored_quest_data = quest_data
	set_accept_job_button(quest_data)
	#will also do item reward

func clear_description_panel() -> void:
	inventory_full_notice.hide()
	stored_quest_data = null
	title.text = "Click on a Job to select it."
	quest_line_title.text = ""
	job_description.text = ""
	xp_reward.text = ""
	currency_reward.text = ""
	InventoryManager.clear_grid_container(item_rewards_container)
	accept_quest_button.hide()

func close_out() -> void:
	CutsceneManager.enable_player_functionality()
	SignalBus.hide_tech_tree_canvas_layer.emit()
	QuestManager.initialize_job_quests.emit()
	queue_free()

func update_jobs_accepted_count_label() -> void:
	jobs_accepted_count_label.text = "Jobs In Progress %s/%s" % [QuestManager.active_quests["Job"].size(), PlayerStats.player_stats["Max Jobs Held"]]

func initialize_available_jobs() -> void:
	update_jobs_accepted_count_label()
	clear_job_box()
	for job in QuestManager.quests["Job"]["Introduction"]:
		var selected_job : Quest = QuestManager.get_quest(job)
		if !selected_job.is_locked() and !selected_job.turned_in:
			var job_board_button : JobBoardButton = preload("uid://crntn4mm7ex6s").instantiate()
			job_board_button.quest_data = selected_job
			job_board_button.job_board_button.text = selected_job.quest_title
			jobs_container.add_child(job_board_button)
		
func _on_close_menu_button_button_up() -> void:
	close_out()

func _on_accept_quest_button_button_up() -> void:
	if stored_quest_data.is_available():
		accept_quest()
	elif stored_quest_data.is_in_progress():
		abandon_quest()
	elif stored_quest_data.is_ready_for_turn_in():
		turn_in_quest()

func set_accept_job_button(quest_data : Quest) -> void:
	accept_quest_button.show()
	max_jobs_notice.hide()
	accept_quest_button.disabled = false
	if quest_data.is_available():
		accept_quest_button.text = "Accept"
		if check_for_jobs_held_full():
			accept_quest_button.disabled = true
			max_jobs_notice.show()
		else:
			accept_quest_button.disabled = false
	elif quest_data.is_in_progress():
		accept_quest_button.text = "Disband"
	elif quest_data.is_ready_for_turn_in():
		if stored_quest_data.item_reward.size() > 0:
			var can_turn_in : bool = true
			for deliverable in stored_quest_data.item_reward.keys():
				for i in range(stored_quest_data.item_reward[deliverable]):
					can_turn_in = InventoryManager.check_if_can_add_to_inventory(deliverable, deliverable.get_inventory_name(), "Bag", "Max Bag Stack")
				if !can_turn_in:
					break
			if !can_turn_in:
				accept_quest_button.disabled = true
				inventory_full_notice.show()
			
		accept_quest_button.text = "Turn In"

func add_item_rewards_to_inventory() -> void:
	#add item rewards to inventory -- should have already checked if can add
	for item in stored_quest_data.item_reward.keys():
		for i in range(stored_quest_data.item_reward[item]):
			InventoryManager.add_item(item.get_inventory_name(), item)

func check_for_jobs_held_full() -> bool:
	var jobs_held : int = QuestManager.active_quests["Job"].size()
	var max_jobs_held : int = PlayerStats.player_stats["Max Jobs Held"]
	return jobs_held >= max_jobs_held

func remove_requested_item_from_inventory() -> void:
	for task in stored_quest_data.tasks:
		if task is GatheringTask:
			task.remove_item_from_inventory()

func abandon_quest() -> void:
	#disband the quest
	#update UI to reflect disbanded (back to available state)
	QuestManager.remove_quest_from_active(stored_quest_data, false)
	set_accept_job_button(stored_quest_data)
	for task in stored_quest_data.tasks:
		task.reset_task_state()
		
		initialize_available_jobs()
	update_jobs_accepted_count_label()
	if QuestManager.active_quests["Job"].size() > 0:
		HubManager.hide_facility_notification.emit("Job Requests Board")

func accept_quest() -> void:
	#add quest to active quest
	QuestManager.add_quest_to_active(stored_quest_data)
	#update UI to reflect in progress
	populate_description_panel(stored_quest_data)
	#update the button text to read disband
	set_accept_job_button(stored_quest_data)
	update_jobs_accepted_count_label()
	#send signal to update the UI button hold quest
	PlayerHudSignalBus.update_job_board_button.emit(stored_quest_data)
	play_sfx(JOB_ACCEPT_JINGLE)

func clear_job_box() -> void:
	for button in jobs_container.get_children():
		button.queue_free()

func turn_in_quest() -> void:
	#We need to fix this so that it properly levels up character
	PlayerStats.player_stats["Current XP"] += stored_quest_data.xp_reward
	LevelingManager.check_for_level_up()
	QuestManager.check_general_task_for_completion.emit("Turn In a Job Request")
	TechTreeManager.currency += stored_quest_data.currency_reward
	SaveManager.save_tech_tree_data()
	add_item_rewards_to_inventory()
	remove_requested_item_from_inventory()
	update_jobs_accepted_count_label()
	QuestManager.remove_quest_from_active(stored_quest_data, true)
	clear_description_panel()
	initialize_available_jobs()
	QuestManager.initialize_job_quests.emit()
	SaveManager.save_game()
	play_sfx(JOB_TURN_IN)
	if QuestManager.active_quests["Job"].size() > 0:
		HubManager.hide_facility_notification.emit("Job Requests Board")
	
func populate_item_rewards_container(quest : Quest) -> void:
	
	InventoryManager.clear_grid_container(item_rewards_container)
	if quest.item_reward.size() <= 0:
		return
	
	for item in quest.item_reward.keys():
		var deliverable_list_item : DeliverableItem = preload("uid://c7yuhc01uhis5").instantiate()
		deliverable_list_item.icon.texture = item.shop_icon
		deliverable_list_item.label.text = "x%s" % quest.item_reward[item]
		item_rewards_container.add_child(deliverable_list_item)

func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
