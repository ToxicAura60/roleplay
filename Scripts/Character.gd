class_name Character
extends CharacterBody2D

var character_id: int = 1
@export var sprites: Array[AnimatedSprite2D]

var _can_move: bool = true

func _ready() -> void:
	CharacterRegistry.register(self)
	
func disable_movement():
	_can_move = false
	
func enable_movement():
	_can_move = true
	
func _physics_process(_delta: float) -> void:
	if not _can_move:
		return
		
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * 100
	move_and_slide()
	_play_movement_animation(direction)

func play_animation(anim_name: StringName) -> void:
	for sprite in sprites:
		sprite.play(anim_name)

func _play_movement_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		play_animation("idle_down")
		return

	if direction.x < 0:
		play_animation("walk_left")
	elif direction.x > 0:
		play_animation("walk_right")
	elif direction.y < 0:
		play_animation("walk_up")
	else:
		play_animation("walk_down")
