class_name CraftingStationMenuItem extends Control

@export var item_icon: TextureRect
@onready var count_label: Label = $CountLabel

@export var stored_item_recipe : CraftingRecipe
@onready var star_tier_h_box: HBoxContainer = $StarTierHBox

#NEED TO ADD A TIER INDICATOR
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stored_item_recipe:
		populate_tier_bar(stored_item_recipe.recipe_tier)
		item_icon.texture = stored_item_recipe.output_item.shop_icon
		count_label.text = str(InventoryManager.calculate_quantity(stored_item_recipe))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			CookingManager.populate_description_panel.emit(stored_item_recipe)


func populate_tier_bar(num : int) -> void:
	clear_tier_bar()
	for i in range(num):
		var star : TextureRect = preload("uid://cjp8ifo5avha3").instantiate()
		star_tier_h_box.add_child(star)

func clear_tier_bar() -> void:
	if star_tier_h_box.get_children().is_empty():
		return
	
	for child in star_tier_h_box.get_children():
		child.queue_free()
