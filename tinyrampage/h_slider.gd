extends HSlider

@onready var _bus := AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_drag_ended(value_changed: bool) -> void:
	$AudioStreamPlayer2D.play()
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
