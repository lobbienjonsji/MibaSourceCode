extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	var bodies = $Area2D.get_overlapping_areas()
	if not bodies.is_empty() && Input.is_action_just_released("LeftClick"):
		for i in get_tree().get_nodes_in_group("Selected"):
			i._deselect()
		for i in bodies: 
			print("selection")
			i._select()
