class_name CraftingRecipeListItem extends Label

@export var crafting_recipe : CraftingRecipe
var in_range : bool = false
var unlocked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if unlocked:
		text = "- %s" % crafting_recipe.recipe_name
	else:
		text = "- ???????????"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	if not unlocked:
		return
	
	in_range = true
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)


func _on_mouse_exited() -> void:
	if not unlocked:
		return
		
	in_range = false
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and in_range:
		CodexManager.populate_recipe_description_panel.emit(crafting_recipe)
