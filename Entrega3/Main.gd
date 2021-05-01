extends Node

export (PackedScene) var turret_scene:PackedScene

onready var player = $Player
onready var turret = $Turret

func _ready():
	player.initialize(self)
	turret.initialize(self, player)
	instantiate_turret()
	instantiate_turret()

func instantiate_turret():
	var new_turret = turret_scene.instance()
	add_child(new_turret)
	new_turret.initialize(self, player)
