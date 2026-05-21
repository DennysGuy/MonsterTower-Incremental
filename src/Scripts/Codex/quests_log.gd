extends Control

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func populate_quest_description_panel(quest : Quest) -> void:
	pass

func _on_main_quests_button_button_up() -> void:
	pass # Replace with function body.


func _on_job_quests_button_button_up() -> void:
	pass # Replace with function body.


func _on_fall_quests_button_button_up() -> void:
	pass # Replace with function body.


func _on_winter_quests_button_button_up() -> void:
	pass # Replace with function body.


func _on_spring_quests_button_button_up() -> void:
	pass # Replace with function body.


func _on_summer_quests_button_button_up() -> void:
	pass # Replace with function body.
