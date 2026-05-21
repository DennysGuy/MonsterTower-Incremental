class_name QuestsLog extends Control

@onready var quest_title: Label = $DescriptionPanel/QuestTitle
@onready var chapter_relation: Label = $DescriptionPanel/ChapterRelation
@onready var quest_line: Label = $DescriptionPanel/QuestLine
@onready var log_description: RichTextLabel = $DescriptionPanel/LogDescription
@onready var deliverables: Label = $DescriptionPanel/Deliverables
@onready var xp_reward: Label = $DescriptionPanel/XPReward
@onready var currency_reward: Label = $DescriptionPanel/CurrencyReward
@onready var status: Label = $DescriptionPanel/Status
@onready var deliverables_container: GridContainer = $DescriptionPanel/DeliverablesContainer

@onready var quest_list_container: GridContainer = $ScrollContainer/QuestListContainer

@onready var main_quests_button: Button = $HBoxContainer2/MainQuestsButton
@onready var fall_quests_button: Button = $HBoxContainer2/FallQuestsButton
@onready var winter_quests_button: Button = $HBoxContainer2/WinterQuestsButton
@onready var spring_quests_button: Button = $HBoxContainer2/SpringQuestsButton
@onready var summer_quests_button: Button = $HBoxContainer2/SummerQuestsButton

@onready var intro_log_button: Button = $DescriptionPanel/HBoxContainer3/IntroLogButton
@onready var outro_log_button: Button = $DescriptionPanel/HBoxContainer3/OutroLogButton

var stored_quest : Quest
var stored_quest_type : String = "Main"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CodexManager.populate_quest_panel.connect(populate_quest_description_panel)
	populate_quests_list(stored_quest_type, "Introduction")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func populate_quest_description_panel(quest : Quest) -> void:
	if quest.get_status_title() == "COMPLETED":
		outro_log_button.disabled = false
	else:
		outro_log_button.disabled = true
	
	intro_log_button.disabled = false
	
	stored_quest = quest
	quest_title.text = quest.quest_title
	chapter_relation.text = quest.chapter_relation
	quest_line.text = quest.quest_line
	log_description.text = quest.description
	populate_deliverable_container(quest)
	xp_reward.text = "XP Reward: %s" % quest.xp_reward
	currency_reward.text = "Currency Reward: %s" % quest.currency_reward
	status.text = quest.get_status_title()
	
func _on_main_quests_button_button_up() -> void:
	stored_quest_type = "Main"
	populate_quests_list(stored_quest_type, "Introduction")

func _on_job_quests_button_button_up() -> void:
	stored_quest_type = "Job"
	populate_quests_list(stored_quest_type, "Introduction")

func _on_fall_quests_button_button_up() -> void:
	populate_quests_list(stored_quest_type, "Fall")

func _on_winter_quests_button_button_up() -> void:
	populate_quests_list(stored_quest_type, "Winter")

func _on_spring_quests_button_button_up() -> void:
	populate_quests_list(stored_quest_type, "Spring")

func _on_summer_quests_button_button_up() -> void:
	populate_quests_list(stored_quest_type, "Summer")

func populate_quests_list(quest_type: String, chapter : String) -> void:
	InventoryManager.clear_grid_container(quest_list_container)
	var selected_quest_list : Dictionary = QuestManager.quests[quest_type][chapter]
	for quest in selected_quest_list.keys():
		var quest_list_item : QuestListItem = preload("uid://50wwth2q8u8b").instantiate()
		quest_list_item.quest = selected_quest_list[quest]
		if selected_quest_list[quest].get_status_title() == "LOCKED":
			quest_list_item.unlocked = false
		else:
			quest_list_item.unlocked = true
			
		quest_list_container.add_child(quest_list_item)

func populate_deliverable_container(quest : Quest) -> void:
	InventoryManager.clear_grid_container(deliverables_container)
	if quest.item_reward.size() <= 0:
		return
	
	for item in quest.item_reward.keys():
		var deliverable_list_item : DeliverableItem = preload("uid://c7yuhc01uhis5").instantiate()
		deliverable_list_item.icon.texture = item.shop_icon
		deliverable_list_item.label.text = "x%s" % quest.item_reward[item]
		deliverables_container.add_child(deliverable_list_item)

func _on_intro_log_button_button_up() -> void:
	if not stored_quest:
		return
	
	log_description.text = stored_quest.description

func _on_outro_log_button_button_up() -> void:
	if not stored_quest:
		return
	
	log_description.text = stored_quest.turn_in_description


func initialize_quests_list() -> void:
	populate_quests_list(stored_quest_type, "Introduction")
