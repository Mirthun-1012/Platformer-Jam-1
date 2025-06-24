class_name BASE_LEVEL
extends Node2D



func _on_fall_zone_body_entered(body: Node2D) -> void:
	if "dead" in body:
		body.dead()
