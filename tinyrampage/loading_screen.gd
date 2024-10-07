extends Node2D

var sname
var progress = []
var status

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sname = "res://FinalMap.tscn"
	ResourceLoader.load_threaded_request(sname)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	status = ResourceLoader.load_threaded_get_status(sname, progress)
	$ProgressBar.value = floor(progress[0] * 100)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(sname))
