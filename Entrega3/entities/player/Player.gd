extends Sprite

onready var arm = $Arm

var speed = 200 #Pixeles

var container:Node

func initialize(projectile_container):
	container = projectile_container
	arm.container = projectile_container
	
func _physics_process(delta):
	var mouse_position:Vector2 = get_local_mouse_position()
	arm.rotation = mouse_position.normalized().angle() #deg2rad(90)
	if Input.is_action_just_pressed("fire"):
		arm._fire()
	
	var right := Input.is_action_pressed("move_right")
	var left := Input.is_action_pressed("move_left")
	var direction_optimized:int = int(right) - int(left)
	
	position.x += direction_optimized * speed * delta
	
	if right or left:
		container.set_player_position(position)
