extends StaticBody2D

@onready var starting_pos := position 

# Player Entering
func _on_player_zone_body_entered(body: Node2D) -> void:
	$Timers/Break_wait.start()


func disable_platform():
	# Collision
	$CollisionShape2D.disabled = true
	# Player Entering
	$Player_zone/CollisionShape2D.disabled = true

func enable_platform():
	# Collision
	$CollisionShape2D.disabled = false
	# Player Entering
	$Player_zone/CollisionShape2D.disabled = false
	# Visiblity
	visible = true

func _on_break_wait_timeout() -> void:
	disable_platform()
	var disabling_tween = create_tween()
	disabling_tween.tween_property(self, "position", Vector2(position.x, position.y+800), 3)
	await disabling_tween.finished
	visible = false
	$Timers/Respawn.start()
	


func _on_respawn_timeout() -> void:
	enable_platform()
	position = starting_pos
	
