extends AnimatedSprite2D

func _ready() -> void:
	var animations := ["1", "2", "3"]

	while true:
		for animation_name in animations:
			play(animation_name)

			await animation_finished
			await get_tree().create_timer(2.0).timeout

	
