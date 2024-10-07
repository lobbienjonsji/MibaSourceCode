extends Node2D
signal onDeath
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _damage(damage : int):
	$ProgressBar.value -= damage
	if $ProgressBar.value <= 0:
		onDeath.emit()

func _add_health(value : int, max : bool = false):
	if max:
		$ProgressBar.max_value += value
	$ProgressBar.set_value_no_signal(min($ProgressBar.value + value, $ProgressBar.max_value))

func _get_max():
	return $ProgressBar.max_value
