extends Node
class_name AudioManager
@export var musicTracks: Array[AudioStreamMP3]
@onready var keyPressStream : AudioStreamPlayer = $KeyPress
@onready var musicStream : AudioStreamPlayer = $Music

func _enter_tree():
	Global.audioManager = self
	pass
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func PlayKeyPress():
	keyPressStream.pitch_scale = randf_range(0.7,1.3)
	keyPressStream.play(0.07)
	pass

func PlayRandomMusic():
	if musicStream.playing:
		return
		
	var i = randi_range(0,musicTracks.size()-1)
	var track = musicTracks[i]
	musicStream.stream = track
	musicStream.play()
	
	pass

func SetMasterBusVolume(value:float):
	print(str("Master set to ", value))
	var bus_index = AudioServer.get_bus_index("Master")
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	pass

func SetMusicBusVolume(value:float):
	print(str("Music set to ", value))
	var bus_index = AudioServer.get_bus_index("Music")
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	pass
	
func SetSFXBusVolume(value:float):
	print(str("SFX set to ", value))
	var bus_index = AudioServer.get_bus_index("SFX")
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	pass
