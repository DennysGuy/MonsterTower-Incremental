class_name Player extends Entity

@onready var sword: Sprite2D = $Sprites/Sword
@onready var sprites: Node2D = $Sprites
@onready var timer: Timer = $Timer

@onready var player_sprite: Sprite2D = $Sprites/PlayerSprite
@onready var invincibility_timer: Timer = $InvincibilityTimer

var stored_ladder : LadderArea
var stored_enemy : Enemy
var in_ladder_area : bool = false
var is_climbing : bool = false
var prev_input : int

func _ready() -> void:
	super()
	health = PlayerStats.player_stats["Max Health"]

func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)

func _unhandled_input(event: InputEvent) -> void:
	super(event)

func set_sword_texture(animation_name : String) -> void:
	sword.texture = SwordGraphics.get_sword_graphic(animation_name)

func flip_textures(flip : bool) -> void:
	for cur_sprite in sprites.get_children():
		cur_sprite.flip_h = flip

func start_invincibility() -> void:
	damageable = false
	blink_effect()

func blink_effect() -> void:
	
	var invincibility_duration : float = 3.0
	var blink_current_time : float = 0.0
	var blink_wait_time : float = 0.1
	
	while blink_current_time < invincibility_duration:
		set_textures_visibility(false)
		await get_tree().create_timer(0.1).timeout
		blink_current_time += blink_wait_time
		set_textures_visibility(true)
		await get_tree().create_timer(0.1).timeout
		blink_current_time += blink_wait_time
	
	damageable = true

func set_textures_visibility(value : bool) -> void:
	sprite.visible = value

func clear_sprites() -> void:
	animation_player.stop()
	for cur_sprite in sprites.get_children():
		cur_sprite.texture = null

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
