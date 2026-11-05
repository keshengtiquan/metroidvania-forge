class_name PlayerStateCrouch extends PlayerState

@export var deceleration_rate: float = 10

func init() -> void:
	pass

func enter() -> void:
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.sprite.scale.y = 0.625
	player.sprite.position.y = -15
	pass

func exit() -> void:
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	player.sprite.position.y = -24
	player.sprite.scale.y = 1
	pass


func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		if player.one_way_platform_ray_cast.is_colliding() == true:
			player.position.y += 4
			return fail
		return jump
	return next_state

func process(_delta: float) -> PlayerState:
	if player.direction.y <= 0.5:
		return idle
	return next_state
	
func physics_process(delta: float) -> PlayerState:
	player.velocity.x -= player.velocity.x * deceleration_rate * delta
	if player.is_on_floor() == false:
		return fail
	return next_state
