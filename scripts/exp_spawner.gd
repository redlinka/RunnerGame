extends Node2D

@export var exp_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_amount: int = 1
@onready var timer: Timer = $Timer
@onready var target := get_node("/root/Main/Player")
var width := 2500
var height := 1500
var last_point_pos := Vector2(0,0)

func _ready():
	timer.wait_time = spawn_interval
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	for i in range(spawn_amount):
		spawn_exp()

func spawn_exp():
	var exp = exp_scene.instantiate()
	exp.reached_player.connect(target.got_exp)
	var spawn_points = [
	Vector2(
		int(global_position.x + width/2),
		int(global_position.y + randf_range(-height/2, height/2))
	),
	Vector2(
		int(global_position.x - width/2),
		int(global_position.y + randf_range(-height/2, height/2))
	),
	Vector2(
		int(global_position.x + randf_range(-width/2, width/2)),
		int(global_position.y - height/2)
	),
	Vector2(
		int(global_position.x + randf_range(-width/2, width/2)),
		int(global_position.y + height/2)
	),
]
	exp.global_position = spawn_points.pick_random()
	while exp.global_position.distance_to(last_point_pos) < 1000:
		exp.global_position = spawn_points.pick_random()
	last_point_pos = exp.global_position
	get_tree().current_scene.add_child(exp)
