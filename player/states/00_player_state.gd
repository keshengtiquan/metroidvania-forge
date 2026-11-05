@icon("res://player/states/state.svg")
class_name PlayerState extends Node

var player: Player
var next_state: PlayerState

#region /// state references
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fail: PlayerStateFail = %Fail

#endregion

func init() -> void:
	print("init,", name)
	pass

func enter() -> void:
	print("enter,", name)
	pass

func exit() -> void:
	print("exit,", name)
	pass


func handle_input(_event: InputEvent) -> PlayerState:
	print("handle_input,", name)
	return next_state

func process(_delta: float) -> PlayerState:
	return next_state
	
func physics_process(_delta: float) -> PlayerState:
	return next_state
