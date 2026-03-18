class_name Player extends Entity

@onready var sword: Sprite2D = $Sprites/Sword
@onready var sprites: Node2D = $Sprites
@onready var timer: Timer = $Timer
@onready var effect: Sprite2D = $Sprites/Effect

@onready var player_sprite: Sprite2D = $Sprites/PlayerSprite
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var coin_purse: Marker2D = $CoinPurse

@onready var mining_area: Area2D = $MiningArea
@onready var ability_cool_down_timer: Timer = $AbilityCoolDownTimer

@onready var hurtbox_collision_shape_2d : CollisionShape2D = $HurtBox/CollisionShape2D
@onready var outfit: Sprite2D = $Sprites/Outfit

@onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D
@onready var dash_attack_collision_shape : CollisionShape2D = $DashAttackHitBox/CollisionShape2D
@onready var dash_attack_hit_box: HitBox = $DashAttackHitBox

@onready var gem_chest_hit_area: GemStoneHitArea = $GemChestHitArea


@onready var ending_area: Area2D = $EndingArea

@onready var can_dash_attack : bool = true
@onready var can_double_jump : bool = true
@onready var can_knock_back : bool = true
@onready var can_spawn_gravestone : bool = true

@onready var sword_soar_hit_box: HitBox = $SwordSoarHitBox

@export var attack_friction : float = 2600.0
@export var max_attack_drift : float = 220.0

var stored_ladder : LadderArea
var stored_enemy : Enemy
var stored_ore_rock : OreRock
var in_ladder_area : bool = false
var is_climbing : bool = false
var prev_input : int
var prev_move_speed : float
var mining_area_position : Vector2
var gem_chest_hit_area_position : Vector2
var hit_box_position : Vector2

var jump_buffer_timer : float = 0.0
var jump_buffer_wait_time : float =0.17

var coyote_timer : float = 0.0
var coyote_wait_time : float = 0.17 

var attack_buffer_timer : float = 0.0
var attack_buffer_wait_time : float = 1.0

var can_attack_cancel: bool = false

var was_on_ledge : bool = true

var apply_gravity : bool = true

var is_silence_attack : bool = false


@export var idle_state : State
@export var jump_state : State
@export var fall_state : State
@export var climb_state : State
@export var swing_pick_axe : State
@export var attack_1 : State
@export var air_attack : State
@export var dash_attack : State

func _ready() -> void:
	super()
	SignalBus.update_sword_texture.connect(set_sword_texture)
	SignalBus.update_player_uniform.connect(set_outfit_texture)
	SignalBus.stop_player.connect(stop_player)
	health = PlayerStats.player_stats["Max Health"]
	mining_area_position = mining_area.position
	gem_chest_hit_area_position = gem_chest_hit_area.position
	hit_box_position = hit_box.position
	dash_attack_hit_box.position = hit_box_position
	disable_gem_chest_hit_area()
	
func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		
	if coyote_timer > 0:
		coyote_timer -= delta

	if attack_buffer_timer > 0:
		attack_buffer_timer -= delta
	

func _unhandled_input(event: InputEvent) -> void:
	super(event)

func set_sword_texture(animation_name : String) -> void:
	sword.texture = SwordGraphics.get_sword_graphic(animation_name)

func set_outfit_texture(animation_name : String) -> void:
	outfit.texture = OutfitGraphics.get_outfit_graphic(animation_name)

func set_pickaxe_texture() -> void:
	sword.texture = SwordGraphics.get_pickaxe_graphic()

func flip_textures(flip : bool) -> void:
	for cur_sprite in sprites.get_children():
		cur_sprite.flip_h = flip
	
	if flip:
		mining_area.position = Vector2(-mining_area_position.x, mining_area_position.y)
		hit_box.position = Vector2(-hit_box_position.x, hit_box_position.y)
		dash_attack_hit_box.position = Vector2(-hit_box_position.x, hit_box_position.y)
		gem_chest_hit_area.position = Vector2(-gem_chest_hit_area_position.x, gem_chest_hit_area_position.y)
	else:
		mining_area.position = mining_area_position
		hit_box.position = hit_box_position
		dash_attack_hit_box.position = hit_box_position
		gem_chest_hit_area.position = gem_chest_hit_area_position
	
