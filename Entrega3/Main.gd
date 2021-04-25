extends Node

onready var player = $Player
onready var turret = $Turret

func _ready():
	player.initialize(self)
	turret.initialize(self, player.position)

func set_player_position(position):
	turret.set_player_position(position)
