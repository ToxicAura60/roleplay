extends Control

@export var brush_color: Color = Color.BLACK
@export var brush_width: float = 5.0
@export var multiplayer_spawner: MultiplayerSpawner

var _current_strokes: Dictionary[int, Line2D] = {}
var _is_drawing: bool = false


func _ready() -> void:
	multiplayer_spawner.spawn_function = _spawn_line

func set_color(color: Color) -> void:
	brush_color = color

func _spawn_line(data: Dictionary) -> Line2D:
	var line := Line2D.new()

	line.points = data["points"]
	line.default_color = data["color"]
	line.width = data["width"]

	line.antialiased = true
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.joint_mode = Line2D.LINE_JOINT_ROUND

	var synchronizer := MultiplayerSynchronizer.new()
	synchronizer.name = "MultiplayerSynchronizer"
	synchronizer.root_path = NodePath("..")

	var config := SceneReplicationConfig.new()

	config.add_property(".:points")
	config.property_set_replication_mode(
		".:points",
		SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE
	)
	
	config.add_property(".:default_color")
	config.property_set_replication_mode(
		".:default_color",
		SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE
	)
	
	config.add_property(".:width")
	config.property_set_replication_mode(
		".:width",
		SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE
	)

	synchronizer.replication_config = config

	line.add_child(synchronizer)

	return line


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return

		if event.pressed:
			_is_drawing = true

			_start_drawing(
				event.position,
				brush_color,
				brush_width
			)

		else:
			if _is_drawing:
				_is_drawing = false
				_stop_drawing()

	elif event is InputEventMouseMotion:
		if _is_drawing:
			_draw_point(event.position)


func _start_drawing(
	point: Vector2,
	color: Color,
	width: float
) -> void:
	if multiplayer.is_server():
		_server_start_drawing(
			multiplayer.get_unique_id(),
			point,
			color,
			width
		)
	else:
		_request_start_drawing.rpc_id(
			1,
			point,
			color,
			width
		)


func _draw_point(point: Vector2) -> void:
	if multiplayer.is_server():
		_server_draw_point(
			multiplayer.get_unique_id(),
			point
		)
	else:
		_request_draw_point.rpc_id(
			1,
			point
		)


func _stop_drawing() -> void:
	if multiplayer.is_server():
		_server_stop_drawing(
			multiplayer.get_unique_id()
		)
	else:
		_request_stop_drawing.rpc_id(1)


@rpc("any_peer", "call_remote", "reliable")
func _request_start_drawing(
	point: Vector2,
	color: Color,
	width: float
) -> void:
	if not multiplayer.is_server():
		return

	var peer_id := multiplayer.get_remote_sender_id()

	_server_start_drawing(
		peer_id,
		point,
		color,
		width
	)


@rpc("any_peer", "call_remote", "reliable")
func _request_draw_point(point: Vector2) -> void:
	if not multiplayer.is_server():
		return

	var peer_id := multiplayer.get_remote_sender_id()

	_server_draw_point(
		peer_id,
		point
	)


@rpc("any_peer", "call_remote", "reliable")
func _request_stop_drawing() -> void:
	if not multiplayer.is_server():
		return

	var peer_id := multiplayer.get_remote_sender_id()

	_server_stop_drawing(peer_id)


func _server_start_drawing(
	peer_id: int,
	point: Vector2,
	color: Color,
	width: float
) -> void:
	if not multiplayer.is_server():
		return

	if _current_strokes.has(peer_id):
		_current_strokes.erase(peer_id)

	var line := multiplayer_spawner.spawn({
		"points": PackedVector2Array([point]),
		"color": color,
		"width": width
	}) as Line2D

	_current_strokes[peer_id] = line


func _server_draw_point(
	peer_id: int,
	point: Vector2
) -> void:
	if not multiplayer.is_server():
		return

	if not _current_strokes.has(peer_id):
		return

	var line := _current_strokes[peer_id]

	line.add_point(point)


func _server_stop_drawing(peer_id: int) -> void:
	if not multiplayer.is_server():
		return

	if not _current_strokes.has(peer_id):
		return

	_current_strokes.erase(peer_id)
