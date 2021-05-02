extends StaticBody2D

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer

export (PackedScene) var projectile_scene

var target
var projectile_container
var hit_pos
var can_shoot = true
var player_on_zone = false
var laser_color = Color.red

func _ready():
	add_to_group("turret")
	
func initialize(turret_pos, player, container):
	self.target = player
	if !container.has_node(self.get_path()):
		container.add_child(self) 
	global_position = turret_pos
	self.projectile_container = container
	fire_timer.connect("timeout", self, "can_shoot")

func fire_at_player():
	var proj_instance = projectile_scene.instance()
	proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position), false)

func _on_Area2D_body_entered(body):
	if body == target:
		player_on_zone = true
		can_shoot = true

func _on_Area2D_body_exited(body):
	if body.has_method("notify_hit"):
		fire_timer.stop()
	if body == target:
		player_on_zone = false
		can_shoot = false
		
func _physics_process(delta):
	update()
	if is_instance_valid(target):
		aim()
		
func hit():
	projectile_container.remove_child(self)
	queue_free()

func aim():
	var space_state = get_world_2d().direct_space_state
	var pos = target.position
	var result = space_state.intersect_ray(position, pos, [self], collision_mask)
	if result:
		hit_pos = result.position
		if result.collider.name == "Player" and can_shoot:
			shoot(pos)

func shoot(pos):
	fire_at_player()
	can_shoot = false
	$FireTimer.start()

func _draw():
	if target and player_on_zone:
		draw_circle((hit_pos - position).rotated(-rotation), 5, laser_color)
		draw_line(Vector2(), (hit_pos - position).rotated(-rotation), laser_color)
		
func can_shoot():
	can_shoot = true

func _on_Visibility_body_entered(body):
	if !target:
		target = body

func _on_Visibility_body_exited(body):
	if body == target:
		target = null

func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	if body == target:
		can_shoot = true
