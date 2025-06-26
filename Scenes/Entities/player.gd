extends CharacterBody2D

@export var gravity := 600
@export var terminal_gravity := 500

@export_group("Move")
@export var speed := 200
@export var acceleration := 800
@export var friction := 700
var direction := Vector2.ZERO

@export_group("Jump")
@export var jump_strength := 300
var faster_fall = false

# States
var is_falling := false



func _physics_process(delta: float) -> void:
	get_input()
	apply_movement(delta)
	apply_gravity(delta)
	
	apply_animation()


func get_input():
	
	# Horizontal Movement
	direction.x = Input.get_axis("Left", "Right")
	
	#region Jump
	if Input.is_action_just_pressed('Jump') and (is_on_floor() or $Timers/Coyot.time_left):
		velocity.y = -jump_strength
		faster_fall = false
	
	if Input.is_action_just_released("Jump") and velocity.y<0:
		faster_fall = true
	#endregion

# Applying animation based on velocity   NOTE: No jump animation played
func apply_animation():
	var state := 'Idle'
	var target_zoom := Vector2(2, 2)
	
	if direction.x:
		state = "Run"
		target_zoom = Vector2(1.3, 1.3)
		$AnimatedSprite2D.flip_h = direction.x < 0
	
	if not is_on_floor(): 
		if is_falling:
			state = "Fall"
		else:
			state = "Jump"
	
	if $Camera2D.zoom != target_zoom:
		var camera_zoom_tween := create_tween()
		camera_zoom_tween.tween_property($Camera2D, "zoom", target_zoom, 0.8)
	
	$AnimatedSprite2D.play(state)

func apply_movement(delta):
	
	#region Horizontal Movement
	# The speed the player accelerates
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x*speed, delta * acceleration)
	# The speed the player decelerates
	else:
		velocity.x = move_toward(velocity.x, 0, delta * friction)
	#endregion
	
	var was_on_floor := is_on_floor() 
	move_and_slide()
	if was_on_floor and not is_on_floor() and velocity.y>0:
		print("Coyot Timer is on")
		$Timers/Coyot.start()

func apply_gravity(delta):
	
	# Normal Gravity
	velocity.y += gravity * delta 
	
	# Faster fall only when player is jumping
	if faster_fall and velocity.y<0:
		velocity.y += gravity *  1.8 * delta
	
	velocity.y = min(velocity.y, terminal_gravity)

func dead() -> void:
	print("Player is dead")
	is_falling = true

func hit() -> void:
	dead()
