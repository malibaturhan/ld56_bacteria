extends CharacterBody2D

@onready var mouse_manager = get_tree().get_first_node_in_group("MOUSE_MANAGER")
@onready var body_texture: CompressedTexture2D = $Body.texture
@onready var proliferation_sound: AudioStreamPlayer2D = $ProliferationSound
@export var bacteria: PackedScene

@export var movement_speed:float = 50.0
@export var movement_vector: Vector2	# Active movement vector
@export var food_amount: int = 0

# State checks
var is_moving: bool = false

# State parameters
var aim_location: Vector2

func _ready() -> void:
	aim_location = global_transform.origin
	if mouse_manager:
		mouse_manager.bacteria_move_signal.connect(set_new_aim_position)

func set_new_aim_position(new_aim_pos: Vector2):
	is_moving = true
	aim_location = new_aim_pos
	
func get_aim_position():
	return aim_location
	
func get_movement_vector():
	return movement_vector
	
func get_body_dimensions() -> Vector2:
	return Vector2(body_texture.get_size()[0], body_texture.get_size()[1])
	
func _physics_process(delta: float) -> void:
	if is_moving :
		movement_vector = (aim_location - global_position).normalized()
		if (global_position - aim_location).length() < 4.0:
			is_moving = false
		else:
			velocity = (movement_vector * movement_speed)
			move_and_slide()


func _on_proliferation_timer_timeout() -> void:
	print("proliferation")
	proliferation_sound.play()
	var new_bacteria = bacteria.instantiate()
	new_bacteria.global_position = global_position
	add_child(new_bacteria)
	new_bacteria.set_new_aim_position(new_bacteria.get_aim_position())
