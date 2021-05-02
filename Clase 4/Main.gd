extends Node

export (PackedScene) var turret_scene

onready var player = $Player
onready var background := $Background
onready var turret := $Turret
onready var star_scene := preload("res://entities/collectibles/Star.tscn")

var star_position := Vector2(1900,160)
var lives:int = 5

func _ready():
	randomize()
	player.initialize(self, $StartPosition.position)
	$GoBack.initialize(self)
	turret.initialize(turret.position, player, self)
	
	initialize_turrets()
	
	var star = star_scene.instance()
	star.initialize(self)
	add_child(star)
	star.set_position(star_position)
	
	$Life.initialize(lives)
	$Music.play()
	
func initialize_turrets():
	var visible_rect:Rect2 = get_viewport().get_visible_rect()
	for i in 3:
		var turret_instance = turret_scene.instance()
		var turret_pos:Vector2 = Vector2(rand_range(visible_rect.position.x, visible_rect.end.x), rand_range(visible_rect.position.y + 30, player.global_position.y - 50))
		add_child(turret_instance)
		turret_instance.initialize(turret_pos, player, self)
		
func hit():
	if lives == 0:
		lost()
		player.bye()
	lives -= 1
	$Life.update(lives)
		
func win():
	$Music.stop()
	$Win.play()
	player.bye()
	
func lost():
	$Music.stop()
	$Lost.play()
	
func go_back():
	player.set_start_position($StartPosition.position)
	
func player_hit():
	$Win.play()
	
func turret_hit():
	$Hit.play()
