extends Node


var _is_stopping: bool = false

func freeze(duration: float = 0.06, time_scale: float = 0.0, ease_in: float = 0.0, ease_out: float = 0.0) -> void:
	# duration: how long the stop lasts (seconds, real time)
	# time_scale: 0.0 = full stop, 0.05 = tiny motion, etc.
	# ease_in/out: optional ramps (seconds) to soften snap-in/out
	
	if duration <= 0.0:
		return
	
	# Restarting hitstop should extend/override cleanly
	if _is_stopping:
		# If already stopping, just restart (common for rapid hits)
		get_tree().call_deferred("create_timer", 0.0)
	
	# Kill any previous tween on this node by creating a new one and letting old be GC'd
	_is_stopping = true
	
	# Ease in (optional)
	if ease_in > 0.0:
		var t_in := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		t_in.tween_property(Engine, "time_scale", time_scale, ease_in).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await t_in.finished
	else:
		Engine.time_scale = time_scale
	
	# Wait using real time (ignore time_scale)
	var timer := get_tree().create_timer(duration, false, true, true)
	await timer.timeout
	
	# Ease out (optional)
	if ease_out > 0.0:
		var t_out := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		t_out.tween_property(Engine, "time_scale", 1.0, ease_out).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await t_out.finished
	else:
		Engine.time_scale = 1.0
	
	_is_stopping = false
