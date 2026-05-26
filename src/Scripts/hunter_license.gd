class_name HunterLicense extends Node3D

@onready var mesh: MeshInstance3D = $blockbench_export/mesh

const TIER_0_MATERIAL = preload("uid://c2xecr8ox8clr")
const TIER_1_MATERIAL = preload("uid://btf4xja285u5m")
const TIER_2_MATERIAL = preload("uid://b1ygd70gc1scq")
const TIER_3_MATERIAL = preload("uid://co0w3fwtinksf")
const TIER_4_MATERIAL = preload("uid://jpthyrq67kg")
const TIER_5_MATERIAL = preload("uid://cpyqrs4puvrp1")
const TIER_6_MATERIAL = preload("uid://bhucdn3gu6pq1")
const TIER_7_MATERIAL = preload("uid://ce42err2qwsc0")
const TIER_8_MATERIAL = preload("uid://4bsls6cd7ohk")
const TIER_9_MATERIAL = preload("uid://be0eet7d4hrwp")
const TIER_10_MATERIAL = preload("uid://bmrrk88u70b30")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_texture()
	animation_player.play("UpgradeLicense")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_texture() -> void:
	
	match TechTreeManager.current_prestige:
		0:
			mesh.set_surface_override_material(0, TIER_0_MATERIAL)
		1:
			mesh.set_surface_override_material(0, TIER_1_MATERIAL)
		2:
			mesh.set_surface_override_material(0, TIER_2_MATERIAL)
		3:
			mesh.set_surface_override_material(0, TIER_3_MATERIAL)
		4:
			mesh.set_surface_override_material(0, TIER_4_MATERIAL)
		5:
			mesh.set_surface_override_material(0, TIER_5_MATERIAL)
		6:
			mesh.set_surface_override_material(0, TIER_6_MATERIAL)
		7:
			mesh.set_surface_override_material(0, TIER_7_MATERIAL)
		8:
			mesh.set_surface_override_material(0, TIER_8_MATERIAL)
		9:
			mesh.set_surface_override_material(0, TIER_9_MATERIAL)
		10:
			mesh.set_surface_override_material(0, TIER_10_MATERIAL)

func update_card() -> void:
	SignalBus.flash_screen.emit()
	await get_tree().create_timer(0.5).timeout
	TechTreeManager.upgrade_hunter_license()
	change_texture()
