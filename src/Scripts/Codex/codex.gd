class_name Codex extends Control

@export var monsterpedia : Monsterpedia
@export var recipe_book : RecipeBook
@export var player_stats : PlayerStatsPage
@export var quests_log : QuestsLog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CodexManager.open_a_codex_menu.connect(show_a_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_recipe_book() -> void:
	CodexManager.show_codex.emit()
	monsterpedia.hide()
	player_stats.hide()
	quests_log.hide()
	recipe_book.show()
	recipe_book.create_dish_recipe_list()
	
	
func show_monsterpedia() -> void:
	CodexManager.show_codex.emit()
	recipe_book.hide()
	player_stats.hide()
	quests_log.hide()
	monsterpedia.show()

func show_stats_page() -> void:
	CodexManager.show_codex.emit()
	recipe_book.hide()
	monsterpedia.hide()
	quests_log.hide()
	player_stats.update_stats_page()
	player_stats.show()

func show_quests_log() -> void:
	CodexManager.show_codex.emit()
	recipe_book.hide()
	monsterpedia.hide()
	player_stats.hide()
	quests_log.show()
	quests_log.initialize_quests_list()
	

func show_a_menu(menu_type : int) -> void:
	match menu_type:
		0:
			show_stats_page()
		1:
			show_recipe_book()
		2:
			show_monsterpedia()
		3:
			show_quests_log()


func _on_button_button_up() -> void:
	CodexManager.hide_codex.emit()
