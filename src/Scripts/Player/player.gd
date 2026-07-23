class_name Player extends Entity

@onready var sword: Sprite2D = $Sprites/Sword
@onready var sprites: Node2D = $Sprites
@onready var timer: Timer = $Timer
@onready var effect: Sprite2D = $Sprites/Effect

@onready var player_sprite: Sprite2D = $Sprites/PlayerSprite
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var coin_purse: Marker2D = $CoinPurse
@onready var knock_back_timer: Timer = $KnockBackTimer

@onready var mining_area: Area2D = $MiningArea
@onready var ability_cool_down_timer: Timer = $AbilityCoolDownTimer

@onready var hurtbox_collision_shape_2d : CollisionShape2D = $HurtBox/CollisionShape2D
@onready var outfit: Sprite2D = $Sprites/Outfit

@onready var collision_shape_2d : CollisionShape2D = $CollisionShape2D
@onready var dash_attack_collision_shape : CollisionShape2D = $DashAttackHitBox/CollisionShape2D
@onready var dash_attack_hit_box: HitBox = $DashAttackHitBox

@onready var gem_chest_hit_area: GemStoneHitArea = $GemChestHitArea

@onready var item_pick_up_area: Area2D = $ItemPickUpArea

@onready var ending_area: Area2D = $EndingArea

@onready var can_dash_attack : bool = true
@onready var can_double_jump : bool = true
@onready var can_knock_back : bool = true
@onready var can_spawn_gravestone : bool = true
@onready var knocked_back : bool = false
@onready var ladder_top_position_detector: Marker2D = $LadderTopPositionDetector

@onready var sword_soar_hit_box: HitBox = $SwordSoarHitBox

@export var attack_friction : float = 2600.0
@export var max_attack_drift : float = 220.0
@onready var holder: Marker2D = $Holder

@onready var junk_detector: Area2D = $JunkDetector

@onready var ability_hit_box: Area2D = $AbilityHitBox
const PICKAXE_SWING_STRIKE = preload("uid://djgxyv4i65ob4")
const DENIED = preload("uid://672acnsycbfo")

var held_key : BossDoorKey

var stored_ladder : LadderArea
var stored_enemy : Enemy
var stored_ore_rock : OreRock
var in_ladder_area : bool = false
var is_climbing : bool = false
var in_mining_area : bool = false
var prev_input : int
var prev_move_speed : float
var mining_area_position : Vector2
var gem_chest_hit_area_position : Vector2
var hit_box_position : Vector2
var holder_position : Vector2

var jump_buffer_timer : float = 0.0
var jump_buffer_wait_time : float =0.17

var grab_ladder_buffer_timer : float = 0.0
var grab_ladder_buffer_wait_time : float = 0.2

var coyote_timer : float = 0.0
var coyote_wait_time : float = 0.17 

var attack_buffer_timer : float = 0.0
var attack_buffer_wait_time : float = 1.0

var combat_ability_1_timer : float = 0.0
var combat_ability_1_wait_time : float = 0.4

var combat_ability_2_timer : float = 0.0
var combat_ability_2_wait_time : float = 0.4

var combat_ability_3_timer : float = 0.0
var combat_ability_3_wait_time : float = 0.4

var combat_ability_4_timer : float = 0.0
var combat_ability_4_wait_time : float = 0.4

var dash_cancel_time_frame : float = 0.0
var dash_cancel_wait_time : float = 0.25

var double_jump_buffer : float = 0.0
var double_jump_buffer_wait_time : float = 0.1

var early_jump_cancel_wait_time : float = 0.15
var early_jump_cancel_timer : float = 0.0

var can_attack_cancel: bool = false

var was_on_ledge : bool = true

var is_silence_attack : bool = false

@export var idle_state : State
@export var jump_state : State
@export var fall_state : State
@export var climb_state : State
@export var swing_pick_axe : State
@export var attack_1 : State
@export var air_attack : State
@export var dash_attack : State

const DOUB_CLEAVE_NEW = preload("uid://bea00177gkvyb")

var junk_picked_up : Array[JunkInteractable] = []

