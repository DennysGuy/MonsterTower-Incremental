class_name MenuRecipePanel extends Panel

@export var recipe : CraftingRecipe
@export var recipe_icon : TextureRect
@export var can_make : Label
@export var title : Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_select_button_button_up() -> void:
	CookingManager.populate_description_panel.emit(recipe)
