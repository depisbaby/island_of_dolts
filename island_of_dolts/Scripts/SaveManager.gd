extends Node
class_name SaveManager

var saveData: SaveData

func _enter_tree():
	Global.saveManager = self
	pass


func Save(args):
	var path :String
	if args.size()== 0: #save
		if saveData == null:
			if args.size()== 0:
				Global.terminal.PrintRed("The game hasn't been saved yet. Use 'save [save name]' to save.")
				return
		path = str("user://save_",saveData.saveName,".tres")
	else: #new save
		path = str("user://save_",args[0],".tres")
		if FileAccess.file_exists(path):
			Global.terminal.PrintRed(str("Save name '",args[0],"' already exists. Choose a different name."))
			return
	
	
	if saveData == null: #this is a new game
		saveData = SaveData.new()
		saveData.saveName = args[0]
		
	SaveLocalData()
	
	var result = ResourceSaver.save(saveData, path)
	if result == OK:
		print("Saved successfully")
		Global.terminal.PrintGreen(str("Game '",saveData.saveName, "' saved!"))
	pass

func Load(args):
	if Global.gameManager.gameRunning:
		Global.terminal.PrintRed("Loading ingame not yet supported. Restart and load from main menu instead.")
		return
	
	if args.size()==0:
		Global.terminal.PrintRed("Usage: load [save name]")
		return
	var path = str("user://save_",args[0],".tres")
	if !FileAccess.file_exists(path):
		Global.terminal.PrintRed(str("Save name '",args[0],"' doesn't exist. Choose a different name."))
		return
	
	saveData = ResourceLoader.load(path)
	Global.gameManager.StartGame([saveData.seed])
	
	LoadSaveData()
	
	Global.gameManager.player.displayName = Global.gameManager.playerName
	Global.virtualViewport.FollowPlayer()
	Global.gameManager.MainGameLoop()
	pass

func SaveLocalData():
	saveData.seed = Global.gameManager.seed
	saveData.playerName = Global.gameManager.playerName
	
	Global.doltsManager.SaveDolts(saveData)
	
	
	pass

func LoadSaveData():
	Global.gameManager.playerName = saveData.playerName
	
	Global.doltsManager.LoadDolts(saveData)
	
	pass
