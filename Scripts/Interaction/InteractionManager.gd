extends Node

signal target_interaction_changed(interaction: Interaction)

var _target_interaction: Interaction = null
var _active_interaction: Interaction = null
var _interactions_in_range: Array[Interaction]

func register(interaction: Interaction) -> void:
	interaction.interaction_entered.connect(_on_interaction_entered)
	interaction.interaction_exited.connect(_on_interaction_exited)
	interaction.interaction_started.connect(_on_interaction_started.bind(interaction))
	interaction.interaction_ended.connect(_on_interaction_ended.bind(interaction))
	interaction.tree_exiting.connect(_on_interaction_tree_exiting.bind(interaction))

func _physics_process(_delta: float) -> void:
	if _active_interaction == null and _interactions_in_range.size() > 1:
		_refresh_target_interaction()
		
func _on_interaction_started(interaction: Interaction) -> void:
	_active_interaction = interaction
	_refresh_target_interaction()

func _on_interaction_ended(interaction: Interaction) -> void:
	if interaction != _active_interaction:
		return
	_active_interaction = null
	_refresh_target_interaction()

func _on_interaction_entered(interaction: Interaction) -> void:
	if interaction not in _interactions_in_range:
		_interactions_in_range.append(interaction)
	_refresh_target_interaction()
	
func _on_interaction_exited(interaction: Interaction) -> void:
	_interactions_in_range.erase(interaction)
	_refresh_target_interaction()
	
func _on_interaction_tree_exiting(interaction: Interaction) -> void:
	_interactions_in_range.erase(interaction)
	if interaction == _active_interaction:
		_active_interaction = null
	_refresh_target_interaction()

func _refresh_target_interaction() -> void:
	var new_target_interaction: Interaction = null
	if _active_interaction == null:
		new_target_interaction = get_closest_interaction_to_local_character()

	if new_target_interaction == _target_interaction:
		return

	_target_interaction = new_target_interaction
	target_interaction_changed.emit(_target_interaction)
	
func get_closest_interaction_to_local_character() -> Interaction:
	if _interactions_in_range.is_empty():
		return null
	if _interactions_in_range.size() == 1:
		return _interactions_in_range[0]
		
	var local_character := CharacterRegistry.get_local_character()
	if local_character == null:
		return null

	var closest: Interaction = null
	var closest_distance := INF

	for interaction in _interactions_in_range:
		var distance := local_character.global_position.distance_squared_to(interaction.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest = interaction

	return closest
	
	
	
