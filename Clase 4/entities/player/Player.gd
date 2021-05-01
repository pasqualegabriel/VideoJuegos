extends KinematicBody2D

onready var cannon = $Cannon

const FLOOR_NORMAL := Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION := Vector2.UP
const SNAP_LENGHT := 32.0
const SLOPE_THRESHOLD := deg2rad(46)

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity:float = 10
export (int) var jump_speed:float = 650

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT
var projectile_container
var hits = 0

func initialize(projectile_container):
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container

func get_input():
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()
		
	# Jump action
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_speed
		
	# Horizontal speed
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	
	var mouse_position:Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)

func _physics_process(delta):
	get_input()
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR_NORMAL)	
	
func notify_hit():
	hits += 1
	print("ouch " + str(hits))
	projectile_container.hit()
	
func _ready():
	add_to_group("player")
	
func bye():
	projectile_container.remove_child(self)
	queue_free()
