class_name Player extends Entity

@onready var sword: Sprite2D = $Sprites/Sword
@onready var sprites: Node2D = $Sprites
@onready var timer: Timer = $Timer

func _ready() -> void:
	print(state_machine)
	super()

func _process(delta: float) -> void:
	super(delta)

func _physics_process(delta: float) -> void:
	super(delta)

func _unhandled_input(event: InputEvent) -> void:
	super(event)

func set_sword_texture(animation_name : String) -> void:
	sword.texture = SwordGraphics.get_sword_graphic(animation_name)

func flip_textures(flip : bool) -> void:
	for sprite in sprites.get_children():
		sprite.flip_h = flip
