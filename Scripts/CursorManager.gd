extends Node

func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://assets/cursors/arrow.png"), Input.CURSOR_ARROW, Vector2(0, 0))
	Input.set_custom_mouse_cursor(load("res://assets/cursors/hand.png"), Input.CURSOR_POINTING_HAND, Vector2(8, 0))
