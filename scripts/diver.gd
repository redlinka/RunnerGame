extends CharacterBody2D

@export var speed := 4700
@export var friction = 1.5
@export var aim_time := 1.1
@export var dash_time := 0.3
var can_aim := true
var is_dashing := false

var target : Node2D
var base_scale = Vector2(1, 1)

signal hit_player

func _ready():
	target = get_parent().get_node("Player")
	$timer.timeout.connect(cooldown)
	$timer.wait_time = aim_time
	$timer.start()

func cooldown():
	if can_aim:
		can_aim = false
		is_dashing = true
		$timer.wait_time = dash_time
		$timer.start()
	else:
		can_aim = true
		is_dashing = false
		$timer.wait_time = aim_time
		$timer.start()

func _physics_process(delta: float) -> void:
	if target:
		var distance = target.position.distance_to(position)
		var direction = (target.position - position).normalized()
		var current_speed = velocity.length()
		
		update_visuals(current_speed, direction)
		  
		if is_dashing:
			var acceleration = direction * speed - velocity * friction
			velocity += acceleration * delta
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * 500 * delta)
			
		var collision = move_and_collide(velocity * delta)
		if collision and collision.get_collider() is CharacterBody2D:
			var other = collision.get_collider()
			if other.name == "Player":
				queue_free()
				emit_signal("hit_player")

func update_visuals(s: float, dir: Vector2) -> void:
	var stretch = clamp(s / 700, 1, 1.5)
	$HitBox.rotation = dir.angle() + deg_to_rad(90)
	$Visual.rotation = dir.angle() + deg_to_rad(90)
	$HitBox.scale.x = base_scale.x / stretch
	$HitBox.scale.y = base_scale.y * stretch
	$Visual.scale.x = base_scale.x / stretch
	$Visual.scale.y = base_scale.y * stretch
