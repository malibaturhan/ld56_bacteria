extends StaticBody2D

enum PRODUCTION_TYPE{
	MACROPHAGE,
	NEUTROPHIL
}

@export var macrophage: PackedScene
@export var neutrophil: PackedScene
@export var type_of_production: PRODUCTION_TYPE
var cell_to_produce
# Where to spawn
@export var spawn_locations: Array[Node2D]
@onready var timer: Timer = $Timer

func _ready() -> void:
	set_type_of_production()
	
func set_type_of_production():
	if type_of_production == PRODUCTION_TYPE.MACROPHAGE:
		cell_to_produce = macrophage
		return
	cell_to_produce = neutrophil



func _on_timer_timeout() -> void:
	release_immun_cell()
	
func release_immun_cell() -> void:
	var where_to_spawn = spawn_locations.pick_random()
	var new_cell = cell_to_produce.instantiate()
	new_cell.global_position = where_to_spawn.global_position
	add_child(new_cell)
