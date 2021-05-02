extends Area2D

onready var lifetime_timer = $LifetimeTimer

export (float) var VELOCITY:float = 800.0

var container
var direction:Vector2
var is_player_projectile = false

func initialize(container, spawn_position:Vector2, direction:Vector2, is_player_projectile):
	self.container = container
	container.add_child(self)
	self.direction = direction
	self.is_player_projectile = is_player_projectile
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()

func _physics_process(delta):
	position += direction * VELOCITY * delta
	
# Si supero una cantidad de tiempo de vida
func _on_lifetime_timer_timeout():
	_remove()

func _remove():
	container.remove_child(self)
	queue_free()

func _on_Projectile_body_entered(body):
	if body.has_method("notify_hit") and !is_player_projectile:
		body.notify_hit()
	if body.is_in_group("player") and !is_player_projectile:
		container.turret_hit()
	if body.is_in_group("turret") and is_player_projectile:
		container.player_hit()
		if body.has_method("hit"):
			body.hit()
