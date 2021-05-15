extends "res://entities/player/StateMachine.gd"

enum STATES {
	IDLE,
	WALK,
	JUMP,
	DEAD
}

var animations_map:Dictionary = {
	STATES.IDLE: "idle",
	STATES.WALK: "walk",
	STATES.JUMP: "jump",
	STATES.DEAD: "dead"
}

var jumps = 0
var max_jumps = 2

func initialize(parent):
	.initialize(parent)
	call_deferred("set_state", STATES.IDLE)

func _state_logic(delta):
	if state != STATES.DEAD:
		parent._handle_cannon_actions()
	
	if state == STATES.IDLE || state == STATES.DEAD:
		parent._handle_deacceleration()
	else:
		parent._handle_move_input()
	parent._apply_movement()

func _get_transition(delta):
	if state != STATES.DEAD && PlayerData.current_health == 0:
		parent.emit_signal("dead")
		return STATES.DEAD
	if Input.is_action_just_pressed("jump") && (parent.is_on_floor() or jumps < max_jumps) && [STATES.JUMP, STATES.IDLE, STATES.WALK].has(state):
		parent.snap_vector = Vector2.ZERO
		parent.velocity.y = -parent.jump_speed
		jumps += 1
		return STATES.JUMP
	if jumps != 0 and parent.is_on_floor():
		jumps = 0
	
	match state:
		STATES.IDLE:
			if int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")) != 0:
				return STATES.WALK
		STATES.WALK:
			if parent.move_direction == 0:
				return STATES.IDLE
		STATES.JUMP:
			if parent.is_on_floor():
				if parent.move_direction != 0:
					return STATES.WALK
				else:
					return STATES.IDLE
	
	return null

func _enter_state(new_state, old_state):
	parent._play_animation(animations_map[new_state])

func _exit_state(old_state, new_state):
	pass
