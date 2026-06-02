class_name OreRock extends Node2D

@export var ore_rock_stats : OreRockStats
@export var state_machine : StateMachine
@onready var enemy_health_bar: EnemyHealthBar = $EnemyHealthBar
@onready var ore_rock_graphic: Sprite2D = $OreRockGraphic
@onready var name_tag: NameTag = $NameTag
@onready var ore_rock_area: Area2D = $OreRockArea
@onready var directions: Label = $Directions

var depleted : bool = false

var previously_hit_ore_rock : OreRock

var player : Player
var health : int
@onready var arrow_at_ore: Sprite2D = $ArrowAtOre

const ORE_ROCK_OUTLINE = preload("uid://0o57s7s4cjj3")

const LIGHTNING_ZAP_1 = preload("uid://c8y0vpgwr188w")
const LIGHTNING_ZAP_2 = preload("uid://iflxiiich1py")
const LIGHTNING_ZAP_3 = preload("uid://m2ttd6pijtu8")
const LIGHTNING_ZAP_4 = preload("uid://d3b6akqjch86h")

@onready var lightning_zaps : Array[AudioStream] = [LIGHTNING_ZAP_1,LIGHTNING_ZAP_2,LIGHTNING_ZAP_3,LIGHTNING_ZAP_4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_tag.tag.text = ore_rock_stats.ore_rock_name
	ore_rock_graphic.texture = ore_rock_stats.graphic
	health = ore_rock_stats.max_health
	enemy_health_bar.max_value = health
	
	if PlayerStats.facilities_unlocked["Refinery Station"]:
		arrow_at_ore.show()
	
	state_machine.init(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player:
		player = get_tree().get_first_node_in_group("Player")
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _on_ore_rock_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if PlayerStats.facilities_unlocked["Refinery Station"]:
			directions.text = "Press/Hold 'F' to Mine!"
			body.stored_ore_rock = self
			set_outline_visible()
		else:
			directions.text = "Unlock the Refinery to Mine!"
	
	directions.show()
	
func _on_ore_rock_area_body_exited(body: Node2D) -> void:
	if body is Player: 
		if PlayerStats.facilities_unlocked["Refinery Station"]:
			body.stored_ore_rock = null
		directions.hide()
		set_outline_invisible()

func damage_ore_rock(damage : int) -> void:
	enemy_health_bar.show()
	health -= damage
	enemy_health_bar.value = health
	print("THIS IS HEALTH! %s" % health)
	var damage_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	damage_label.label.text = str(damage)
	damage_label.global_position = Vector2(global_position.x, global_position.y - 20)
	get_parent().add_child(damage_label)
	if GameManager.remaining_bolt_chain_links > 0:
		cast_lightning_bolt()
		
		
		
	
func drop_ore_rock() -> void:
	var random_check : int = randi_range(0,100)
	var num_to_win : int = int(100 * (ore_rock_stats.ore_drop_chance+PlayerStats.player_stats["Ore Drop Chance Bonus"]))
	
	if random_check <= num_to_win:
		var item_interactable : ItemInteractable = preload("uid://dgtobkubdjq27").instantiate()
		item_interactable.item = ore_rock_stats.output_item
		item_interactable.icon.texture = ore_rock_stats.output_item.drop_icon
		item_interactable.global_position = self.global_position
		get_parent().add_child(item_interactable)

func _on_ore_rock_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		if PlayerStats.facilities_unlocked["Refinery Station"]:
			
			directions.text = "Press/Hold 'F' to Mine!"
			await get_tree().physics_frame
			area.get_parent().stored_ore_rock = self
			set_outline_visible()
		else:
			directions.text = "Unlock the Refinery to Mine!"
	
	directions.show()

func _on_ore_rock_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player: 
		if PlayerStats.facilities_unlocked["Refinery Station"]:
			area.get_parent().stored_ore_rock = null
			set_outline_invisible()
			await get_tree().physics_frame
			
		directions.hide()

func set_outline_visible() -> void:
	ore_rock_graphic.material = ORE_ROCK_OUTLINE

func set_outline_invisible() -> void:
	ore_rock_graphic.material = null

func cast_lightning_bolt() -> void:
	
	if !can_shoot_mining_bolt():
		return
	
	GameManager.remaining_bolt_chain_links -= 1
	
	var valid_rocks : Array[OreRock] = []
	
	for rock in get_tree().get_nodes_in_group("OreRocks"):
		if rock != self \
		and !rock.depleted \
		and global_position.distance_to(rock.global_position) <= PlayerStats.player_stats["Mining Bolt Distance"]:
			rock.previously_hit_ore_rock = self
			valid_rocks.append(rock)
	
	var selected_rocks : Array[OreRock] = []
	var multi_ore_hit : int = int(PlayerStats.player_stats["Multi Bolts"])
	var chosen_limit : int = randi_range(1, multi_ore_hit)
	for i in range(0,chosen_limit): #swap out to actual stat later
		for rock in valid_rocks:
			selected_rocks.append(rock)
		
	if !selected_rocks:
		return
		
	
	var bolt_count : int = min(PlayerStats.player_stats["Multi Bolts"], selected_rocks.size())
	for i in bolt_count:
		if is_instance_valid(selected_rocks[i]):
			create_lightning_bolt(global_position, selected_rocks[i].global_position)
			play_sfx(lightning_zaps.pick_random())
			await get_tree().create_timer(0.1).timeout
			if is_instance_valid(selected_rocks[i]):
				selected_rocks[i].damage_ore_rock(10)

func create_lightning_bolt(start_pos: Vector2, end_pos: Vector2) -> void:
	var outer := make_lightning_line(start_pos, end_pos, 12.0, Color(0.2, 0.8, 1.0, 0.45))
	var inner := make_lightning_line(start_pos, end_pos, 4.0, Color.WHITE)

	var tween := create_tween()
	tween.tween_property(outer, "modulate:a", 0.0, 0.12)
	tween.parallel().tween_property(inner, "modulate:a", 0.0, 0.12)

	await tween.finished
	outer.queue_free()
	inner.queue_free()


func make_lightning_line(start_pos: Vector2, end_pos: Vector2, width: float, color: Color) -> Line2D:
	var line := Line2D.new()
	get_parent().add_child(line)

	line.width = width
	line.default_color = color
	line.antialiased = true
	line.z_index = 100

	var points := PackedVector2Array()
	var segments := 10
	var direction := end_pos - start_pos
	var normal := direction.normalized().orthogonal()
	var distance := direction.length()

	for i in range(segments + 1):
		var t := float(i) / float(segments)
		var point := start_pos.lerp(end_pos, t)

		if i != 0 and i != segments:
			var offset := randf_range(-distance * 0.08, distance * 0.08)
			point += normal * offset

		points.append(point)

	line.points = points
	return line


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func can_shoot_mining_bolt() -> bool:
	var chance : int = int(PlayerStats.player_stats["Mining Bolt Chance"]*100)
	var chosen_number : int = randi_range(0,100)
	if chosen_number <= chance:
		return true
	
	return false
