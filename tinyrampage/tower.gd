extends Node2D
var closest_target = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthBar.onDeath.connect(_die)
	$HealthBar._add_health(650, true)

func _physics_process(delta: float) -> void:
	closest_target = null
	for i in $AttackRange.get_overlapping_bodies():
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, i.global_position, 0b00000000_00000000_00000000_00000001, [self])
		var result = space_state.intersect_ray(query)
		if not result.is_empty() and (result["collider"].is_in_group("PlayerCharacters")):
			if closest_target == null or global_position.distance_to(closest_target.global_position) >  global_position.distance_to(result["collider"].global_position):
				closest_target = result["collider"]
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _damage(amount : int):
	$HealthBar._damage(amount)

func _die():
	queue_free()
	Globals.gold += 75


func _on_attack_timer_timeout() -> void:
	if not closest_target == null:
		$Line2D.points[1] = closest_target.global_position - $Line2D.global_position
		closest_target._damage(10)
		$Line2D.visible = true
		$Line2D/MakeInvisble.start(0.5)
		$AudioStreamPlayer2D.play()


func _on_make_invisble_timeout() -> void:
	$Line2D.visible = false
