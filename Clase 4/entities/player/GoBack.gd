extends Area2D

var container

func initialize(container):
	self.container = container

func _on_GoBack_body_entered(body):
	if body.is_in_group("player"):
		container.go_back()
