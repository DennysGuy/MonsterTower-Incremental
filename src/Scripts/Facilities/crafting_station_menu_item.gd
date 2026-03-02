class_name CraftingStationMenuItem extends Control

@export var item_icon: TextureRect
@onready var count_label: Label = $CountLabel

@export var stored_item_recipe : CraftingRecipe

#NEED TO ADD A TIER INDICATOR
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stored_item_recipe:
		item_icon.texture = stored_item_recipe.output_item.shop_icon
		count_label.text = str(InventoryManager.calculate_quantity(stored_item_recipe))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			CookingManager.populate_description_panel.emit(stored_item_recipe)
