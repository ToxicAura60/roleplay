class_name Seat
extends Node2D

@export var _sit_position: Marker2D
@export var _exit_postion: Marker2D
@export var _animation: String

var _occupant_character_id: String = ""

func get_occupant_character_id() -> String:
	return _occupant_character_id

func get_sit_position() -> Vector2:
	return _sit_position.global_position
	
func get_exit_position() -> Vector2:
	return _exit_postion.global_position
	
func get_sit_animation() -> String:
	return _animation
		
