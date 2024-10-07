extends CharacterBody2D

signal death(sound : int)
var movement_speed: float = 50.0
var attack_speed: float = 0.75
var cur_movement_target_position: Vector2
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var selection = false
var targets = []
var released_last_frame = false
var new_velocity = 0.0

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	$Sprite2D.visible = false
	$AttackTimer.start(randf_range(0.1, 1.1))

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(Globals.movement_target_position)

func set_movement_target(movement_target: Vector2):
	cur_movement_target_position = movement_target
	navigation_agent.target_position = movement_target

func _physics_process(delta: float) -> void:
	if released_last_frame:
		released_last_frame = false
		if is_in_group("Selected"):
			set_movement_target(Globals.movement_target_position)
	if Input.is_action_just_released("LeftClick"):
		released_last_frame = true
	if not navigation_agent.is_navigation_finished():
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var current_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		navigation_agent.set_velocity(current_velocity)
		velocity = new_velocity
		look_at(cur_movement_target_position)
	else:
		velocity = Vector2(0, 0)
	targets.clear()
	for i in $AttackArea.get_overlapping_bodies():
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, i.global_position, 0b00000000_00000000_00000000_00000001, [self])
		var result = space_state.intersect_ray(query)
		if not result.is_empty() and (result["collider"].is_in_group("Enemies") or result["collider"].is_in_group("Towers")):
			targets.append(result["collider"])
	move_and_slide()


func _on_selection_area_entered(area: Area2D) -> void:
	$Sprite2D.visible = true

func _on_selection_area_exited(area: Area2D) -> void:
	if 	not self in get_tree().get_nodes_in_group("Selected"):
		$Sprite2D.visible = false

func _deselect():
	$Selection._deselect()

func _add_health(value : int, max : bool = false):
	$HealthBar._add_health(value, max)

func _add_movement_speed(value : int):
	movement_speed += value

func _add_attack_speed(value : float):
	attack_speed += value

func _mass_heal():
	_add_health($HealthBar._get_max()/2)

func _on_attack_timer_timeout() -> void:
	$AttackTimer.start(1/attack_speed)
	if not targets.is_empty():
		_attack()

func _attack():
	$Attack.visible = true
	for i in targets:
		i._damage(5)
	$AttackVisTimer.start(0.2)
	$AudioStreamPlayer2D.play()

func _on_attack_vis_timer_timeout() -> void:
	$Attack.visible = false

func _damage(amount : int):
	$HealthBar._damage(amount)

func _die():
	death.emit(0)
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	new_velocity = safe_velocity