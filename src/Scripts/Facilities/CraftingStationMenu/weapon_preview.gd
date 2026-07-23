class_name WeaponPreviewer extends Node3D

@onready var platter: Node3D = $Platter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	platter.rotation.y += 0.01

func show_weapon(weapon : Sword) -> void:
	if weapon.index == -1:
		return
	
	show_chosen_weapon(weapon)

func show_chosen_weapon(weapon : Sword) -> void:
	for weapon_preview in platter.get_children():
		if weapon.index == weapon_preview.index:
			
			weapon_preview.show()
			var unlocked : bool = SaveManager.get_weapon_unlocked_status(weapon.index)
			if unlocked or PlayerStats.can_craft_weapon() or weapon == PlayerStats.get_current_sword():
				weapon_preview.remove_disabled_material()
		else:
			weapon_preview.hide()
