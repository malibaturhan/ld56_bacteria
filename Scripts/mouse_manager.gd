extends Node2D

signal bacteria_move_signal(aim_location: Vector2)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse"):
		var new_aim_location = get_global_mouse_position()
		bacteria_move_signal.emit(new_aim_location)
		
