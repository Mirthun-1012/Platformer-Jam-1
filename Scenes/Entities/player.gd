extends CharacterBody2D

@export var gravity := 600
@export var terminal_gravity := 500

@export_group("Move")
@export var speed := 200
@export var acceleration := 800
@export var friction := 700

@export_group("Jump")
@export var jump_strength := 300
var faster_fall = false

var direction := Vector2.ZERO


func _physics_process(delta: float) -> void:
	get_input()
	apply_movement(delta)
	apply_gravity(delta)

func get_input():
	
	# Horizontal Movement
	direction.x = Input.get_axis("Left", "Right")
	
	#region Jump
	if Input.is_action_just_pressed('Jump') and is_on_floor():
		velocity.y = -jump_strength
		faster_fall = false
	
	if Input.is_action_just_released("Jump") and velocity.y<0:
		faster_fall = true
	#endregion

func apply_movement(delta):
	
	#region Horizontal Movement
	# The speed the player accelerates
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x*speed, delta * acceleration)
	# The speed the player decelerates
	else:
		velocity.x = move_toward(velocity.x, 0, delta * friction)
	#endregion

	move_and_slide()

func apply_gravity(delta):
	
	# Normal Gravity
	velocity.y += gravity * delta 
	
	# Faster fall only when player is jumping
	if faster_fall and velocity.y<0:
		velocity.y += gravity *  1.8 * delta
	
	velocity.y = min(velocity.y, terminal_gravity)


func dead() -> void:
	print("Player is dead")

func hit() -> void:
	dead()
