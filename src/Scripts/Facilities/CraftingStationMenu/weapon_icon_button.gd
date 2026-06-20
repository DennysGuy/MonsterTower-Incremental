class_name WeaponIconButton extends Control

@export var weapon : Sword

@onready var weapon_icon: TextureRect = $WeaponIcon
@onready var tracked_icon: TextureRect = $TrackedIcon

var in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.disable_tracked_icon.connect(hide_tracked_icon)
	SignalBus.show_tracked_icon.connect(show_tracked_icon)
	SignalBus.update_held_weapon.connect(update_stored_weapon)
	if weapon:
		weapon_icon.texture = weapon.menu_icon_graphic
		weapon.unlocked = SaveManager.get_weapon_unlocked_status(weapon.index)
		weapon.is_tracked = SaveManager.get_weapon_tracked_status(weapon.index)
		if weapon.unlocked:
			weapon_icon.texture = weapon.menu_icon_graphic
		else:
			weapon_icon.texture = weapon.menu_icon_disabled_graphic
			if weapon.is_tracked:
				tracked_icon.show()
			else:
				tracked_icon.hide()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)
	in_range = true

func _on_mouse_exited() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)
	in_range = false

func hide_tracked_icon(index : int) -> void:
	if !weapon:
		return
	if weapon.index != index:
		return
	tracked_icon.hide()

func show_tracked_icon(index : int) -> void:
	if !weapon:
		return
	if weapon.index != index:
		return
	tracked_icon.show()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		SignalBus.populate_weapon_description_panel.emit(weapon)		

func update_stored_weapon(new_weapon : Sword) -> void:
	if new_weapon.index != weapon.index:
		return
	
	weapon = new_weapon
