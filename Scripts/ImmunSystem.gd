class_name ImmunSystemCell
extends CharacterBody2D

@onready var mouse_manager = get_tree().get_first_node_in_group("MOUSE_MANAGER")

@export var movement_speed: float
@export var injection_speed: float = 0.1
@export var region_of_interest: Vector2

func _ready() -> void:
	mouse_manager.bacteria_move_signal.connect(set_roi)
	
func movement() -> void:
	pass	# Virtual function
	
func set_roi(_roi: Vector2):
	#print("roi set for %s" %[self.name])
	region_of_interest = _roi
