extends Node

var _characters: Dictionary[int, Character] = {}

func register(character: Character) -> void:
	_characters[character.character_id] = character
	
func unregister(character_id: int) -> void:
	_characters.erase(character_id)

func get_character(character_id: int) -> Character:
	return _characters.get(character_id)

func has_character(character_id: int) -> bool:
	return _characters.has(character_id)
	
func get_local_character() -> Character:
	return _characters[multiplayer.get_unique_id()]
