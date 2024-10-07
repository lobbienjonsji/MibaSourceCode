extends Node2D
var movement_target_position: Vector2 = Vector2(60.0,180.0)
var selected: Node
var extra_health: int = 0
var extra_speed: int = 0
var extra_attack_speed: float = 0
var gold : int = 10000
var extra_monsters: int = 0
var is_victory = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("LeftClick") or Input.is_action_just_pressed("LeftClick")):
		movement_target_position = $".".get_global_mouse_position()

func _reset():
	extra_health = 0
	extra_speed = 0
	extra_attack_speed = 0
	gold = 0
	extra_monsters = 0
	is_victory = false
