extends Node2D

@onready var target = get_node("/root/Main/Player")
@export var health_point: PackedScene

func _ready() -> void:
	for i in range(target.health):
		var health = health_point.instantiate()
		health.name = "Health_%d" % (i+1)
		health.position = Vector2(0,-35 * i)
		add_child(health)

func gain_health():
	var health = health_point.instantiate()
	health.name = "Health_%d" % (target.health)
	health.position = Vector2(0,-35 * target.health)
	add_child(health)

func lose_health():
	var health = get_node("Health_%d" % (target.health + 1) )
	health.queue_free()
