class_name FacilityNotice extends Control

@export var facility_name : String
@onready var notice_icon: TextureRect = $NoticeIcon

@export var hover_height : float = 4.0
@export var hover_speed : float = 2.0
@export var base_offset : float = 0.0

var base_y : float
var t : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notice_icon.hide()
	HubManager.show_facility_notification.connect(show_notice_icon)
	HubManager.hide_facility_notification.connect(hide_notice_icon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta * hover_speed
	notice_icon.position.y = (base_y-base_offset) + sin(t) * hover_height

func show_notice_icon(facility_name : String) -> void:
	if self.facility_name == facility_name:
		notice_icon.show()

func hide_notice_icon(facility_name : String) -> void:
	if self.facility_name == facility_name:
		notice_icon.hide()
