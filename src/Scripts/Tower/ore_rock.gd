class_name OreRock extends Node2D

@export var ore_rock_stats : OreRockStats
@export var state_machine : StateMachine
@onready var enemy_health_bar: EnemyHealthBar = $EnemyHealthBar
@onready var ore_rock_graphic: Sprite2D = $OreRockGraphic
@onready var name_tag: NameTag = $NameTag
@onready var ore_rock_area: Area2D = $OreRockArea
@onready var directions: Label = $Directions

var player : Player
var health : int
@onready var arrow_at_ore: Sprite2D = $ArrowAtOre

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
		else:
			directions.text = "Unlock the Refinery to Mine!"
	
	directions.show()
	
func _on_ore_rock_area_body_exited(body: Node2D) -> void:
	if body is Player: 
		if PlayerStats.facilities_unlocked["Refinery Station"]:
			body.stored_ore_rock = null
		directions.hide()

func damage_ore_rock(damage : int) -> void:
	enemy_health_bar.show()
	health -= damage
	enemy_health_bar.value = health
	print("THIS IS HEALTH! %s" % health)
	var damage_label : DamageLabel = preload("uid://dkchs27qqogyy").instantiate()
	damage_label.label.text = str(damage)
	damage_label.global_position = Vector2(global_position.x, global_position.y - 20)
	get_parent().add_child(damage_label)
	
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
			area.get_parent().stored_ore_rock = self
		else:
			directions.text = "Unlock the Refinery to Mine!"
	
	directions.show()


func _on_ore_rock_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player: 
		if PlayerStats.facilities_unlocked["Refinery Station"]:
			area.get_parent().stored_ore_rock = null
		directions.hide()
