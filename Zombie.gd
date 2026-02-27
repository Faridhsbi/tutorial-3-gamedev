extends CharacterBody2D

@export var speed = 75.0
@export var gravity = 550.0

@export var patrol_distance = 100.0 

var direction = 1 # 1 : kanan, -1 : kiri
var start_x = 0.0 # Variabel untuk mengingat posisi awal zombie

@onready var anim = $AnimatedSprite2D

func _ready():
	start_x = global_position.x

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if global_position.x > start_x + patrol_distance:
		direction = -1
	elif global_position.x < start_x - patrol_distance:
		direction = 1
		
	# Jika nabrak dinding beneran,  putar balik.
	if is_on_wall():
		direction *= -1

	velocity.x = direction * speed

	anim.play("walk") 
	
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false
	
	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		body.respawn()