func _ready() -> void:
	super()
	SignalBus.update_sword_texture.connect(set_sword_texture)
	SignalBus.update_player_uniform.connect(set_outfit_texture)
	SignalBus.stop_player.connect(stop_player)
	SignalBus.play_level_up_visual.connect(play_levelup_visual)
	SignalBus.novelty_invention_sold.connect(rebuild_junk_held_offsets)
	health = PlayerStats.player_stats["Max Health"]
	mining_area_position = mining_area.position
	gem_chest_hit_area_position = gem_chest_hit_area.position
	hit_box_position = hit_box.position
	dash_attack_hit_box.position = hit_box_position
	holder_position = holder.position
	disable_gem_chest_hit_area()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pan_cam_up") and !GameManager.auto_pick_up_enabled:
		pick_up_items()
		await get_tree().create_timer(1.0).timeout
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		
	if coyote_timer > 0:
		coyote_timer -= delta

	if attack_buffer_timer > 0:
		attack_buffer_timer -= delta
	
	if grab_ladder_buffer_timer > 0:
		grab_ladder_buffer_timer -= delta
	
	if dash_cancel_time_frame > 0:
		dash_cancel_time_frame -= delta
	
	if double_jump_buffer > 0:
		double_jump_buffer -= delta
	
	if early_jump_cancel_timer > 0:
		early_jump_cancel_timer -= delta
	
	knock_back_player()
	
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
		holder.position = Vector2(-holder_position.x, holder_position.y)
	else:
		mining_area.position = mining_area_position
		hit_box.position = hit_box_position
		dash_attack_hit_box.position = hit_box_position
		gem_chest_hit_area.position = gem_chest_hit_area_position
		holder.position = holder_position
	
func set_textures_visibility(value : bool) -> void:
	sprite.visible = value

func clear_sprites() -> void:
	animation_player.stop()
	for cur_sprite in sprites.get_children():
		cur_sprite.texture = null
		
func stop_player() -> void:
	velocity = Vector2.ZERO

#override parent function
func send_to_hit_state() -> void:
	start_knock_back()

func set_attack_buffer_timer() -> void:
	attack_buffer_timer = attack_buffer_wait_time

func issue_attack(selected_hit_box : Area2D, multiplier : float = 1.0, ability : Ability = null, hits : int = 1, o_hits_bonus : int = 0) -> void:
	var enemies_in_range = selected_hit_box.get_overlapping_areas()
	var overlapping_hits : int = int(PlayerStats.player_stats["Overlapping Hits"] + PlayerStats.get_current_sword().get_total_multi_enemies_bonus()) + o_hits_bonus
	var number_of_hits : int = hits
	var rep_delay : float = 0.1
	var incoming_damage : int = 0
	var total_base_attack_damage = int(PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_current_sword().attack_bonus + PlayerStats.get_total_gem_attack_bonus())
	
	var min_damage : int = int(total_base_attack_damage * PlayerStats.player_stats["Accuracy"] + PlayerStats.get_total_gem_bonus("Accuracy Bonus"))
	var max_damage : int = int(total_base_attack_damage)
	var is_crit = check_for_crit()
	
	if ability:
		overlapping_hits = int(ability.number_of_enemies_hit + PlayerStats.get_current_sword().get_total_multi_enemies_bonus())
		number_of_hits = int(ability.max_hit_count)
		rep_delay = ability.attack_rep_delay
		min_damage = total_base_attack_damage * (PlayerStats.player_stats["Accuracy"] + PlayerStats.get_total_gem_bonus("Accuracy Bonus"))
		max_damage = total_base_attack_damage  + ability.base_attack
		
	incoming_damage  = int(randi_range(min_damage,max_damage) * multiplier)
	
	if is_crit:
		incoming_damage = int((PlayerStats.player_stats["Crit Damage"] + PlayerStats.get_current_sword().crit_bonus + PlayerStats.get_total_gem_bonus("Crit Damage Bonus")) * incoming_damage)
	
	print(PlayerStats.get_current_sword().knock_back_bonus)
	if PlayerStats.player_stats["Class"] == "Tyro":
		GameManager.attack_enemies(enemies_in_range, overlapping_hits, number_of_hits, self, incoming_damage, is_crit, true, rep_delay,ability, PlayerStats.get_current_sword().knock_back_bonus)
	else:
		GameManager.attack_enemies(enemies_in_range, overlapping_hits, number_of_hits, self, incoming_damage, is_crit, false, rep_delay,ability, PlayerStats.get_current_sword().knock_back_bonus)

func issue_sword_attack() -> void:
	issue_attack(hit_box)

func issue_air_attack() -> void:
	issue_attack(hit_box,1.0,null,1,1)

func issue_super_attack() -> void:
	var multiplier : float = PlayerStats.get_equipped_ability("Combat Ability 4").attack_damage_modifier
	issue_attack(hit_box, multiplier,PlayerStats.get_equipped_ability("Combat Ability 4"))

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

