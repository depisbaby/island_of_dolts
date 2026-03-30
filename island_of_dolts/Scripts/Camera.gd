extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vector:Vector2
	if Input.is_action_pressed("up"):
		vector = vector + Vector2(0,-1)
	if Input.is_action_pressed("right"):
		vector = vector + Vector2(1,0)
	if Input.is_action_pressed("down"):
		vector = vector + Vector2(0,1)
	if Input.is_action_pressed("left"):
		vector = vector + Vector2(-1,0)
	
	global_position = global_position+vector
	pass
