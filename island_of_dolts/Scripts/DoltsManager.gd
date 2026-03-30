extends Node
class_name DoltsManager

@export var doltPackedScenes: Array[PackedScene]
var aiDolts: Array[Dolt]
var priorityQueue: Array[Dolt]

func _enter_tree():
	Global.doltsManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func SpawnDolt(id:int, x:int, y:int) -> Dolt:
	var dolt :Dolt= doltPackedScenes[id].instantiate()
	add_child(dolt)
	dolt.MoveTo(x,y)
	aiDolts.push_back(dolt)
	return dolt
	pass
	
func SpawnPlayer(x:int, y:int) -> Dolt:
	var dolt :Dolt= doltPackedScenes[0].instantiate()
	add_child(dolt)
	dolt.MoveTo(x,y)
	dolt.isPlayer = true
	return dolt
	pass
	
func NewGame():
	#spawn fauna
	var i = Global.gameManager.random.randi_range(50,100)
	for deer in i:
		SpawnDolt(1,Global.gameManager.random.randi_range(10,Global.gridManager.mapSize-10),Global.gameManager.random.randi_range(10,Global.gridManager.mapSize-10))
		pass
	pass
