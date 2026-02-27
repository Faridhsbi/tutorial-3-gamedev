extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().call_group("WinMenu", "show_win_screen")
