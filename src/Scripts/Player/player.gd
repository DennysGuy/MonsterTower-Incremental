class_name Player extends Entity

@onready var sword: Sprite2D = $Sprites/Sword
@onready var sprites: Node2D = $Sprites
@onready var timer: Timer = $Timer

@onready var player_sprite: Sprite2D = $Sprites/PlayerSprite

var stored_ladder : LadderArea
var in_ladder_area : bool = false
var is_climbing : bool = false
var prev_input : int

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)

func _unhandled_input(event: InputEvent) -> void:
	super(event)

func set_sword_texture(animation_name : String) -> void:
	sword.texture = SwordGraphics.get_sword_graphic(animation_name)

func flip_textures(flip : bool) -> void:
	for sprite in sprites.get_children():
		sprite.flip_h = flip

func issue_sword_attack() -> void:
	var enemies_in_range = hit_box.get_overlapping_areas()
	var overlapping_hits : int = int(PlayerStats.player_stats["Overlapping Hits"])
	var min_damage : int = int(PlayerStats.player_stats["Attack Damage"] * PlayerStats.player_stats["Accuracy"])
	var max_damage : int = int(PlayerStats.player_stats["Attack Damage"])
	var is_crit = check_for_crit()
	var incoming_damage : int = randi_range(min_damage,max_damage)
	
	if is_crit:
		incoming_damage = int(PlayerStats.player_stats["Crit Damage"] * incoming_damage)

	GameManager.attack_enemies(enemies_in_range, overlapping_hits, self, incoming_damage, is_crit)

func check_for_crit() -> bool:
	var crit_roll : int = randi_range(0,100)
	if crit_roll < int(100 * PlayerStats.player_stats["Crit Chance"]):
		return true
	
	return false


func _on_ladder_detector_area_entered(area: Area2D) -> void:
	in_ladder_area = true
	stored_ladder = area
	if in_ladder_area:
		print("were in ladder area and the stored ladder is %s " % [stored_ladder])


func _on_ladder_detector_area_exited(area: Area2D) -> void:
	in_ladder_area = false
	stored_ladder = null
	if !in_ladder_area:
		print("were have left ladder area and the stored ladder is %s " % [stored_ladder])