func attack_ore_rock() -> void:
	var ore_rock : Array[Area2D] = mining_area.get_overlapping_areas()

	for ore_rock_area in ore_rock:
		var single_ore_rock : OreRock = ore_rock_area.get_parent()
		SignalBus.shake_camera.emit(1.0)
		var stats_damage : int = int(PlayerStats.player_stats["Mining Damage"])
		var random_hit : int = randi_range(int(stats_damage * 0.8), stats_damage)
		GameManager.remaining_bolt_chain_links = PlayerStats.player_stats["Mining Bolt Links"]
		single_ore_rock.damage_ore_rock(random_hit)
		play_sfx(PICKAXE_SWING_STRIKE,1.0)
		await get_tree().create_timer(0.25).timeout

func issue_double_cleave() -> void:
	var y_pos : int = -30
	for i in range(0,2):
		var cleave_sword : DoubleCleaveAttack = preload("uid://cmn8av6jpy31").instantiate()
		if player_sprite.flip_h:
			cleave_sword.flip_direction()
		cleave_sword.player = self
		cleave_sword.global_position = global_position + Vector2(20 * cleave_sword.move_dir, y_pos)
		y_pos += 15
		SignalBus.shake_camera.emit(1.0)
		play_sfx(DOUB_CLEAVE_NEW)
		get_parent().add_child(cleave_sword)
		if is_inside_tree():
			await get_tree().create_timer(0.15).timeout
		

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

var blink_token: int = 0

func start_invincibility() -> void:
	blink_token += 1
	
	invincibility_timer.stop()
	invincibility_timer.wait_time = PlayerStats.player_stats["Invincibility Duration"]
	invincibility_timer.start()
	blink_effect()

func blink_effect() -> void:
	if !is_inside_tree():
		return
	
	blink_token += 1
	var my_token := blink_token
	
	var invincibility_duration: float = PlayerStats.player_stats["Invincibility Duration"]
	var blink_current_time: float = 0.0
	var blink_wait_time: float = 0.1
	
	while blink_current_time < invincibility_duration:
		if !is_inside_tree() or my_token != blink_token:
			return
		
		set_textures_visibility(false)
		await get_tree().create_timer(blink_wait_time).timeout
		
		if !is_inside_tree() or my_token != blink_token:
			return
		
		blink_current_time += blink_wait_time
		
		if blink_current_time >= invincibility_duration:
			break
		
		set_textures_visibility(true)
		await get_tree().create_timer(blink_wait_time).timeout
		
		if !is_inside_tree() or my_token != blink_token:
			return
		
		blink_current_time += blink_wait_time
	
	if !is_inside_tree() or my_token != blink_token:
		return
	
	set_textures_visibility(true)
		#SignalBus.enable_enemy_hit_box.emit()

func send_to_idle_state() -> void:
	state_machine.change_state(idle_state)
	
func send_to_climb_state() -> void:
	state_machine.change_state(climb_state)

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
	if !is_inside_tree():
		return
	
	set_textures_visibility(true)
	damageable = true
	enable_hurt_box()

func can_issue_ability(ability_name : String) -> bool:
	var selected_ability = PlayerStats.equipped_abilities[ability_name]
	if selected_ability is String:
		selected_ability = load(selected_ability)
	return  AbilityTimers.ability_state[ability_name]["Can Do"] and GameManager.current_player_mp >= selected_ability.mp_cost

func _on_sword_soar_hit_box_area_entered(area: Area2D) -> void:
	#var parent = area.get_parent()
	#
	#var total_attack_damage : int = PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_current_sword().get_total_attack_bonus()
	#var total_accuracy : float = PlayerStats.player_stats["Accuracy"] + PlayerStats.get_current_sword().accuracy_bonus + PlayerStats.get_total_gem_bonus("Accuracy Bonus")
	#if parent is Enemy:
		#var damage = randf_range(total_attack_damage*total_accuracy, PlayerStats.player_stats["Attack Damage"]) * PlayerStats.equipped_abilities["Double Jump"].attack_damage_modifier
		#parent.apply_slow_and_damage(damage,PlayerStats.get_equipped_ability("Double Jump").move_speed_modifier, PlayerStats.get_equipped_ability("Double Jump").slow_wait_time)
	pass

