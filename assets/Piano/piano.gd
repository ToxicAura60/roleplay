extends Node2D

@onready var white_keys: HBoxContainer = $WhiteKeys
@onready var black_keys: Control = $BlackKeys

enum KeyboardType {
	KEYS_88,
	KEYS_61,
	KEYS_49
}

func _ready():
	_build_piano()
	
	
@export var black_key_texture: Texture2D
@export var black_key_pressed_texture: Texture2D
@export var white_key_texture: Texture2D
@export var white_key_pressed_texture: Texture2D

const KEYBOARD_RANGES: Dictionary = {
	KeyboardType.KEYS_88: Vector2i(21, 108),
	KeyboardType.KEYS_61: Vector2i(36, 96),
	KeyboardType.KEYS_49: Vector2i(36, 84),
}

func get_gap() -> float:
	return white_keys.get_theme_constant("separation")
	
func get_white_key_width() -> int:
	return white_key_texture.get_width() if white_key_texture else 0

func _build_piano():
	_clear_children(white_keys)
	_clear_children(black_keys)
	
	black_keys.position = white_keys.position
	
	var key_range: Vector2i = KEYBOARD_RANGES[keyboard_type]
	var black_width: float = black_key_texture.get_width()
	var white_count: int = 0
	
	for midi in range(key_range.x, key_range.y + 1):
		var note: String = NOTE_NAMES[midi % 12]
		var octave: int = floori(midi / 12.0) - 1
		var key_name: String = "%s%d" % [note, octave]
		
		if note.ends_with("s"):
			var key := _make_key(black_key_texture, black_key_pressed_texture, key_name, midi)
			
			var step: float = get_white_key_width() + get_gap()
			var gap_center: float = white_count * step - get_gap() / 2.0
			key.position.x = gap_center - black_width / 2.0
			
			black_keys.add_child(key)
		else:
			var key := _make_key(white_key_texture, white_key_pressed_texture, key_name, midi)
			white_keys.add_child(key)
			white_count += 1

@export var keyboard_type: KeyboardType = KeyboardType.KEYS_88
@export var sound_extension: String = "mp3"
const NOTE_NAMES = [
	"c", "cs", "d", "ds", "e", "f", "fs", "g", "gs", "a", "b", "bs" 
]

func _make_key(texture: Texture2D, pressed_texture: Texture2D, key_name: String, midi: int) -> TextureButton:
	var key := TextureButton.new()
	key.name = key_name
	key.texture_normal = texture
	key.texture_pressed = pressed_texture
	
	var player := AudioStreamPlayer.new()
	player.name = "Sound"
	
	key.add_child(player)
	
	return key
		
func _clear_children(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
