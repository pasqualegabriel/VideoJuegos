extends AnimatedSprite

onready var area := $Area2D

var container

func initialize(container):
	self.container = container

func _ready():
	scale = Vector2(0.25,0.25)
	area.connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		container.win()
		Global.level_passed()
