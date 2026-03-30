extends TextureRect
class_name	DriftingTexture

@export var drift_speed: float = 15.0
@export var max_distance: float = 10.0
@export var direction_change_time: float = 1.5

var origin: Vector2
var drift_direction: Vector2
var timer: float = 0.0

func init():
	origin = position
	randomize()
	drift_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()

func _process(delta):
	timer -= delta

	# occasionally change drift direction
	if timer <= 0:
		drift_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
		timer = direction_change_time

	# move
	position += drift_direction * drift_speed * delta

	# keep within radius
	var offset = position - origin
	if offset.length() > max_distance:
		position = origin + offset.normalized() * max_distance
