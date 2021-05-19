extends KinematicBody2D

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer
onready var raycast = $FirePosition/RayCast2D
onready var remove_anim_player = $RemoveAnimPlayer
onready var state_machine = $CatStateM

onready var body_sprite = $Body

export (PackedScene) var projectile_scene

var SPEED = 150
var GRAVITY = 10
var FLOOR = Vector2(0, -1)
var target
var projectile_container
var velocity = Vector2()
var direction = 1
var FRICTION_WEIGHT:float = 0.1
var is_walking = true
var is_firing = false

func _ready():
	state_machine.initialize(self)
	fire_timer.connect("timeout", self, "fire")
#	set_physics_process(false)

func initialize(container, turret_pos, _projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = _projectile_container

func _apply_movement():
	if is_walking:
		walk()
	if is_firing:
		fire_process()

func fire():
	if target != null:
		state_machine.set_state(state_machine.STATES.SPIT)
		var proj_instance = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))
		fire_timer.start()

func walk():
	velocity.x = SPEED * direction
	if direction == 1:
		body_sprite.flip_h = false
	else:
		body_sprite.flip_h = true
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	if is_on_wall():
		direction *= -1

func fire_process():
	body_sprite.flip_h = global_position.direction_to(target.global_position).x < 0
	raycast.set_cast_to(to_local(target.global_position))
	if raycast.is_colliding() && raycast.get_collider() == target:
		if fire_timer.is_stopped():
			fire_timer.start()
	elif !fire_timer.is_stopped():
		fire_timer.stop()

func notify_hit(_amount):
	if body_sprite.animation == "dead":
		return
	state_machine.set_state(state_machine.STATES.DEAD)
	raycast.collision_mask = 0
	yield(body_sprite,"animation_finished")
	remove_anim_player.play("remove")
	
func _play_animation(animation_name:String):
	body_sprite.play(animation_name)

func _remove():
	get_parent().remove_child(self)
	queue_free()

func _on_DetectionArea_body_entered(body):
	if target == null:
		target=body
		is_walking = false
		is_firing = true
		state_machine.set_state(state_machine.STATES.IDLE)

func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
		is_walking = true
		is_firing = false
		state_machine.set_state(state_machine.STATES.WALK)

func _on_Body_animation_finished():
	if body_sprite.animation == "spit":
		state_machine.set_state(state_machine.STATES.IDLE)
