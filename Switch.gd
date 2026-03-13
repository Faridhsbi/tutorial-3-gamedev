extends Area2D

signal door_triggered(is_open)

@onready var sprite_normal = $SpriteNormal
@onready var sprite_pressed = $SpritePressed
@onready var timer = $Timer

@onready var ticking_sfx = $TickingSFX

var is_pressed = false

func _on_body_entered(body):
	if body.name == "Player" and not is_pressed:
		is_pressed = true
		sprite_normal.hide()
		sprite_pressed.show()
		
		emit_signal("door_triggered", true)
		timer.start()
		

		ticking_sfx.play()

func _on_timer_timeout():
	is_pressed = false
	sprite_normal.show()
	sprite_pressed.hide()
	
	emit_signal("door_triggered", false)
	
	ticking_sfx.stop()
