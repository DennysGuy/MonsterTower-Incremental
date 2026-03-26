class_name RoomInfoBanner extends Control

@onready var room_info_banner: TextureRect = $RoomInfoBanner

@onready var room_type_label: Label = $RoomTypeLabel
@onready var tracker_label: RichTextLabel = $TrackerLabel

const BOSS_DOOR_ROOM_BANNER = preload("uid://biqx0uuxyi844")
const BOSS_ROOM_BANNER = preload("uid://dthuj11kv2hm8")
const EXPEDITION_ROOM_BANNER = preload("uid://c55ibjs8jijw7")
const HUNT_CHALLENGE_ROOM_BANNER = preload("uid://bvtlgbrmd3tqy")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.update_banner_info.connect(update_banner_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_banner_info(tower_entrance_data : TowerEntranceData) -> void:
	show()
	match tower_entrance_data.floor_type:
		tower_entrance_data.FLOOR_TYPE.EXPEDITION:
			room_type_label.text = "Expedition Map"
			room_info_banner.texture = EXPEDITION_ROOM_BANNER
			if tower_entrance_data.is_expedition_floor() and tower_entrance_data.unlock_recipe and !tower_entrance_data.hunt_challenge_completed:
				tracker_label.text = "Repair the Elevator!"
			else:
				tracker_label.text = "~ Train, Hunt, Prepare! ~"
		tower_entrance_data.FLOOR_TYPE.CHALLENGE:
			room_type_label.text = "Challenge Map"
			room_info_banner.texture = HUNT_CHALLENGE_ROOM_BANNER
			if tower_entrance_data.camp_fires_reached >= tower_entrance_data.total_camp_fires:
				tracker_label.text = "[color=green]Beat floor Challenge,\nUnlock next floor![/color]"
			else:
				tracker_label.text = "Campfires Discovered: %s/%s" % [tower_entrance_data.camp_fires_reached, tower_entrance_data.total_camp_fires]
		tower_entrance_data.FLOOR_TYPE.BOSS_DOOR:
			room_type_label.text = "Boss Door Map"
			room_info_banner.texture = BOSS_DOOR_ROOM_BANNER
			#Will probably change this to keys once I get there
			tracker_label.text = "Campfires Discovered: %s/%s" % [tower_entrance_data.camp_fires_reached, tower_entrance_data.total_camp_fires]
		tower_entrance_data.FLOOR_TYPE.BOSS_DOOR:
			room_type_label.text = "Boss Map"
			room_info_banner.texture = BOSS_ROOM_BANNER
