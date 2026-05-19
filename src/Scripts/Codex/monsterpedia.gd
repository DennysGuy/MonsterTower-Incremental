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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
