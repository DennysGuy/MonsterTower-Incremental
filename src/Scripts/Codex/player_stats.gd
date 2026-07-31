class_name PlayerStatsPage extends Control

@onready var hunter_name: Label = $Name
@onready var hunter_license_tier: Label = $HunterLicenseTier
@onready var hunter_class: Label = $Class
@onready var level: Label = $Level
@onready var xp_needed: Label = $XPNeeded
@onready var stats: Label = $Stats

@onready var player_base: TextureRect = $PlayerBase
@onready var outfit: TextureRect = $Outfit
@onready var weapon: TextureRect = $Weapon

@onready var weapon_stats_name_jump_height: Label = $"WeaponStats-Name-JumpHeight"
@onready var weapon_stats_accuracy_knock_back: Label = $"WeaponStats-Accuracy-KnockBack"
@onready var socket_h_box_container: HBoxContainer = $SwordSocketBG/SocketHBoxContainer

var license_tier_text : Dictionary = {
	0: "0",
	1: "I",
	2: "II",
	3: "III",
	4: "IV",
	5: "V",
	6: "VI",
	7: "VII",
	8: "VIII",
	9: "IX",
	10: "X"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CodexManager.update_stats_page.connect(update_stats_page)
	update_stats_page()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func update_stats_page() -> void:
	outfit.texture = OutfitGraphics.get_outfit_graphic("Idle")
	if PlayerStats.get_current_sword():
		weapon.texture = SwordGraphics.get_sword_graphic("Idle")
	
	hunter_license_tier.text = "Hunter License Tier: %s" % license_tier_text[TechTreeManager.current_prestige]
	hunter_class.text = "Class: %s" % PlayerStats.player_stats["Class"]
	level.text = "Level %s" % PlayerStats.player_stats["Level"]
	xp_needed.text = "XP: %s/%s" % [PlayerStats.player_stats["Current XP"],PlayerStats.player_stats["Needed XP"]]
	
	stats.text = """
	Attack Damage: [%s-%s]
	Defense: %s
	Crit Chance: %s %%
	Crit Damage: %s %%
	Health: %s/%s
	MP: %s/%s
	Pickaxe: %s
	Pickaxe Damage: %s
	Expedition Time: %s
	Movement Speed: %s
	Climbing Speed: %s
	Jump Height: %s
	Invincibility Duration: %s
	Cooking Speed: %s
	Smelting Speed: %s
	""" % [
		int(PlayerStats.player_stats["Attack Damage"] * PlayerStats.player_stats["Accuracy"]),
		int(PlayerStats.player_stats["Attack Damage"]),
		int(PlayerStats.player_stats["Defense"]),
		int(PlayerStats.player_stats["Crit Chance"] * 100),
		int(PlayerStats.player_stats["Crit Damage"] * 100),
		int(PlayerStats.player_stats["Current Health"]),
		int(PlayerStats.player_stats["Max Health"]),
		int(PlayerStats.player_stats["Current MP"]),
		int(PlayerStats.player_stats["Max MP"]),
		PlayerStats.get_pickaxe_name(),
		int(PlayerStats.player_stats["Mining Damage"]),
		int(PlayerStats.player_stats["Expedition Time"]),
		int(PlayerStats.player_stats["Movement Speed"]),
		int(PlayerStats.player_stats["Climbing Speed"]),
		int(PlayerStats.player_stats["Jump Height"]),
		int(PlayerStats.player_stats["Invincibility Duration"]),
		PlayerStats.player_stats["Cooking Speed"],
		PlayerStats.player_stats["Smelting Speed"]
	]
	weapon_stats_name_jump_height.text = """
	Weapon: %s
	Attack Bonus: %s (+%s)
	Defense Bonus: %s (+%s)
	Attack Speed: %s (Replace)
	Crit Bonus: %s %% (+%s %%)
	Crit D. Bonus: %s %% (+%s %%)
	Mov Spd. Bonus: %s (+%s)
	Jmp Ht. Bonus: %s (+%s)
	""" % [
		PlayerStats.get_current_sword().sword_name,

		int(PlayerStats.get_current_sword().attack_bonus + PlayerStats.get_total_gem_attack_bonus()),
		int(PlayerStats.get_total_gem_attack_bonus()),

		int(PlayerStats.get_current_sword().defense_bonus + PlayerStats.get_total_gem_defense_bonus()),
		int(PlayerStats.get_total_gem_defense_bonus()),

		PlayerStats.get_current_sword().attack_speed,

		int((PlayerStats.get_current_sword().crit_bonus + PlayerStats.get_total_gem_bonus("Crit Chance Bonus")) * 100),
		int(PlayerStats.get_total_gem_bonus("Crit Chance Bonus") * 100),

		int((PlayerStats.get_current_sword().crit_damage_bonus + PlayerStats.get_total_gem_bonus("Crit Damage Bonus")) * 100),
		int(PlayerStats.get_total_gem_bonus("Crit Damage Bonus") * 100),

		int(PlayerStats.get_current_sword().movement_speed_bonus + PlayerStats.get_total_gem_bonus("Movement Speed Bonus")),
		int(PlayerStats.get_total_gem_bonus("Movement Speed Bonus")),

		int(PlayerStats.get_current_sword().jump_height_bonus + PlayerStats.get_total_gem_bonus("Jump Height Bonus")),
		int(PlayerStats.get_total_gem_bonus("Jump Height Bonus"))
	]
	
	weapon_stats_accuracy_knock_back.text = """
	Accuracy Bonus: %s (+%s)
	Climb Speed Bonus: %s (+%s)
	Jump Height Bonus: %s (+%s)
	Stun Stacks Bonus: %s (+%s)
	Cooldown Bonus: %s (+%s)
	HP Bonus: %s (+%s)
	MP Bonus: %s (+%s)
	""" % [
		int(PlayerStats.get_current_sword().accuracy_bonus + PlayerStats.get_total_gem_bonus("Accuracy Bonus")),
		PlayerStats.get_total_gem_bonus("Accuracy Bonus"),

		int(PlayerStats.get_current_sword().climb_speed_bonus + PlayerStats.get_total_gem_bonus("Climb Speed Bonus")),
		int(PlayerStats.get_total_gem_bonus("Climb Speed Bonus")),

		int(PlayerStats.get_current_sword().jump_height_bonus + PlayerStats.get_total_gem_bonus("Jump Height Bonus")),
		int(PlayerStats.get_total_gem_bonus("Jump Height Bonus")),

		int(PlayerStats.get_current_sword().stun_stacks_bonus + PlayerStats.get_total_gem_bonus("Stun Stacks Bonus")),
		int(PlayerStats.get_total_gem_bonus("Stun Stacks Bonus")),

		int(PlayerStats.get_current_sword().cool_down_bonus + PlayerStats.get_total_gem_bonus("Cool Down Bonus")),
		int(PlayerStats.get_total_gem_bonus("Cool Down Bonus")),

		int(PlayerStats.get_current_sword().max_hp_bonus + PlayerStats.get_total_gem_bonus("Max HP Bonus")),
		int(PlayerStats.get_total_gem_bonus("Max HP Bonus")),

		int(PlayerStats.get_current_sword().max_mp_bonus + PlayerStats.get_total_gem_bonus("Max MP Bonus")),
		int(PlayerStats.get_total_gem_bonus("Max MP Bonus"))
	]

	clear_socket_container()
	for index in range(PlayerStats.get_current_sword().gem_stone_socket_count):
		var socket : Socket = preload("uid://bkyhhrkmtnn61").instantiate()
		
		if PlayerStats.get_gem_socket(index):
			socket.gem_stone = PlayerStats.get_gem_socket(index)
		
		socket_h_box_container.add_child(socket)


func clear_socket_container() -> void:
	for child in socket_h_box_container.get_children():
		child.queue_free()
