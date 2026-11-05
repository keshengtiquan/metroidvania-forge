class_name PlayerStateIdle extends PlayerState
#region /// state references

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
	if _event.is_action_pressed("jump"):
		return jump
	return next_state

func process(_delta: float) -> PlayerState:
	if player.direction.x != 0:
		return run
	return next_state
	
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fail
	return next_state
