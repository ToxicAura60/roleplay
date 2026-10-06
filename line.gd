extends Node2D

@onready var _line: Line2D = $Line2D

var points: PackedVector2Array = PackedVector2Array():
	set(value):
		points = value

		if is_node_ready():
			_line.points = value


var brush_color: Color = Color.BLACK:
	set(value):
		brush_color = value

		if is_node_ready():
			_line.default_color = value


var brush_width: float = 5.0:
	set(value):
		brush_width = value

		if is_node_ready():
			_line.width = value


func _ready() -> void:
	_line.points = points
	
	_line.default_color = brush_color
	_line.width = brush_width

	_line.antialiased = true
	_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	_line.joint_mode = Line2D.LINE_JOINT_ROUND

func add_point(point: Vector2) -> void:
	var new_points := points
	new_points.append(point)
	points = new_points

func set_brush_color(color: Color) -> void:
	brush_color = color

func set_brush_width(width: float) -> void:
	brush_width = width
