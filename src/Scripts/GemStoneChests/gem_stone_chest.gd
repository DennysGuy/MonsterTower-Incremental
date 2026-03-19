class_name GemStoneChest extends Node2D

@export var chest_stats : GemChestStats
@onready var graphic: Sprite2D = $Graphic
@onready var enemy_health_bar: EnemyHealthBar = $EnemyHealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tag: Label = $NameTag/Tag
@onready var statemachine: StateMachine = $Statemachine

@export var no_drop_rate : float = 50
const CRAFTING_NOTIFICATION = preload("uid://wyjbs57smen4")

const CHEST_HIT_1 = preload("uid://bfigd63pmp1un")
const CHEST_HIT_2 = preload("uid://tf8bpygyj04j")
const CHEST_HIT_3 = preload("uid://dxsantqowau0r")

var can_hit : bool = true

@onready var chest_hits : Array[AudioStream] = [CHEST_HIT_1, CHEST_HIT_2, CHEST_HIT_3]

var health : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_health_bar.max_value = chest_stats.max_health
	health = chest_stats.max_health
	enemy_health_bar.value = health
	tag.text = chest_stats.gem_chest_name
	statemachine.init(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	statemachine.process_frame(delta)
	
func _physics_process(delta: float) -> void:
	statemachine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	statemachine.process_input(event)

func set_graphic_closed() -> void:
	graphic.texture = chest_stats.graphic_closed

func set_graphic_opened() -> void:
	graphic.texture = chest_stats.graphic_opened
	spawn_gem()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is GemStoneHitArea and can_hit:
		var min_damage = PlayerStats.player_stats["Attack Damage"] * PlayerStats.player_stats["Accuracy"]
		var max_damage = PlayerStats.player_stats["Attack Damage"] 
		
		var incoming_damage  = int(randi_range(min_damage,max_damage) * 1.0)
		damage_chest(incoming_damage)

func damage_chest(damage : int) -> void:
	play_sfx(chest_hits.pick_random(),-2)
	enemy_health_bar.show()
	health -= damage
	enemy_health_bar.value = health
	print("THIS IS HEALTH! %s" % health)
	animation_player.play("Hit")
	var damage_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	damage_label.label.text = str(damage)
	damage_label.global_position = Vector2(global_position.x, global_position.y - 20)
	get_parent().add_child(damage_label)

func spawn_gem() -> void:
	
	var randi_num : int = randi_range(0, 100)
	var drop_rate : int = int(PlayerStats.player_stats["Tier 1 Gem Drop Rate"] * 100)
	if randi_num > drop_rate:
		return
	
	var total_weight : int = 0
	
	for gem in chest_stats.loot_table:
		total_weight += gem.drop_rate
	
	if total_weight <= 0:
		return
	
	var roll : float = randf() * total_weight
	
	for gem in chest_stats.loot_table:
		roll -= gem.drop_rate
		if roll <= 0:
			create_gem_drop(gem)
			return


func create_gem_drop(gem_stone : GemStone) -> void:
	play_sfx(CRAFTING_NOTIFICATION)
	var item_interactable : ItemInteractable = preload("uid://dgtobkubdjq27").instantiate()
	item_interactable.item = gem_stone
	item_interactable.icon.texture = gem_stone.shop_icon
	item_interactable.global_position = global_position
	get_parent().add_child(item_interactable)


func play_sfx(sound: AudioStream, volume: float = 0.0):
	var player := AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = volume
	player.bus = &"SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
