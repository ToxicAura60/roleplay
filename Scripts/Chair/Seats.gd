class_name Seats
extends Node2D

@export var _seats: Array[Seat]

func get_seat_index_by_character_id(character_id: int) -> int:
	for i in _seats.size():
		if _seats[i].character_id == character_id:
			return i
	
	return -1
	
func get_seat_by_index(index: int) -> Seat:
	return _seats[index]

func get_closest_free_seat_index() -> int:
	var closest_index: int = -1
	var closest_distance: float = INF

	for i in range(_seats.size()):
		var seat: Seat = _seats[i]

		if not seat.get_occupant_character_id().is_empty():
			continue

		var distance := global_position.distance_to(seat.global_position)

		if distance < closest_distance:
			closest_distance = distance
			closest_index = i

	return closest_index
	
	
