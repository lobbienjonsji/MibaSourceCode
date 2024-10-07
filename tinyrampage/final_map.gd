extends Node2D
var just_increased_count : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals._reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(get_tree().get_node_count_in_group("Towers") == 0):
		_on_victory()
		return
	elif (get_tree().get_node_count_in_group("FriendlyTowers") == 0):
		_on_defeat()
		return
	$Gold.text = "Current Gold: " + str(Globals.gold)
	if get_tree().get_node_count_in_group("PlayerCharacters") < 4 + Globals.extra_monsters &&\
	(just_increased_count or $SpawnPoint/Timer.time_left == 0):
		if	$SpawnPoint/Area2D.get_overlapping_bodies().size() == 0:
			var new_buddy = preload("res://LittleMonster.tscn").instantiate()
			add_child(new_buddy)
			new_buddy.global_position = $SpawnPoint/Area2D.global_position
			new_buddy._add_health(Globals.extra_health)
			new_buddy._add_movement_speed(Globals.extra_speed)
			new_buddy._add_attack_speed(Globals.extra_attack_speed)
			new_buddy.add_to_group("PlayerCharacters")
			new_buddy.death.connect(_play_death_sound)
			$SpawnPoint/Timer.start()
			just_increased_count = false
			
		elif $SpawnPoint/Area2D2.get_overlapping_bodies().size() == 0:
			var new_buddy = preload("res://LittleMonster.tscn").instantiate()
			add_child(new_buddy)
			new_buddy.global_position = $SpawnPoint/Area2D2.global_position
			new_buddy._add_health(Globals.extra_health)
			new_buddy._add_movement_speed(Globals.extra_speed)
			new_buddy._add_attack_speed(Globals.extra_attack_speed)
			new_buddy.add_to_group("PlayerCharacters")
			new_buddy.death.connect(_play_death_sound)
			$SpawnPoint/Timer.start()
			just_increased_count = false
	if get_tree().get_node_count_in_group("Enemies") <= 8 - get_tree().get_node_count_in_group("Towers") &&\
		($EnemySpawn/EnemyRespawnTimer.time_left == 0):
		if	$EnemySpawn/Area2D.get_overlapping_bodies().size() == 0:
			var new_enemy = preload("res://LittleEnemy.tscn").instantiate()
			new_enemy.get_target.connect(_get_path_node)
			new_enemy.die.connect(_play_death_sound)
			add_child(new_enemy)
			new_enemy.global_position = $EnemySpawn/Area2D.global_position
			new_enemy.add_to_group("Enemies")
			$EnemySpawn/EnemyRespawnTimer.start()

func _get_path_node(enemy):
	enemy._set_target_node([$TopPathNode, $MidPathNode, $BotPathNode].pick_random())

func _on_area_2d_mouse_entered() -> void:
	$Cursor/Sprite2D.visible = false

func _on_area_2d_mouse_exited() -> void:
	$Cursor/Sprite2D.visible = true


func _on_farm_timer_timeout() -> void:
	for i in $Area2D.get_overlapping_bodies():
		i._damage(2)
		Globals.gold += 5


func _on_heal_timer_timeout() -> void:
	for i in $Area2D2.get_overlapping_bodies():
		i._add_health(5)
#TODO
func _on_defeat():
	get_tree().change_scene_to_file("res://GameOverScreen.tscn")

#TODO
func _on_victory():
	Globals.is_victory = true
	get_tree().change_scene_to_file("res://GameOverScreen.tscn")
	
func _play_death_sound(i):
	match i:
		0:
			$AudioStreamPlayer2D.play()
		1:
			$AudioStreamPlayer2D2.play()
	
