class_name Monsterpedia extends Control

@onready var monster_cards_container: GridContainer = $ScrollContainer/MonsterCardsContainer

#Monster Details
@onready var monster_name: Label = $DetailsPanel/MonsterName
@onready var biome: Label = $DetailsPanel/Biome
@onready var monster_graphic: TextureRect = $DetailsPanel/MonsterGraphic

@onready var stats: Label = $DetailsPanel/Stats
@onready var novelty_drop_graphic: TextureRect = $DetailsPanel/NoveltyDropGraphic
@onready var cooking_drop_graphic: TextureRect = $DetailsPanel/CookingDropGraphic
@onready var crafting_drop_graphic: TextureRect = $DetailsPanel/CraftingDropGraphic
@onready var description: RichTextLabel = $DetailsPanel/Description


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CodexManager.populate_monster_description_panel.connect(populate_description)
	CodexManager.update_monster_cards.connect(create_monster_cards)
	SaveManager.load_monster_unlocks_status()
	create_monster_cards()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func populate_description(monster_stats : EnemyStats) -> void:
	clear_drop_graphics()
	monster_name.text = monster_stats.enemy_name
	biome.text = monster_stats.get_biome_name()
	monster_graphic.texture = monster_stats.idle_animation
	stats.text = "Level %s\nAttack %s\nDefense %s\nHP %s\n" % [monster_stats.enemy_level, monster_stats.attack, monster_stats.defense, monster_stats.max_health]	
	if monster_stats.novelty_item_drop:
		novelty_drop_graphic.texture = monster_stats.novelty_item_drop.shop_icon
	if monster_stats.crafting_item_drop:
		crafting_drop_graphic.texture = monster_stats.crafting_item_drop.shop_icon
	
	description.text = "I need to add descriptions to the enemy stats."

func create_monster_cards() -> void:
	InventoryManager.clear_grid_container(monster_cards_container)
	
	for i in range(0,CodexManager.monster_list.size()):
		var card : MonsterPreviewCard = preload("uid://cvu18wqtqtij7").instantiate()
		card.monster_stats = CodexManager.monster_list[i]
		
		if not CodexManager.monster_unlock_status[i]["Unlocked"]:
			card.progress_count.text = "%s/%s" % [CodexManager.monster_unlock_status[i]["Count"], CodexManagerScript.MONSTER_UNLOCK_THRESH_HOLD]
		else:
			card.progress_count.text = ""
			card.unlocked = true
		
		monster_cards_container.add_child(card)
		await get_tree().create_timer(0.05).timeout

func clear_drop_graphics() -> void:
	crafting_drop_graphic.texture = null
	novelty_drop_graphic.texture = null
