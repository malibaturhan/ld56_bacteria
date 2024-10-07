extends Node


@export var bacteria_list: Array[CharacterBody2D]

func _ready() -> void:
	pass
	
func append_bacteria_list(_bacteria: CharacterBody2D):
	bacteria_list.append(_bacteria)

func get_if_bacteria_remains():
	return len(bacteria_list) > 0
