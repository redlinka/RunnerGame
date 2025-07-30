extends CharacterBody2D

# ready the game over screen
@onready var game_over_scene = preload("res://scenes/GameOver.tscn")

# movement related variables
@export var speed := 1000
@export var dash_factor := 40
@export var max_dashes := 2
@export var dashes := 2
@export var dash_interval := 5.0

#health related variables
@export var max_health := 3
@export var health := 3

# score and experience related variables
@export var level := 0
var current_exp := 0
var score := 0
var exp_needed := int(3 * (level + 1))

var base_scale = Vector2(1, 1) # default scale

func get_input() -> Vector2:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var acceleration = input_direction * speed + -velocity
	if Input.is_action_just_pressed("dash"):
		if dashes > 0:
			acceleration = dash(acceleration, input_direction)
	return acceleration

func _physics_process(delta: float) -> void:
	velocity += get_input() * delta
	var current_speed = velocity.length()
	move_and_collide(velocity * delta)
	
	update_visuals(current_speed)

func dash(a: Vector2, i: Vector2) -> Vector2:
	a = i * (dash_factor * speed) - velocity
	dashes -= 1
	$UI/DashBar.lose_dash()
	start_dash_cooldown()
	return a

func start_dash_cooldown() -> void:
	var timer = get_tree().create_timer(dash_interval)
	await timer.timeout
	regen_dash()

func regen_dash() -> void:
	dashes = min(dashes + 1, max_dashes)
	$UI/DashBar.gain_dash()

func got_hit() -> void:
	if health > 1:
		health -= 1
		$UI/HealthBar.lose_health()
	else:
		get_tree().change_scene_to_packed(game_over_scene)

func got_exp() -> void:
	current_exp += 1
	score += 1
	if current_exp == exp_needed:
		current_exp = 0
		level += 1
		exp_needed = int(3 * (level + 1))
		$UI/Xp_bar/filled.scale.x = 1
	else:
		$UI/Xp_bar/filled.scale.x += int(1920 / exp_needed)
	$UI/ScoreCounter.text = "SCORE : %d" % score
	
func update_visuals(s: float) -> void:
	var stretch = clamp(s / 830, 1, 1.3)
	$HitBox.rotation = velocity.angle() + deg_to_rad(90)
	$HitBox.scale.x = base_scale.x / (stretch * 1.3)
	$HitBox.scale.y = base_scale.y * stretch
	$Visual.rotation = velocity.angle() + deg_to_rad(90)
	$Visual.scale.x = base_scale.x / (stretch * 1.3)
	$Visual.scale.y = base_scale.y * stretch
