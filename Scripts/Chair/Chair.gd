class_name Chair
extends Node2D

@export var _interaction: Interaction
@export var _seats: Seats

func _ready() -> void:
	_interaction.interaction_started.connect(_on_interaction_started)

func _on_interaction_started():
	var character = CharacterRegistry.get_local_character()
	_sit(character.character_id)
	
func _sit(character_id: int) -> void:
	if multiplayer.is_server():
		_server_sit(character_id)
	else:
		_request_sit.rpc_id(1, character_id)
	
@rpc("any_peer", "reliable")
func _request_sit(character_id: int) -> void:
	_server_sit(character_id)
	
func _server_sit(character_id: int) -> void:
	var seat_index = _seats.get_closest_free_seat_index()
	if seat_index == -1:
		return
	_client_sit.rpc_id(character_id, seat_index)
	
@rpc("authority", "reliable", "call_local")
func _client_sit(seat_index: int) -> void:
	var character = CharacterRegistry.get_character(multiplayer.get_unique_id())
	var seat = _seats.get_seat_by_index(seat_index)
	character.disable_movement()
	character.global_position = seat.get_sit_position()
	character.play_animation(seat.get_sit_animation())


func _leave(character_id: int):
	if multiplayer.is_server():
		_request_leave(character_id)
	else:
		_request_leave.rpc_id(1, character_id)
	
	
@rpc("any_peer", "reliable")
func _request_leave(character_id: int) -> void:
	_server_leave(character_id)

func _server_leave(character_id: int) -> void:
	var seat_index = _seats.get_seat_index_by_character_id(character_id)
	if seat_index == -1:
		return
	_client_leave.rpc_id(character_id, seat_index)
	
@rpc("authority", "reliable")
func _client_leave(seat_index: int) -> void:
	var character = CharacterRegistry.get_character(multiplayer.get_unique_id())
	var exit_position = _seats.get_exit_position_by_seat_index(seat_index)
	character.global_position = exit_position
	
