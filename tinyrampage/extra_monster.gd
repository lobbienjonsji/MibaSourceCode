extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if Globals.gold >= 1000:
		Globals.gold -= 1000
		$"..".just_increased_count = true
		Globals.extra_monsters += 1