func start_invincibility() -> void:
	damageable = false
	blink_effect()

func set_textures_visibility(value : bool) -> void:
	sprite.visible = value

func clear_sprites() -> void:
	animation_player.stop()
	for cur_sprite in sprites.get_children():
		cur_sprite.texture = null
		
func stop_player() -> void:
	velocity = Vector2.ZERO

func set_attack_buffer_timer() -> void:
	attack_buffer_timer = attack_buffer_wait_time

func issue_attack(selected_hit_box : HitBox, multiplier : float = 1.0, ability : Ability = null) -> void:
	var enemies_in_range = selected_hit_box.get_overlapping_areas()
	var overlapping_hits : int = int(PlayerStats.player_stats["Overlapping Hits"])
	var number_of_hits : int = 1
	var rep_delay : float = 0.1
	var incoming_damage : int = 0
	var total_base_attack_damage = int(PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_current_sword().attack_bonus + PlayerStats.get_total_gem_attack_bonus())
	
	var min_damage : int = int(total_base_attack_damage * PlayerStats.player_stats["Accuracy"] + PlayerStats.get_total_gem_bonus("Accuracy Bonus"))
	var max_damage : int = int(total_base_attack_damage)
	var is_crit = check_for_crit()
	if is_crit:
		print("IM CRTTING!")
	if ability:
		overlapping_hits = int(ability.number_of_enemies_hit)
		number_of_hits = int(ability.max_hit_count)
		rep_delay = ability.attack_rep_delay
		min_damage = total_base_attack_damage * (PlayerStats.player_stats["Accuracy"] + PlayerStats.get_total_gem_bonus("Accuracy Bonus"))
		max_damage = total_base_attack_damage  + ability.base_attack
		
	incoming_damage  = int(randi_range(min_damage,max_damage) * multiplier)
	
	if is_crit:
		incoming_damage = int((PlayerStats.player_stats["Crit Damage"] + PlayerStats.get_current_sword().crit_bonus + PlayerStats.get_total_gem_bonus("Crit Damage Bonus")) * incoming_damage)
	
	if PlayerStats.player_stats["Class"] == "Tyro":
		GameManager.attack_enemies(enemies_in_range, overlapping_hits, number_of_hits, self, incoming_damage, is_crit, true, rep_delay)
	else:
		GameManager.attack_enemies(enemies_in_range, overlapping_hits, number_of_hits, self, incoming_damage, is_crit, false, rep_delay)

func issue_sword_attack() -> void:
	issue_attack(hit_box)

func issue_super_attack() -> void:
	var multiplier : float = PlayerStats.get_equipped_ability("Special Attack").attack_damage_modifier
	issue_attack(hit_box, multiplier,PlayerStats.get_equipped_ability("Special Attack"))

func check_for_crit() -> bool:
	var crit_roll : int = randi_range(0,100)
	if crit_roll < int(100 * (PlayerStats.player_stats["Crit Chance"] + PlayerStats.get_current_sword().crit_bonus + PlayerStats.get_total_gem_bonus("Crit Chance Bonus"))):
		return true
	return false

func _on_ladder_detector_area_entered(area: Area2D) -> void:
	in_ladder_area = true
	stored_ladder = area

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

func set_cancel_state_true() -> void:
	can_attack_cancel = true

func enable_gem_chest_hit_area() -> void:
	gem_chest_hit_area.monitorable = true
	gem_chest_hit_area.monitoring = true
	gem_chest_hit_area.get_child(0).disabled = false

func disable_gem_chest_hit_area() -> void:
	gem_chest_hit_area.monitorable = false
	gem_chest_hit_area.monitoring = false
	gem_chest_hit_area.get_child(0).disabled = true

