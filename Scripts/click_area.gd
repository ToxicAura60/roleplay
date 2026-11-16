class_name ClickArea
extends Area2D

signal clicked

func _ready() -> void:
	input_event.connect(_on_input_event)
	
func enable() -> void:
	input_pickable = true

func disable() -> void:
	input_pickable = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		clicked.emit()
