extends Area2D

# How effective food is
@export var food_power:int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("BACTERIA"):
		if body.increase_food(food_power):
			self.queue_free()
