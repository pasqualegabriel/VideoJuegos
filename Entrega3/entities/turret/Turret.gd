extends Sprite

var speed = 200 #Pixeles

onready var turret_fire_position = $TurretFirePosition

export (PackedScene) var turret_projectile_scene:PackedScene

var container:Node

var player_position:Vector2

func set_player_position(new_player_position):
	player_position = new_player_position

func initialize(projectile_container, player_start_position):
	container = projectile_container
	player_position = player_start_position

func _fire():
	var new_projectile = turret_projectile_scene.instance()
	container.add_child(new_projectile)
	var fire_direction = (player_position - global_position).normalized()
	var initial_direction = turret_fire_position.global_position
	new_projectile.initialize(fire_direction, initial_direction)

func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		_fire()
