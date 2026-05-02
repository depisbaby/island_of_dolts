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
	
	if !dolt.MoveTo(x,y):
		dolt.queue_free()
		return
		
	aiDolts.push_back(dolt)
	dolt.health = dolt.maxHealth
	return dolt
	pass

func InitialSpawnDolt(id:int, x:int, y:int) -> Dolt:
	var dolt :Dolt = SpawnDolt(id,x,y)
	dolt.OnInitialSpawn()
	return dolt
	pass
	

func DespawnDolt(dolt:Dolt):
	aiDolts.erase(dolt)
	priorityQueue.erase(dolt)
	pass
	
func SpawnPlayer(x:int, y:int) -> Dolt:
	var dolt :Dolt= doltPackedScenes[0].instantiate()
	add_child(dolt)
	dolt.MoveTo(x,y)
	dolt.isPlayer = true
	dolt.health = dolt.maxHealth
	return dolt
	pass
	
func NewGame():
	#spawn deers
	var i = Global.gameManager.random.randi_range(50,100)
	for deer in i:
		InitialSpawnDolt(1,Global.gameManager.random.randi_range(10,Global.gridManager.mapSize-10),Global.gameManager.random.randi_range(10,Global.gridManager.mapSize-10))
		pass
	pass
	
func SaveDolts(saveData: SaveData):
	saveData.aiDoltsInGame.clear()
	saveData.itemsInGame.clear()
	var ownerId:int = 0
	
	#save player items
	for item in Global.gameManager.player.items:
			item.ownerId = 0
			var packedItem :PackedScene = PackedScene.new()
			packedItem.pack(item)
			saveData.itemsInGame.push_back(packedItem)
			pass
	
	#savae player (dolt)
	var playerPacked:PackedScene = PackedScene.new()
	playerPacked.pack(Global.gameManager.player)
	saveData.playerDoltInGame = playerPacked
	
	for dolt in aiDolts:
		ownerId = ownerId + 1
		
		#save dolts items
		for item in dolt.items:
			item.ownerId = ownerId
			var packedItem :PackedScene = PackedScene.new()
			packedItem.pack(item)
			saveData.itemsInGame.push_back(packedItem)
			pass
		
		#save the dolt
		var packed:PackedScene = PackedScene.new()
		packed.pack(dolt)
		saveData.aiDoltsInGame.push_back(packed)
	
	pass
	
func LoadDolts(saveData: SaveData):
	
	#load player dolt
	var playerDolt :Dolt= saveData.playerDoltInGame.instantiate()
	add_child(playerDolt)
	playerDolt.MoveTo(playerDolt.position.x,playerDolt.position.y)
	playerDolt.isPlayer = true
	Global.gameManager.player = playerDolt
	playerDolt.items.clear()
	
	#load ai dolts
	for _dolt in saveData.aiDoltsInGame:
		var dolt:Dolt = _dolt.instantiate()
		add_child(dolt)
		dolt.MoveTo(dolt.position.x,dolt.position.y)
		aiDolts.push_back(dolt)
		dolt.items.clear()
	
	#load items of ai and player dolts
	for _item in saveData.itemsInGame:
		var item:Item = _item.instantiate()
		if item.ownerId == 0:
			Global.itemManager.OnLoadGiveItem(Global.gameManager.player, item)
		else:
			Global.itemManager.OnLoadGiveItem(aiDolts[item.ownerId-1], item)
		pass
	
	pass
