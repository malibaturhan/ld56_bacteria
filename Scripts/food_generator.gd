extends Node

@export var initial_food_amount:int = 10
@export var food_array: Array[PackedScene]
@onready var camera_2d: Camera2D = $"../Camera2D"

var game_area: Vector2

func _ready() -> void:
	game_area = camera_2d.get_viewport_rect().size
	create_initial_food(initial_food_amount)
	print(game_area)

func create_initial_food(amount: int):
	for i in range(amount):
		var randX = randi_range(10, game_area.x -10)
		var randY = randi_range(10, game_area.y -10)
		var new_food = food_array.pick_random()
		new_food = new_food.instantiate()
		new_food.global_position = Vector2(randX, randY)
		add_child(new_food)
