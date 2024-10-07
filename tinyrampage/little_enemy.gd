extends CharacterBody2D
signal get_target
signal get_second_target
signal die
var movement_speed: float = 50.0
var cur_movement_target_position: Vector2
var new_velocity : Vector2
var closest_target
var closest_in_range
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	get_target.emit(self)
	$HealthBar.onDeath.connect(_die)
	
func actor_setup():
	await get_tree().physics_frame

func set_movement_target(movement_target: Vector2):
	cur_movement_target_position = movement_target
	navigation_agent.target_position = movement_target

func _physics_process(delta: float) -> void:
	closest_target = null
	for i in $AttackRange.get_overlapping_bodies():
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, i.global_position, 0b00000000_00000000_00000000_00000001, [self])
		var result = space_state.intersect_ray(query)
		if not result.is_empty() and (result["collider"].is_in_group("PlayerCharacters") or result["collider"].is_in_group("FriendlyTowers")):
			if closest_target == null or global_position.distance_to(closest_target.global_position) >  global_position.distance_to(result["collider"].global_position):
				closest_target = result["collider"]
	if !navigation_agent.is_navigation_finished():
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var current_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		navigation_agent.set_velocity(current_velocity)
		velocity = new_velocity
		look_at(cur_movement_target_position)
	else:
		velocity = Vector2(0, 0)
		var closest = null
		for i in get_tree().get_nodes_in_group("FriendlyTowers"):
			if closest == null or global_position.distance_to(i.global_position) < global_position.distance_to(closest.global_position):
				closest = i
		if not closest == null:
			_set_target_node(closest)
	move_and_slide()

func _set_target_node(node : Node2D):
	set_movement_target(node.global_position)

func _damage(amount : int):
	$HealthBar._damage(amount)

func _die():
	die.emit(1)
	queue_free()
	Globals.gold += 50

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	new_velocity = safe_velocity


func _on_retarget_timeout() -> void:
	closest_in_range = null
	for i in $FollowRange.get_overlapping_bodies():
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, i.global_position, 0b00000000_00000000_00000000_00000001, [self])
		var result = space_state.intersect_ray(query)
		if not result.is_empty() and (result["collider"].is_in_group("PlayerCharacters")):
			if closest_in_range == null or global_position.distance_to(closest_in_range.global_position) >  global_position.distance_to(result["collider"].global_position):
				closest_in_range = result["collider"]
	if not closest_in_range == null:
		_set_target_node(closest_in_range)


func _on_attack_timer_timeout() -> void:
	if not closest_target == null:
		closest_target._damage(4)
		$AudioStreamPlayer2D.play()
	$AttackTimer.start(1.5)
