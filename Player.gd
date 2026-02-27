extends CharacterBody2D

@export var gravity = 550.0
@export var walk_speed = 200.0
@export var jump_speed = -320.0
@export var dash_speed = 300.0
@export var crouch_speed = 80.0

var jump_count = 0
var max_jumps = 2

var is_dashing = false
var dash_timer = 0.0
var dash_duration = 0.2
var dash_direction = 1
var last_left_tap = 0
var last_right_tap = 0
var double_tap_window = 250 

var is_crouching = false

var spawn_point = Vector2.ZERO

@onready var anim = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

func _ready():
	spawn_point = global_position

func _physics_process(delta):
	if not is_on_floor() and not is_dashing:
		velocity.y += delta * gravity

	if is_on_floor():
		jump_count = 0

	# DOUBLE JUMP
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_speed
		jump_count += 1

	#  DASHING 
	if Input.is_action_just_pressed("ui_right"):
		if Time.get_ticks_msec() - last_right_tap < double_tap_window:
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = 1
		last_right_tap = Time.get_ticks_msec()

	if Input.is_action_just_pressed("ui_left"):
		if Time.get_ticks_msec() - last_left_tap < double_tap_window:
			is_dashing = true
			dash_timer = dash_duration
			dash_direction = -1
		last_left_tap = Time.get_ticks_msec()

	if is_dashing:
		anim.play("dash")
		dash_timer -= delta
		velocity.y = 0 
		velocity.x = dash_direction * dash_speed
		
		if dash_timer <= 0:
			is_dashing = false
	else:
		# CROUCHING & NORMAL MOVEMENT
		var current_speed = walk_speed
		is_crouching = false # Selalu reset status jongkok setiap frame
		
		if Input.is_action_pressed("ui_down") and is_on_floor():
			is_crouching = true
			current_speed = crouch_speed

		if Input.is_action_pressed("ui_left"):
			velocity.x = -current_speed
		elif Input.is_action_pressed("ui_right"):
			velocity.x = current_speed
		else:
			velocity.x = 0

	if not is_dashing:
		if is_crouching:
			anim.play("crouch")
			if velocity.x != 0: 
				anim.flip_h = velocity.x < 0
		elif velocity.x != 0: 
			anim.play("walk")
			anim.flip_h = velocity.x < 0 
		else:
			anim.play("idle")
	
	if not is_on_floor() and not is_dashing: 
		anim.play("jump")

	move_and_slide()

func respawn():
	global_position = spawn_point
	velocity = Vector2.ZERO #
