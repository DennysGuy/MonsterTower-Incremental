extends Node

@warning_ignore("unused_signal")
signal update_xp_bar
@warning_ignore("unused_signal")
signal play_level_up_sfx
@warning_ignore("unused_signal")
signal update_available_ap_label

const XP_GROWTH_RATE : float = 1.3
const BASE_XP : int = 100

func check_for_level_up() -> void:
	if PlayerStats.player_stats["Current XP"] >= PlayerStats.player_stats["Needed XP"]:
		#Set current XP
		PlayerStats.player_stats["Current XP"] = (PlayerStats.player_stats["Current XP"]-PlayerStats.player_stats["Needed XP"])
		#increase player level
		PlayerStats.player_stats["Level"] += 1
		QuestManager.check_level.emit()
		#reward 1 AP point 
		
		if GameManager.can_unlock_class():
			PlayerHudSignalBus.show_class_notice.emit()
			CodexManager.send_codex_notification.emit("Select a [color=purple]Class[/color] at\nThe Class Center!")
		
		var total_ap : int = 1 + int(PlayerStats.player_stats["Bonus AP"])
		PlayerStats.player_stats["Ability Points"] += total_ap
		
		SignalBus.check_for_notification.emit(GameManager.NOTIFICATION_TYPE.AP)
		TechTreeManager.update_available_ap_label.emit()
		#Update Needed XP
		PlayerStats.player_stats["Needed XP"] = xp_formula()
		#play level up sfx
		play_level_up_sfx.emit()
		
		SaveManager.save_player_stats()
	update_xp_bar.emit()

func xp_formula() -> int:
	return int(BASE_XP * (pow(XP_GROWTH_RATE,PlayerStats.player_stats["Level"])))
