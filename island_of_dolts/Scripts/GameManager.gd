extends Node
class_name GameManager

var gameRunning: bool
var player:Dolt
var random:RandomNumberGenerator
var playerHasPriority:bool
var seed:String

var playerName:String
var playerPosition:Vector2

func _enter_tree():
	Global.gameManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Global.audioManager.PlayRandomMusic()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func StartGame(args):
	if gameRunning:
		return
	gameRunning = true
	#Global.audioManager.PlayRandomMusic()
	random = RandomNumberGenerator.new()
	
	if args.size()==0:
		seed = str(randf())
		random.seed = seed.hash()
		
	else:
		random.seed = args[0].hash()
	
	Global.gridManager.GenerateIsland()
	
	if Global.saveManager.saveData == null: # new game stuff such as character creation here
		#get random starting position
		var x:int
		var y:int
		while true:
			x = random.randi_range(10,Global.gridManager.mapSize-10)
			y = random.randi_range(10,Global.gridManager.mapSize-10)
			var node = Global.gridManager.GetNodeAt(x,y)
			if node.block == null && !node.isDangerous:
				break
		player = Global.doltsManager.SpawnPlayer(x,y)
		Global.itemManager.GiveItem(player,"Blue Berries", 5, [])
		Global.doltsManager.NewGame()
		Global.terminal.ClearTerminal()
		Global.terminal.PrintWhite("What's your name?")
		playerName = await Global.terminal.WaitForInput()
		Global.gameManager.player.displayName = playerName
		Global.terminal.PrintWhite(str("Good luck ", playerName,". Use 'help basics' to get started."))
		Global.virtualViewport.FollowPlayer()
		MainGameLoop()
	
	
	
	pass

func MainGameLoop():
	while true:# turn cycle begins
		
		for dolt in Global.doltsManager.aiDolts: #get all alive dolts and put em into a queue
			Global.doltsManager.priorityQueue.push_back(dolt)
			dolt.priorityExhausted = false
			
		Global.doltsManager.priorityQueue.shuffle()#shuffle the queue
		
		Global.virtualViewport.FollowPlayer()#Update camera
		
		player.priorityExhausted = false#player always gets to do things first
		await PlayerReceivePriority()
		
		for dolt in Global.doltsManager.priorityQueue: #then go through actions of each ai dolt
			await dolt.ReceivePriority()
			
		Global.doltsManager.priorityQueue.clear() #clear the queue
		
		pass
	pass

func PlayerReceivePriority():
	player.ReceivePriority()
	playerHasPriority = true
	while !player.priorityExhausted:
		await get_tree().process_frame
	playerHasPriority = false

func PlayerMove(args):
	if !playerHasPriority:
		return
	
	if args.size() == 0:
		Global.terminal.PrintRed("The first argument has to be direction (e.g. 'move n' or 'move sw').")
		return
	
	var direction:Vector2 = DirectionToVector(args[0])
	if direction == Vector2(0,0):
		Global.terminal.PrintRed("The first argument has to be direction (e.g. 'move n' or 'move sw').")
		return
	var node = Global.gridManager.GetNodeAt(player.occupiedGridNode.xPos+direction.x, player.occupiedGridNode.yPos+direction.y)
	
	if node == null:
		Global.terminal.PrintRed(str("Your path is blocked by an invisible wall."))
		return
		
	if node.block != null:
		if !node.block.walkable:
			Global.terminal.PrintRed(str("Your path is blocked by a ",node.block.blockName,"."))
			return
			
	if node.isDangerous:
		if !player.flying:
			Global.terminal.PrintRed(str("You feel like not stepping in there."))
		return
	
	if node.dolt != null:
		Global.terminal.PrintRed(str("Your path is blocked by a ",node.dolt.displayName,"."))
	
	player.MoveTo(node.xPos,node.yPos)
	#Global.virtualViewport.FollowPlayer()
	player.priorityExhausted = true
		
	pass

func Examine(args):
	var vector: Vector2
	if args.size() == 0: #examine the node you are standing on
		vector = Vector2(0,0)
	else: #directional
		vector = DirectionToVector(args[0])
		if vector == Vector2(0,0):
			Global.terminal.PrintRed("The first argument has to be direction (e.g. 'examine n' or ' examine sw').")
			return
	
	var node = Global.gridManager.GetNodeAt(player.occupiedGridNode.xPos + vector.x, player.occupiedGridNode.yPos + vector.y)
	if node == null:
		Global.terminal.PrintWhite("You peer into abyss.")
		return
	
	if node.dolt != null && !node.dolt.isPlayer:
		Global.terminal.PrintWhite(str("It's a ", node.dolt.displayName,"."))
		pass
	
	if node.block != null:
		Global.terminal.PrintWhite(str("There is a ", node.block.blockName,"."))
		pass
	else:
		Global.terminal.PrintWhite(str("The ground is covered in ", node.groundDescription,"."))
	
		
	pass

func DirectionToVector(direction:String)->Vector2:
	match direction:
		"n":
			return Vector2(0,-1)
		"e":
			return Vector2(1,0)
		"s":
			return Vector2(0,1)
		"w":
			return Vector2(-1,0)
		"ne":
			return Vector2(1,-1)
		"se":
			return Vector2(1,1)
		"nw":
			return Vector2(-1,-1)
		"sw":
			return Vector2(-1,1)
	Global.terminal.PrintRed("Valid directions are 'n', 'e', 's', 'w', 'ne', 'se', 'nw' and 'sw'.")
	return Vector2(0,0)
	pass

func Wait():
	Global.terminal.PrintWhite("You wait.")
	player.priorityExhausted = true
	pass
	
	
