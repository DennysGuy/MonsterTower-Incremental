class_name WeaponTrackerItem extends MarginContainer

@export var weapon : Sword
@onready var weapon_name: RichTextLabel = $PanelContainer2/VBoxContainer/WeaponName
@onready var checklist: VBoxContainer = $PanelContainer2/VBoxContainer/MarginContainer/Checklist

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_name.text = weapon.sword_name
	create_recipe_list()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_recipe_list() -> void:
	for list_item in weapon.recipe.recipe_list:
		var recipe_list_item : WeaponRecipeTrackerListItem = preload("uid://cc50y1doo7l2f").instantiate()
		for item in list_item.keys():
			recipe_list_item.item = item
			recipe_list_item.needed_quantity = list_item[item]
		recipe_list_item.bring_in_task()	
		checklist.add_child(recipe_list_item)
		await get_tree().create_timer(0.2).timeout
			

func clear_check_list() -> void:
	for child in checklist.get_children():
		child.queue_free()
