class_name ImmunSystemCell
extends CharacterBody2D

enum PHASES{
	IDLE,
	MOVING,
	ATTACKING
}

@onready var bacteria_parent = get_tree().get_first_node_in_group("BACTERIA_PARENT")
@onready var mouse_manager = get_tree().get_first_node_in_group("MOUSE_MANAGER")
var active_state: PHASES

@export var movement_speed: float
@export var injection_speed: float = 0.1
@export var roi: Vector2
@export var attack_range: float = 3.4

var movement_vector: Vector2

func _ready() -> void:
	active_state = PHASES.IDLE
	mouse_manager.bacteria_move_signal.connect(set_roi)
	
func movement() -> void:
	pass	# Virtual function
	
func set_roi(_roi: Vector2):
	#print("roi set for %s" %[self.name])
	roi = _roi
	movement_vector = calculate_movement_vector(roi)
	
func check_if_bacteria_exists():
	return bacteria_parent.get_if_bacteria_remains()

func calculate_movement_vector(aim_pos: Vector2) -> Vector2:
	var _movement_vector = aim_pos - global_position
	return _movement_vector.normalized()
	
func set_state():
	if roi && global_position.distance_to(roi) > attack_range:
		active_state = PHASES.MOVING
	#elif roi 
