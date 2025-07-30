extends CharacterBody2D

@export var speed := 1200
@export var friction = 1.0
var target : Node2D
var base_scale = Vector2(1, 1) # default scale
signal hit_player

func _ready():
	target = get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	var direction = (target.position - position).normalized()
	var acceleration = direction * speed - velocity * friction
	var current_speed = velocity.length()
	
	update_visuals(current_speed)
	
	velocity += acceleration * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision and collision.get_collider() is CharacterBody2D:
			var other = collision.get_collider()
			if other.name == "Player":
				queue_free()
				emit_signal("hit_player")

func update_visuals(s: float) -> void:
	var stretch = clamp(s / 700, 1, 1.5)
	$HitBox.rotation = velocity.angle() + deg_to_rad(90)
	$HitBox.scale.x = base_scale.x / stretch
	$HitBox.scale.y = base_scale.y * stretch
	$Visual.rotation = velocity.angle() + deg_to_rad(90)
	$Visual.scale.x = base_scale.x / stretch
	$Visual.scale.y = base_scale.y * stretch
