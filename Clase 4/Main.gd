extends Node

export (PackedScene) var turret_scene

onready var player = $Player
onready var background := $Background
onready var turret := $Turret
onready var star_scene := preload("res://entities/collectibles/Star.tscn")

var star_position := Vector2(1600,160)

func _ready():
	randomize()
	player.initialize(self)
	turret.initialize(self, turret.position, player, self)
	
	initialize_turrets()
	
	var star = star_scene.instance()
	add_child(star)
	star.set_position(star_position)
	
	$Music.play()
	

func initialize_turrets():
	var visible_rect:Rect2 = get_viewport().get_visible_rect()
	for i in 3:
		var turret_instance = turret_scene.instance()

		var turret_pos:Vector2 = Vector2(rand_range(visible_rect.position.x, visible_rect.end.x), rand_range(visible_rect.position.y + 30, player.global_position.y - 50))

		turret_instance.initialize(self, turret_pos, player, self)
