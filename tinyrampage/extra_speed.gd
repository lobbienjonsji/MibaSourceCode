extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if Globals.gold >= 250:
		Globals.gold -= 250
		Globals.extra_speed += 15
		get_tree().call_group("PlayerCharacters", "_add_movement_speed", 15)
