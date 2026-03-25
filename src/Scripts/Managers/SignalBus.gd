extends Node

@warning_ignore("unused_signal")
signal shake_camera(length : float)
@warning_ignore("unused_signal")
signal spawn_tech_tree
@warning_ignore("unused_signal")
signal update_player_health(value : int)
@warning_ignore("unused_signal")
signal update_player_mp
@warning_ignore("unused_signal")
signal spawn_respawn_box
@warning_ignore("unused_signal")
signal unlock_refinery
@warning_ignore("unused_signal")
signal unlock_cooking_station
@warning_ignore("unused_signal")
signal update_sword_texture(animation_name : String)
@warning_ignore("unused_signal")
signal spawn_enemies
@warning_ignore("unused_signal")
signal spawn_resources
@warning_ignore("unused_signal")
signal move_to_next_room

@warning_ignore("unused_signal")
signal return_to_starshire
@warning_ignore("unused_signal")
signal store_entrance_data(data : TowerEntranceData)
@warning_ignore("unused_signal")
signal update_player_uniform(animation_name : String)
@warning_ignore("unused_signal")
signal issue_big_notification(notification : String)
@warning_ignore("unused_signal")
signal hide_big_notification
@warning_ignore("unused_signal")
signal check_can_sword_craft
@warning_ignore("unused_signal")
signal issue_can_craft_sword_scene

@warning_ignore("unused_signal")
signal play_close_out_animation

@warning_ignore("unused_signal")
signal update_kill_quota_text(message : String, hit_quota : bool, challenge_unlocked : bool)
@warning_ignore("unused_signal")
signal update_monsters_left(text : String, out_of_enemies : bool)
@warning_ignore("unused_signal")
signal update_kill_quota
@warning_ignore("unused_signal")
signal unlock_next_room
@warning_ignore("unused_signal")
signal update_entrance_map(index : int)
@warning_ignore("unused_signal")
signal update_resource_needed_panel
@warning_ignore("unused_signal")
signal play_countdown_beep

@warning_ignore("unused_signal")
signal show_can_cook_dish_label
@warning_ignore("unused_signal")
signal show_can_smelt_bar_label
@warning_ignore("unused_signal")
signal show_can_craft_sword

@warning_ignore("unused_signal")
signal hide_can_cook_dish_label
@warning_ignore("unused_signal")
signal hide_can_smelt_bar_label
@warning_ignore("unused_signal")
signal hide_can_craft_sword
@warning_ignore("unused_signal")
signal update_mode_description_to_expedition
@warning_ignore("unused_signal")
signal set_mode_to_expedition
@warning_ignore("unused_signal")
signal go_to_victory_hunt_menu
@warning_ignore("unused_signal")
signal go_to_failure_hunt_menu
@warning_ignore("unused_signal")
signal hide_hunt_time_label

@warning_ignore("unused_signal")
signal show_hunt_challenge_button 
@warning_ignore("unused_signal")
signal hide_hunt_challenge_button
@warning_ignore("unused_signal")
signal show_bag_stats

@warning_ignore("unused_signal")
signal populate_item_notification_panel(item_data : Item)
@warning_ignore("unused_signal")
signal show_class_notice
@warning_ignore("unused_signal")
signal set_icons
@warning_ignore("unused_signal")
signal play_sfx(audio_stream : AudioStream)
@warning_ignore("unused_signal")
signal hide_tech_tree_canvas_layer
@warning_ignore("unused_signal")
signal stop_player

@warning_ignore("unused_signal")
signal spawn_class_selection_menu
@warning_ignore("unused_signal")
signal show_ap_notice
@warning_ignore("unused_signal")
signal spawn_tower_map
@warning_ignore("unused_signal")
signal enable_tower_map_button
@warning_ignore("unused_signal")
signal play_warrior_unlock_animation
@warning_ignore("unused_signal")
signal check_for_notification(notification_type : GameManager.NOTIFICATION_TYPE)
@warning_ignore("unused_signal")
signal spawn_warrior_tech_tree
@warning_ignore("unused_signal")
signal update_gem_station_sockets
@warning_ignore("unused_signal")
signal update_banner_info(tower_entrance_data : TowerEntranceData)
