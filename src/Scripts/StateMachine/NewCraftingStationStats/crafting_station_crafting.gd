class_name CraftingStationCrafting extends State

@export var idle_state : State

const COOKING_SFX = preload("uid://bnslqqjqnb8y2")
const SMELTING_SFX = preload("uid://ds0to3h3m8yir")


func enter() -> void:
	parent.crafting_progressbar.value = 0
	parent.update_quantity_details()
	
	if parent.station_type == parent.STATION_TYPE.COOKING:
		parent.sfx_player.play_sfx(COOKING_SFX)
	else:
		parent.sfx_player.play_sfx(SMELTING_SFX)
	
	
func exit() -> void:
	if parent.crafting_quantity <= 0:
		parent.stored_recipe = null
		parent.crafting_started = false
		parent.hide_crafting_tracker()
	parent.current_pitch = 1.0
	parent.sfx_player.stop()
	
func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	match parent.station_type:
			parent.STATION_TYPE.COOKING:
				parent.crafting_progressbar.value += PlayerStats.player_stats["Cooking Speed"]
			parent.STATION_TYPE.SMELTING:
				parent.crafting_progressbar.value += PlayerStats.player_stats["Smelting Speed"]
			
	if parent.crafting_progressbar.value >= parent.crafting_progressbar.max_value:
		var num_check = randi_range(0,100)
		var success_rate : float = parent.stored_recipe.success_rate
		match parent.station_type:
			parent.STATION_TYPE.COOKING:
				success_rate += PlayerStats.player_stats["Cooking Accuracy Bonus"]
			parent.STATION_TYPE.SMELTING:
				success_rate += PlayerStats.player_stats["Smelting Accuracy Bonus"]
				
		if num_check <= int(success_rate*100):
			var crit_success_chance : float = 0.0
			match parent.station_type:
				parent.STATION_TYPE.COOKING:
					crit_success_chance = PlayerStats.player_stats["Critical Cooking Chance"]
				parent.STATION_TYPE.SMELTING:
					crit_success_chance = PlayerStats.player_stats["Critical Smelting Chance"]
			var new_num_check : int = randi_range(0,100)
			if new_num_check <= int(crit_success_chance * 100):
				var test_bonus_amount := 2
				parent.play_crit_success_sfx()
				var positions : Array[Vector2] = [Vector2(20,0), Vector2(-20,0)]
				for num in range(test_bonus_amount):
					parent.spawn_item(parent.stored_recipe.output_item, positions[num])
					#await get_tree().create_timer(0.3).timeout
			else:
				parent.play_success_sfx()
				parent.spawn_item(parent.stored_recipe.output_item)
		else:
			var item : Item
			match parent.station_type:
				parent.STATION_TYPE.COOKING:
					item = preload("uid://dhaeygij4vyxi")
				parent.STATION_TYPE.SMELTING:
					item = preload("uid://broygdxgkjkxp")

			parent.play_failure_sfx()
			parent.spawn_item(item)
			
		parent.crafting_quantity -= 1
		
		if parent.crafting_quantity <= 0:
			parent.crafting_progressbar.value = 0
			return idle_state
		else:
			return self
		
	return null
