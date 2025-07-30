extends Node2D

@export var enemy_scene: Array[PackedScene]
@export var spawn_interval: float = 2.0
@export var spawn_amount: int = 1
@onready var timer: Timer = $Timer
@onready var target = get_node("/root/Main/Player")
var width = 1920
var height = 1080

func _ready():
	timer.wait_time = spawn_interval
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	for i in range(spawn_amount):
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.pick_random().instantiate()
	enemy.hit_player.connect(target.got_hit)
	var spawn_points = [
	Vector2(
		global_position.x + width/2,
		global_position.y + randf_range(-height/2, height/2)
	),
	Vector2(
		global_position.x - width/2,
		global_position.y + randf_range(-height/2, height/2)
	),
	Vector2(
		global_position.x + randf_range(-width/2, width/2),
		global_position.y - height/2
	),
	Vector2(
		global_position.x + randf_range(-width/2, width/2),
		global_position.y + height/2
	),
]
	enemy.global_position = spawn_points.pick_random()
	get_tree().current_scene.add_child(enemy)
