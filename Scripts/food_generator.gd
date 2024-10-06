extends Node

@export var food_array: Array[PackedScene]

var game_area

func _ready() -> void:
	game_area = null
