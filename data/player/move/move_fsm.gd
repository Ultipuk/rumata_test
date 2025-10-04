extends Node
class_name PlayerMoveFSM

signal state_changed(state_name: StringName)

@export var init_state: PlayerMoveState

var current_state: PlayerMoveState
var previous_state_name: StringName


func _ready() -> void:
		if init_state == null: push_error("Initial state is not set.")

		previous_state_name = init_state.name
		current_state = init_state
		current_state._state_enter(previous_state_name)

		state_changed.emit(init_state.name)


func update(input_state: PlayerInputState, delta: float) -> void:
		var relevance := current_state._check_relevance(input_state)
		if relevance != &"ok": to(relevance)
		current_state._update(input_state, delta)


## Jump to new `MoveState`.
func to(state_name: StringName) -> void:
		var new_state: PlayerMoveState = get_node(state_name as String)

		current_state._state_exit(state_name)
		current_state = new_state
		current_state._state_enter(previous_state_name)
		previous_state_name = current_state.name

		state_changed.emit(new_state.name)
