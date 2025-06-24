extends StaticBody2D

""" This Turrent Only shoots once, If needs to reshoot then the player should re-enter the zone """


var can_damage := false
var player: CharacterBody2D


# Playing animation, if player enters the zone
func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("Shoot")
	player = body
	can_damage = true

# If player is leaving before shooting, don't damage
func _on_area_2d_body_exited(_body: Node2D) -> void:
	if $AnimatedSprite2D.is_playing():
		can_damage = false


# If animation ends, damage the player if he is still in the zone
func _on_animated_sprite_2d_animation_finished() -> void:
	if can_damage:
		player.hit()
