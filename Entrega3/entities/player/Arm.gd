extends Sprite

onready var fire_position = $FirePosition

export (PackedScene) var projectile_scene:PackedScene

var container:Node

func _fire():
	var new_projectile = projectile_scene.instance()
	container.add_child(new_projectile)
	new_projectile.initialize((fire_position.global_position - global_position).normalized(), fire_position.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
