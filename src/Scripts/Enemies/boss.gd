class_name Boss extends Enemy

@export var left_leg : Sprite2D
func send_to_hit_state() -> void:
	issue_hit_flash(left_leg.material)
	if stored_stun_marker_icon:
		remove_stun_marker()
