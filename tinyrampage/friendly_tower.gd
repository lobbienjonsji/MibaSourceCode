extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthBar._add_health(150, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _damage(amount: int):
	$HealthBar._damage(amount)


func _on_health_bar_on_death() -> void:
	queue_free()
