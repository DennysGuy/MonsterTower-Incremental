class_name BindingButton extends Button

enum BINDING_TYPE {KEYBOARD, CONTROLLER}
@export var binding_type : BINDING_TYPE = BINDING_TYPE.KEYBOARD
@export var action : String

var stored_event = null

var is_listening : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_current_key()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_current_key() -> void:
	var events = InputMap.action_get_events(action)
	
	for event in events:
		if event is InputEventKey or event is InputEventMouseButton and binding_type == BINDING_TYPE.KEYBOARD:
			stored_event = event
			var event_text = event.as_text()
			text = event_text.substr(0,16)
		
		elif event is InputEventJoypadButton and binding_type == BINDING_TYPE.CONTROLLER:
			var event_text = event.as_text()
			text = event_text.substr(0,16)
			stored_event = event


func _on_toggled(toggled_on: bool) -> void:
	is_listening = toggled_on
	if is_listening:
		text = "Press Any Key To Set.."
	else:
		show_current_key()

func _input(new_event: InputEvent) -> void:
	if not is_listening:
		return
	
	if new_event is InputEventKey and binding_type == BINDING_TYPE.KEYBOARD:
		accept_binding(new_event)
	
	elif new_event is InputEventMouseButton and binding_type == BINDING_TYPE.KEYBOARD and new_event.pressed:
		accept_binding(new_event)
	
	elif new_event is InputEventJoypadButton and binding_type == BINDING_TYPE.CONTROLLER and new_event.pressed:
		accept_binding(new_event)

func accept_binding(new_event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	SettingsManager.update_key_binding(action, stored_event, new_event)
	stored_event = new_event
	is_listening = false
	show_current_key()

func start_listening() -> void:
	await get_tree().process_frame
	is_listening = true
