extends Control

@export var weapon : Sword

@onready var weapon_icon: TextureRect = $WeaponIcon

var in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if weapon:
		weapon_icon.texture = weapon.menu_icon_graphic

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


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and in_range:
		SignalBus.populate_weapon_description_panel.emit(weapon)		
