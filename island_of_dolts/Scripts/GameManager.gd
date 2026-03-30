extends Node
class_name GameManager

var gameRunning: bool
var player:Dolt
var random:RandomNumberGenerator
var playerHasPriority:bool

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
	Global.audioManager.PlayRandomMusic()
	random = RandomNumberGenerator.new()
	
	if args.size()==0:
		random.seed = str(randf()).hash()
	else:
		random.seed = args[0]
	
	Global.gridManager.GenerateIsland()
	
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
	Global.virtualViewport.FollowPlayer()
	
	if Global.saveManager.saveData == null: # new game stuff such as character creation here
		Global.doltsManager.NewGame()
		Global.terminal.ClearTerminal()
		Global.terminal.PrintWhite("What's your name?")
		playerName = await Global.terminal.WaitForInput()
		Global.terminal.PrintWhite(str("Good luck ", playerName,". Use 'help basics' to get started."))
		
		MainGameLoop()
	
	
	pass

func MainGameLoop():
	while true:# turn cycle begins
		
		for dolt in Global.doltsManager.aiDolts: #get all alive dolts and put em into a queue
			Global.doltsManager.priorityQueue.push_back(dolt)
			dolt.priorityExhausted = false
			
		Global.doltsManager.priorityQueue.shuffle()#shuffle the queue
		
		player.priorityExhausted = false#player always gets to do things first
		await PlayerReceivePriority()
		
		for dolt in Global.doltsManager.priorityQueue: #then go through actions of each ai dolt
			await dolt.AiReceivePriority()
			
		Global.doltsManager.priorityQueue.clear() #clear the queue
		
		pass
	pass

func PlayerReceivePriority():
	playerHasPriority = true
	while !player.priorityExhausted:
		await get_tree().create_timer(0.1).timeout
	playerHasPriority = false

func PlayerMove(args):
	if !playerHasPriority:
		return
		
	var direction:Vector2 = DirectionToVector(args[0])
	var node = Global.gridManager.GetNodeAt(player.occupiedGridNode.xPos+direction.x, player.occupiedGridNode.yPos+direction.y)
	
	if node == null:
		Global.terminal.PrintRed(str("The path is blocked by an invisible wall."))
		return
		
	if node.block != null:
		if !node.block.walkable:
			Global.terminal.PrintRed(str("The path is blocked by ",node.block.blockName,"."))
			return
			
	if node.isDangerous:
		Global.terminal.PrintRed(str("You feel like not swimming today."))
		return
	
	player.MoveTo(node.xPos,node.yPos)
	Global.virtualViewport.FollowPlayer()
	player.priorityExhausted = true
		
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
	return Vector2(0,0)
	pass
