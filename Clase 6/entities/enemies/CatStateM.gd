extends "res://entities/player/StateMachine.gd"

enum STATES {
	IDLE,
	WALK,
	SPIT,
	DEAD
}

var animations_map:Dictionary = {
	STATES.IDLE: "idle",
	STATES.WALK: "walk",
	STATES.DEAD: "dead",
	STATES.SPIT: "spit"
}

func initialize(parent):
	.initialize(parent)
	call_deferred("set_state", STATES.WALK)

func _state_logic(_delta):
	parent._apply_movement()

func _get_transition(_delta):
	return state

func _enter_state(new_state, _old_state):
	parent._play_animation(animations_map[new_state])

func _exit_state(_old_state, _new_state):
	pass
