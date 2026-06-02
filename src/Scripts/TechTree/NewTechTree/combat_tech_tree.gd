class_name CombatTechTree extends TechTreeMap

@onready var attack_1_node: TechNode = $Attack1Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	player_tech_tree_intro()
	attack_1_node.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
