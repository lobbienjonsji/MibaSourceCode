extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _select():
	$"..".add_to_group("Selected")
	
func _deselect():
	$"..".remove_from_group("Selected")
	$"../Sprite2D".visible = false
