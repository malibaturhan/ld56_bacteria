extends ImmunSystemCell

func _physics_process(delta: float) -> void:
	if roi && movement_vector:
		if roi.distance_to(global_position):
			velocity = movement_vector * movement_speed
		

func attack():
	pass
