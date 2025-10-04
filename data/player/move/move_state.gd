extends Node
class_name PlayerMoveState

## We will assume that the player is that nodes high.
@onready var player: Player = $"../.."

## Virtual method which is called on state enter.
func _state_enter(_from: StringName) -> void: pass

## Virtual method which is called on state exit.
func _state_exit(_to: StringName) -> void: pass

## Virtual method which is called every FSM tick.
func _update(_input: PlayerInputState, _delta: float) -> void: pass

## Virtual method which checks is the state relevant to current input.
func _check_relevance(_input: PlayerInputState) -> StringName:
		push_error("Method is not implemented.")
		return &"ok"
