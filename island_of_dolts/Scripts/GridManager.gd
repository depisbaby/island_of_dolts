extends Node
class_name GridManager

@export var mapSize: int
@export var spacing: int
@export var gridNodePackedScene: PackedScene
@export var groundSprites: Array[Texture2D]
@export var blockPackedScenes: Array[PackedScene]
var grid: Array[GridNode]
var inited:bool
var blockChanges : BlockChange


func _enter_tree():
	Global.gridManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GenerateIsland():
	
	
	var waterNoise:FastNoiseLite = FastNoiseLite.new()
	waterNoise.noise_type = FastNoiseLite.TYPE_PERLIN
	waterNoise.offset = Vector3(Global.gameManager.random.randf(),Global.gameManager.random.randf(),Global.gameManager.random.randf())
	waterNoise.frequency = 0.1
	
	var rockNoise:FastNoiseLite = FastNoiseLite.new()
	rockNoise.noise_type = FastNoiseLite.TYPE_PERLIN
	rockNoise.offset = Vector3(Global.gameManager.random.randf(),Global.gameManager.random.randf(),Global.gameManager.random.randf())
	rockNoise.frequency = 0.1
	
	var treeNoise:FastNoiseLite = FastNoiseLite.new()
	rockNoise.noise_type = FastNoiseLite.TYPE_PERLIN
	rockNoise.offset = Vector3(Global.gameManager.random.randf(),Global.gameManager.random.randf(),Global.gameManager.random.randf())
	rockNoise.frequency = 0.1
	
	
	for y in mapSize:
		for x in mapSize:
			var node : GridNode = gridNodePackedScene.instantiate()
			add_child(node)
			grid.push_back(node)
			node.xPos = x
			node.yPos = y
			
			#add bodies of water
			if waterNoise.get_noise_2d(x,y)*GetCoastModifier(x)*GetCoastModifier(y) > 0.1:
				node.SetWater()
				continue
				pass
			
			#add rocks
			if rockNoise.get_noise_2d(x,y) > 0.1:
				PlaceBlock(0,x,y,false)
			
			#add trees
			var rng = Global.gameManager.random.randf() - 0.5
			if rng > treeNoise.get_noise_2d(x,y):
				if GetNodeAt(x,y).block == null:
					PlaceBlock(1,x,y,false)
			
	
	inited = true
	pass
	
func GetNodeAt(x:int, y:int) -> GridNode:
	if x < 0 || x >= mapSize:
		return null
	if y < 0 || y >= mapSize:
		return null
	var i = x+y*mapSize
	return grid[i]
	pass

func PlaceBlock(id:int, x:int, y:int, makeBlockChange: bool):
	var node = GetNodeAt(x,y)
	if node == null:
		return
	
	var block:Block = blockPackedScenes[id].instantiate()
	add_child(block)
	node.block = block
	
	if makeBlockChange:
		MakeABlockChange(id,Vector2(x,y))
	
	pass

func GetCoastModifier(input:int)->float:
	var coastLength:float = 10.0
	var step:float = 1.0/coastLength
	if input > mapSize/2:
		var distance = mapSize - input
		return clampf(distance * step,0.0,1.0)
	else:
		var distance = input
		return clampf(distance * step,0.0,1.0)
	pass

func MakeABlockChange(blockId:int, position:Vector2): #no block
	var blockChange:BlockChange = BlockChange.new()
	Global.saveManager.saveData.blockChanges.push_front(blockChange)
	pass

func GetNodeFromPosition(position:Vector2, direction:Vector2, steps:int)->GridNode:
	var _position:Vector2 = position + direction * steps
	return GetNodeAt(_position.x, _position.y)
	pass

	

		
			
