class_name Player extends Entity

@onready var sword: Sprite2D = $Sprites/Sword
@onready var sprites: Node2D = $Sprites
@onready var timer: Timer = $Timer
@onready var effect: Sprite2D = $Sprites/Effect

@onready var player_sprite: Sprite2D = $Sprites/PlayerSprite
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var coin_purse: Marker2D = $CoinPurse

@onready var mining_area: Area2D = $MiningArea


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var stored_ladder : LadderArea
var stored_enemy : Enemy
var stored_ore_rock : OreRock
var in_ladder_area : bool = false
var is_climbing : bool = false
var prev_input : int

var mining_area_position : Vector2

func _ready() -> void:
	super()
	SignalBus.update_sword_texture.connect(set_sword_texture)
	health = PlayerStats.player_stats["Max Health"]
	mining_area_position = mining_area.position
	
func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)

func _unhandled_input(event: InputEvent) -> void:
	super(event)

func set_sword_texture(animation_name : String) -> void:
	sword.texture = SwordGraphics.get_sword_graphic(animation_name)

func set_pickaxe_texture() -> void:
	sword.texture = SwordGraphics.get_pickaxe_graphic()

func flip_textures(flip : bool) -> void:
	for cur_sprite in sprites.get_children():
		cur_sprite.flip_h = flip
	
	if flip:
		mining_area.position = Vector2(-mining_area_position.x, mining_area_position.y)
	else:
		mining_area.position = mining_area_position
	
	
func start_invincibility() -> void:
	damageable = false
	blink_effect()

func blink_effect() -> void:
	if not is_inside_tree():
		return 
		
	var invincibility_duration : float = 3.0
	var blink_current_time : float = 0.0
	var blink_wait_time : float = 0.1
	
	while blink_current_time < invincibility_duration and is_inside_tree():
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
	var base_damage : int = int(PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_sword(PlayerStats.player_stats["Equipped Sword"]).attack_bonus)
	var min_damage : int = int(base_damage * PlayerStats.player_stats["Accuracy"])
	var max_damage : int = int(base_damage)
	var is_crit = check_for_crit()
	var incoming_damage : int = randi_range(min_damage,max_damage)
	
	if is_crit:
		incoming_damage = int((PlayerStats.player_stats["Crit Damage"] + PlayerStats.get_sword(PlayerStats.player_stats["Equipped Sword"]).crit_bonus) * incoming_damage)

	GameManager.attack_enemies(enemies_in_range, overlapping_hits, self, incoming_damage, is_crit)

func check_for_crit() -> bool:
	var crit_roll : int = randi_range(0,100)
	if crit_roll < int(100 * (PlayerStats.player_stats["Crit Chance"] + PlayerStats.get_sword(PlayerStats.player_stats["Equipped Sword"]).crit_bonus)):
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

func attack_ore_rock() -> void:
	if stored_ore_rock:
		SignalBus.shake_camera.emit(0.3)
		var stats_damage : int = int(PlayerStats.player_stats["Mining Damage"])
		var random_hit : int = randi_range(int(stats_damage * 0.8), stats_damage)
		stored_ore_rock.damage_ore_rock(random_hit)

func clear_effect_texture() -> void:
	effect.texture = null

func pass_through_floor() -> void:
	set_collision_mask_value(5, false)
	await get_tree().create_timer(0.15).timeout
	set_collision_mask_value(5, true)