func blink_effect() -> void:
	if not is_inside_tree():
		return 
		
	var invincibility_duration : float = PlayerStats.player_stats["Invincibility Duration"]
	var blink_current_time : float = 0.0
	var blink_wait_time : float = 0.1
	
	while blink_current_time < invincibility_duration:
		if not is_inside_tree():
			return  # Exit cleanly if removed from tree
			
		set_textures_visibility(false)
		
		# Store the timer and check if we're still valid after await
		var blink_timer = get_tree().create_timer(blink_wait_time)
		await blink_timer.timeout
		
		if not is_inside_tree():
			return
			
		blink_current_time += blink_wait_time
		set_textures_visibility(true)
		
		blink_timer = get_tree().create_timer(blink_wait_time)
		await blink_timer.timeout
		
		if not is_inside_tree():
			return
			
		blink_current_time += blink_wait_time
	
	# Final safety check before setting damageable
	if is_inside_tree():
		damageable = true

func send_to_idle_state() -> void:
	state_machine.change_state(idle_state)

func pass_through_floor() -> void:
	set_collision_mask_value(5, false)
	await get_tree().create_timer(0.15).timeout
	set_collision_mask_value(5, true)

func enable_sword_soar_hitbox() -> void:
	sword_soar_hit_box.get_child(0).disabled = false
	sword_soar_hit_box.set_deferred("monitoring", true)
	sword_soar_hit_box.set_deferred("monitorable", true)

func disable_sword_soar_hitbox() -> void:
	sword_soar_hit_box.get_child(0).disabled = true
	sword_soar_hit_box.set_deferred("monitoring", false)
	sword_soar_hit_box.set_deferred("monitorable", false)

func _on_ability_cool_down_timer_timeout() -> void:
	can_dash_attack = true

func _on_invincibility_timer_timeout() -> void:
	damageable = true

func can_issue_ability(ability_name : String) -> bool:
	var selected_ability = PlayerStats.equipped_abilities[ability_name]
	if selected_ability is String:
		selected_ability = load(selected_ability)
	return  AbilityTimers.ability_state[ability_name]["Can Do"] and AbilityTimers.ability_state[ability_name]["Can Do"] and PlayerStats.player_stats["Current MP"] >= selected_ability.mp_cost

func _on_sword_soar_hit_box_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	
	var total_attack_damage : int = PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_current_sword().get_total_attack_bonus()
	var total_accuracy : float = PlayerStats.player_stats["Accuracy"] + PlayerStats.get_current_sword().accuracy_bonus + PlayerStats.get_total_gem_bonus("Accuracy Bonus")
	if parent is Enemy:
		var damage = randf_range(total_attack_damage*total_accuracy, PlayerStats.player_stats["Attack Damage"]) * PlayerStats.equipped_abilities["Double Jump"].attack_damage_modifier
		parent.apply_slow_and_damage(damage,PlayerStats.get_equipped_ability("Double Jump").move_speed_modifier, PlayerStats.get_equipped_ability("Double Jump").slow_wait_time)

func _on_dash_attack_hit_box_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	var total_attack_damage : int = PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_current_sword().get_total_attack_bonus()
	var total_accuracy : float = PlayerStats.player_stats["Accuracy"] + PlayerStats.get_current_sword().accuracy_bonus + PlayerStats.get_total_gem_bonus("Accuracy Bonus")
	if parent is Enemy:
		print(parent)
		if is_silence_attack:
			var equipped_dash_attack : Ability = PlayerStats.get_equipped_ability("Dash Attack")
			var damage : int = randi_range(total_attack_damage * total_accuracy, total_attack_damage) * equipped_dash_attack.attack_damage_modifier
			parent.apply_silenced_and_damage(damage, equipped_dash_attack.slow_wait_time)
		else:
			issue_attack(dash_attack_hit_box)