func _on_dash_attack_hit_box_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	##var total_attack_damage : int = PlayerStats.player_stats["Attack Damage"] + PlayerStats.get_current_sword().get_total_attack_bonus()
	##var total_accuracy : float = PlayerStats.player_stats["Accuracy"] + PlayerStats.get_current_sword().accuracy_bonus + PlayerStats.get_total_gem_bonus("Accuracy Bonus")
	if parent is Enemy:
		##print(parent)
		##if is_silence_attack:
			##var equipped_dash_attack : Ability = PlayerStats.get_equipped_ability("Dash Attack")
			##var damage : int = randi_range(total_attack_damage * total_accuracy, total_attack_damage) * equipped_dash_attack.attack_damage_modifier
			##parent.apply_silenced_and_damage(damage, equipped_dash_attack.slow_wait_time)
		##else:
			##issue_attack(dash_attack_hit_box)
		if PlayerStats.player_stats["Class"] == "Tyro":
			var multiplier : float = PlayerStats.player_stats["Lock On Multiplier"]
			parent.add_stun_marker(multiplier)
		
func pick_up_items() -> void:
	var areas : Array[Area2D]= item_pick_up_area.get_overlapping_areas()
	for area in areas:
		var area_parent = area.get_parent()
		if area_parent is ItemInteractable:
			if area_parent and !area_parent.can_pick_up:
				area_parent.pick_up_item()
				if area_parent.can_pick_up:
					return

func spawn_circl_of_truth() -> void:
	SignalBus.shake_camera.emit(5)
	var circle_of_truth : CircleOfTruth = preload("uid://h0a1l1dpukn8").instantiate()
	circle_of_truth.global_position = global_position
	get_parent().add_child(circle_of_truth)

func issue_cyclone_slash_attack() -> void:
	SignalBus.shake_camera.emit(3)
	var cyclone_slash : Ability = PlayerStats.get_equipped_ability("Combat Ability 1")
	issue_attack(ability_hit_box, cyclone_slash.attack_damage_modifier, cyclone_slash)

var hit_sfx : AudioStream = preload("uid://cm3vsmb4a64u4")

func start_knock_back() -> void:
	if stored_enemy:
		#GameManager.player_can_move = false
		knocked_back = true
		#parent.damageable = false
		disable_hurt_box()
		#set_sword_texture(animation_name)
		#set_outfit_texture(animation_name)
		var total_knock_back : float = (knock_back_wait_time * PlayerStats.knock_back_buff_mod)
		knock_back_timer.wait_time = total_knock_back

		var dir = (stored_enemy.global_position - global_position).normalized()
		knock_back_direction = GameManager.set_direction(dir.x) * -1
		play_sfx(hit_sfx)
		knock_back_timer.start()
		#SignalBus.disable_enemy_hit_box.emit()
		SignalBus.shake_camera.emit(3)
		HitStopManager.freeze(0.06, 0.0)
		start_invincibility()

func knock_back_player() -> void:
		if knocked_back and can_knock_back:
			#print("PLAYER CAN ATTACK %s" % GameManager.player_can_attack)
			velocity.x = knock_back_direction * PlayerStats.KNOCKBACK_FORCE
			flip_textures(!(velocity.x < 0))
			if knock_back_timer.time_left <= 0:
				knocked_back = false
				can_knock_back = true
				GameManager.player_can_move = true
				stop_player()
			
			move_and_slide()

func play_levelup_visual() -> void:
	var level_up_visual = preload("uid://bgddefvdr3k41").instantiate()
	add_child(level_up_visual)


func _on_mining_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is OreRock:
		in_mining_area = true


func _on_mining_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is OreRock:
		in_mining_area = false

func play_denied_sfx() -> void:
	play_sfx(DENIED, 3.0)

func spawn_after_image() -> void:
	var ghost : Sprite2D = Sprite2D.new()
	ghost.texture = sprite.texture
	ghost.hframes = sprite.hframes
	ghost.vframes = sprite.vframes
	ghost.frame = sprite.frame
	
	ghost.global_position = global_position - Vector2(0, 32)
	ghost.scale = sprite.scale
	ghost.flip_h = sprite.flip_h
	ghost.modulate = Color(0,3.5,1.0,1.0)
	get_parent().add_child(ghost)
	var tween = create_tween()
	await tween.tween_property(ghost, "modulate:a", 0.0, 0.3).finished
	#tween.finished.connect(ghost.queue_free)
	ghost.queue_free()

func rebuild_junk_held_offsets() -> void:
	for i in range(junk_picked_up.size()):
		junk_picked_up[i].offset_distance = 32
		junk_picked_up[i].offset_distance *= i
