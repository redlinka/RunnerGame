extends Node2D
@onready var target = get_node("/root/Main/Player")
@export var dash_point: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(target.dashes):
		var dash = dash_point.instantiate()
		dash.name = "Dash_%d" % (i+1)
		dash.position = Vector2(0,-35 * i)
		add_child(dash)

func gain_dash():
	var dash = dash_point.instantiate()
	dash.name = "Dash_%d" % (target.dashes)
	dash.position = Vector2(0,-35 * (target.dashes - 1))
	add_child(dash)

func lose_dash():
	var dash = get_node("Dash_%d" % (target.dashes + 1) )
	dash.queue_free()
