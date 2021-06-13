extends Camera2D

onready var anim_player = $AnimationPlayer

func _on_Player_ice_started():
	anim_player.play("shake")

func _on_Player_ice_stopped():
	anim_player.stop()
