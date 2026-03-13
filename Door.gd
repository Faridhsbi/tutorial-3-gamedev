extends StaticBody2D

@onready var sprite_closed = $SpriteClosed
@onready var sprite_open = $SpriteOpen
@onready var collision = $CollisionShape2D
@onready var crush_area = $CrushArea

@onready var open_sfx = $OpenSFX
@onready var close_sfx = $CloseSFX

var is_currently_open = false 

func _on_switch_triggered(is_open):
	if is_open and not is_currently_open:
		is_currently_open = true
		
		sprite_closed.hide()
		sprite_open.show()
		collision.set_deferred("disabled", true)
		open_sfx.play()
		
	elif not is_open and is_currently_open:
		is_currently_open = false
		
		var bodies_inside = crush_area.get_overlapping_bodies()
		for body in bodies_inside:
			if body.name == "Player":
				body.respawn()
		
		sprite_closed.show()
		sprite_open.hide()
		collision.set_deferred("disabled", false)
		close_sfx.play()
