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
	create_monster_cards()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func populate_description(monster_stats : EnemyStats) -> void:
	clear_drop_graphics()
	monster_name.text = monster_stats.enemy_name
	biome.text = "Mossy Dungeon"
	monster_graphic.texture = monster_stats.idle_animation
	stats.text = "Level %s\nAttack %s\nDefense %s\nHP %s\n" % [monster_stats.enemy_level, monster_stats.attack, monster_stats.defense, monster_stats.max_health]	
	if monster_stats.novelty_item_drop:
		novelty_drop_graphic.texture = monster_stats.novelty_item_drop.shop_icon
	if monster_stats.cooking_item_drop:
		cooking_drop_graphic.texture = monster_stats.cooking_item_drop.shop_icon
	if monster_stats.crafting_item_drop:
		crafting_drop_graphic.texture = monster_stats.crafting_item_drop.shop_icon
	
	description.text = "I need to add descriptions to the enemy stats."

func create_monster_cards() -> void:
	InventoryManager.clear_grid_container(monster_cards_container)
	for monster in CodexManager.monster_list:
		var card : MonsterPreviewCard = preload("uid://cvu18wqtqtij7").instantiate()
		card.monster_stats = monster
		monster_cards_container.add_child(card)
		await get_tree().create_timer(0.05).timeout

func clear_drop_graphics() -> void:
	cooking_drop_graphic.texture = null
	crafting_drop_graphic.texture = null
	novelty_drop_graphic.texture = null
