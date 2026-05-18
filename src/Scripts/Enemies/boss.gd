class_name Boss extends Enemy

@export var left_leg : Sprite2D
func send_to_hit_state() -> void:
	issue_hit_flash()
	if stored_stun_marker_icon:
		remove_stun_marker()


func hit_flash(state : bool) -> void:
	var shader_material : ShaderMaterial = left_leg.material
	shader_material.set_shader_parameter("active", state)

func issue_hit_flash() -> void:
	hit_flash(true)
	await get_tree().create_timer(0.15).timeout
	hit_flash(false)
