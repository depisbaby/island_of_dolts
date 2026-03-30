extends Node
class_name Settings



@onready var base :Control = $base
@onready var masterSlider: HSlider =$base/AudioControl/master
@onready var musicSlider: HSlider=$base/AudioControl2/music
@onready var sfxSlider: HSlider=$base/AudioControl3/sfx
@onready var masterLabel: Label =$base/AudioControl/master_label
@onready var musicLabel: Label =$base/AudioControl2/music_label
@onready var sfxLabel: Label =$base/AudioControl3/sfx_label

var settingsOpen: bool

func _enter_tree():
	Global.settings = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	base.hide()
	settingsOpen = false
	masterSlider.value = 0.5
	_on_master_value_changed(0.5)
	musicSlider.value = 0.5
	_on_music_value_changed(0.5)
	sfxSlider.value = 0.5
	_on_sfx_value_changed(0.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("settings"):
		if settingsOpen:
			base.hide()
			settingsOpen = false
			pass
		else:
			base.show()
			settingsOpen = true
			pass
		


func _on_master_value_changed(value):
	Global.audioManager.SetMasterBusVolume(value)
	var display :int = value * 100
	masterLabel.text = str("Master volume ",display,"%" )
	pass # Replace with function body.


func _on_music_value_changed(value):
	Global.audioManager.SetMusicBusVolume(value)
	var display :int = value * 100
	musicLabel.text = str("Music volume ",display,"%" )
	pass # Replace with function body.


func _on_sfx_value_changed(value):
	Global.audioManager.SetSFXBusVolume(value)
	var display :int = value * 100
	sfxLabel.text = str("SFX volume ",display,"%" )
	pass # Replace with function body.
