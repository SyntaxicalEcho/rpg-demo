extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", func():
		get_tree().change_scene_to_file("res://Main Menu.tscn"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass