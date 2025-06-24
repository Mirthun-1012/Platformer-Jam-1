extends StaticBody2D



func _on_damage_zone_body_entered(body: Node2D) -> void:
	body.hit()
