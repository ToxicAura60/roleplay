class_name Interaction
extends Area2D

signal interaction_entered(interaction: Interaction)
signal interaction_exited(interaction: Interaction)
signal interaction_ended()
signal interaction_started()

@export var _icon: Sprite2D
@export var _click_area: ClickArea


func _ready():
	_icon.visible = false
	_click_area.disable()
	
	InteractionManager.register(self)
	InteractionManager.target_interaction_changed.connect(_on_target_interaction_changed)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_click_area.clicked.connect(_on_click_area_clicked)
	
func _on_target_interaction_changed(interaction: Interaction) -> void:
	if interaction == self:
		_icon.visible = true
		_click_area.enable()
	else:
		_icon.visible = false
		_click_area.disable()
	
func _on_body_entered(body: Node2D) -> void:
	if body == CharacterRegistry.get_local_character():
		interaction_entered.emit(self)

func _on_body_exited(body: Node2D) -> void:
	if body == CharacterRegistry.get_local_character():
		interaction_exited.emit(self)
	
func _on_click_area_clicked() -> void:
	interaction_started.emit()
	
	

	
	
	
