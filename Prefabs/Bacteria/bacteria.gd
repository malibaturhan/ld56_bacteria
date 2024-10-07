extends CharacterBody2D

enum PHASES{
	STANDARD,
	PROLIFERATING
}

@onready var bacteria_parent = get_tree().get_first_node_in_group("BACTERIA_PARENT")
@onready var food_text: Label = $UIManager/HowMuchAte
@onready var proliferation_progress_bar: ProgressBar = $UIManager/ProliferationProgress
@onready var mouse_manager = get_tree().get_first_node_in_group("MOUSE_MANAGER")
@onready var body_texture: CompressedTexture2D = $Body.texture
@onready var proliferation_sound: AudioStreamPlayer2D = $ProliferationSound
@onready var proliferation_timer: Timer = $ProliferationTimer
@onready var proliferation_animation: AnimationPlayer = $ProliferationAnimation

@export_file("*.tscn") var bacteria_scene_path: String
@export var bacteria_scene: PackedScene
@export var movement_speed:float = 50.0
@export var movement_vector: Vector2	# Active movement vector
@export var food_amount: int = 0
@export var needed_foot_for_proliferation: int = 10

signal ate_something

# State checks
var is_moving: bool = false
var active_phase = PHASES.STANDARD

# State parameters
var aim_location: Vector2

func _ready() -> void:
	new_born_reset()
	bacteria_scene = load(bacteria_scene_path)
	if bacteria_scene == null:
		print("bacteria_scene scene is not assigned!")
	else:
		   
		print("bacteria_scene scene is assigned correctly.")

	set_food_text(food_amount, needed_foot_for_proliferation)
	set_local_ui_element()
	ate_something.connect(set_local_ui_element)
	aim_location = global_transform.origin
	if mouse_manager:
		mouse_manager.bacteria_move_signal.connect(set_new_aim_position)

func new_born_reset():
	active_phase = PHASES.STANDARD
	food_amount = 0
	bacteria_parent.append_bacteria_list(self)
func set_local_ui_element():
	if active_phase == PHASES.STANDARD:
		food_text.visible = true
		proliferation_progress_bar.visible = false
	elif active_phase == PHASES.PROLIFERATING:
		food_text.visible = false
		proliferation_progress_bar.visible = true
		

func set_food_text(eaten_food, max_food):
	food_text.text = "%s/%s " %[eaten_food, max_food]
	
func set_proliferation_progress_bar():
	print("setting bar %s" %[proliferation_timer.time_left/proliferation_timer.wait_time])
	proliferation_progress_bar.value = 1.0 - (proliferation_timer.time_left / proliferation_timer.wait_time)

func set_new_aim_position(new_aim_pos: Vector2):
	is_moving = true
	aim_location = new_aim_pos
	
func get_aim_position():
	return aim_location
	
func get_movement_vector():
	return movement_vector
	
func get_body_dimensions() -> Vector2:
	return Vector2(body_texture.get_size()[0], body_texture.get_size()[1])
	
func increase_food(food_power) -> bool:
	if active_phase == PHASES.STANDARD:
		food_amount += food_power
		set_food_text(food_amount, needed_foot_for_proliferation)
		if food_amount >= needed_foot_for_proliferation:
			active_phase = PHASES.PROLIFERATING
			proliferation_timer.start()
		ate_something.emit()
		return true
	else:
		ate_something.emit()
		return false

func run_proliferation_animation():
	proliferation_animation.play("proliferation_animation")
	
func stop_proliferation_animation():
	modulate = Color("#ffffff")

func _physics_process(delta: float) -> void:
	if active_phase == PHASES.PROLIFERATING:
		set_proliferation_progress_bar()
		run_proliferation_animation()
	if is_moving :
		movement_vector = (aim_location - global_position).normalized()
		if (global_position - aim_location).length() < 4.0:
			is_moving = false
		else:
			velocity = (movement_vector * movement_speed)
			move_and_slide()

func _on_proliferation_timer_timeout() -> void:
	print("proliferation")
	food_amount = 0
	proliferation_sound.play()
	var new_bacteria_scene = bacteria_scene.instantiate()
	new_bacteria_scene.global_position = global_position
	bacteria_parent.add_child(new_bacteria_scene)
	new_bacteria_scene.set_new_aim_position(new_bacteria_scene.get_aim_position())
	active_phase = PHASES.STANDARD
