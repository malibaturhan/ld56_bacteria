extends Node


@export var bacteria_list: Array[CharacterBody2D]

func _ready() -> void:
	for obj in self.get_children():
		if obj.is_in_group("BACTERIA"):
			bacteria_list.append(obj)
