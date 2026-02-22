class_name EnemyDead extends State

@export var wait_time : float

@export var death_sound_1 : AudioStream
@export var death_sound_2 : AudioStream
@export var death_sound_3 : AudioStream

@onready var death_sounds : Array[AudioStream] = [death_sound_1, death_sound_2, death_sound_3]

func enter() -> void:
	super()
	parent.damageable = false
	parent.is_dead = true
	
	#parent.disable_hit_box()
	#parent.disable_hurt_box()
		
	drop_items()
	parent.give_xp()
	HitStopManager.freeze(0.15)

	parent.health_bar.hide()
	parent.timer.wait_time = wait_time
	parent.sfx_player.play_sfx(death_sounds.pick_random())
	parent.timer.start()
	parent.start_fadeout()
	
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.timer.time_left <= 0:
		pass
		
	return null

func drop_items() -> void:
	if GameManager.hunt_challenge_selected:
		return
		
	var item : EnemyDrop = parent.enemy_stats.novelty_item_drop
	var item_interactable : ItemInteractable = null
	if item:
		item_interactable = preload("uid://dgtobkubdjq27").instantiate()
		item_interactable.item = item
		item_interactable.icon.texture = item.drop_icon
		item_interactable.global_position = parent.global_position
	
	if PlayerStats.facilities_unlocked["Cooking Station"] and PlayerStats.get_bag("Bag").max_slots >= 2:
		var cooking_item : EnemyDrop = parent.enemy_stats.cooking_item_drop
		var cooking_item_interactable : ItemInteractable = preload("uid://dgtobkubdjq27").instantiate()
		var random_check : int = randi_range(0, 100)
		if cooking_item and random_check <= int((cooking_item.drop_chance + PlayerStats.player_stats["Cooking Drop Chance Bonus"]) * 100):
			cooking_item_interactable.item = cooking_item
			cooking_item_interactable.icon.texture = cooking_item.drop_icon
			cooking_item_interactable.global_position = Vector2(parent.global_position.x + 20,parent.global_position.y)
			parent.drop_scene.add_child(cooking_item_interactable)
	
	if parent.enemy_stats.crafting_item_drop and PlayerStats.get_bag("Bag").max_slots >= 2:
		var crafting_item : EnemyDrop = parent.enemy_stats.crafting_item_drop
		var crafting_item_interactable : ItemInteractable = preload("uid://dgtobkubdjq27").instantiate()
		var random_check_2 : int = randi_range(0,100)
		var drop_chance : float = crafting_item.drop_chance
		
		if PlayerStats.check_item_in_next_sword_recipe(parent.enemy_stats.crafting_item_drop):
			drop_chance += 0.15
			
		if random_check_2 <= int(drop_chance * 100):
			crafting_item_interactable.item = crafting_item
			crafting_item_interactable.icon.texture = crafting_item.drop_icon
			crafting_item_interactable.global_position = Vector2(parent.global_position.x - 20, parent.global_position.y)
			parent.drop_scene.add_child(crafting_item_interactable)
	
	parent.drop_scene.add_child(item_interactable)
