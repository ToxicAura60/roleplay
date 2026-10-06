class_name Blocker
extends StaticBody2D

func disable_collision() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	
func enable_collision() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", false)
