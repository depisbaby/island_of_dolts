extends Node
class_name Commands

func _enter_tree():
	Global.commands = self
	pass

var commands = {
	"new": NewGame,
	"load": LoadGame,
	"clear": Clear,
	"help": Help,
	"move": Move,
	"save": Save,
	"examine": Examine,
	"inventory": Inventory,
	"i": Inventory,
	"perform": Perform,
	"p": Perform,
	"wait": Wait,
	"w":Wait,
	"forage":Forage,
	"drop":Drop
}

func RunCommand(cmd, args):
	
	if commands.has(cmd):
		commands[cmd].call(args)
	else:
		Global.terminal.PrintRed(str("'",cmd,"' is not a command. Try 'help'."))
	pass

func Clear(args):
	Global.terminal.ClearTerminal()

func NewGame(args):
	Global.gameManager.StartGame(args)
	pass
	
func LoadGame(args):
	if args.size()== 0:
		Global.terminal.PrintRed("To load use 'load [save name]' (e.g. 'load mysave').")
		return
	Global.saveManager.Load(args)
	pass

func Help(args):
	Global.helper.Help(args)
	pass

func Move(args):
	if !Global.gameManager.playerHasPriority:
		return
	Global.gameManager.PlayerMove(args)
	pass

func Save(args):
	if !Global.gameManager.playerHasPriority:
		return
	Global.saveManager.Save(args)
	pass

func Examine(args):
	Global.gameManager.Examine(args)
	pass
	
func Inventory(args):
	if args.size() == 0:
		Global.itemManager.PrintInventory(Global.gameManager.player)
	else:
		var dir:Vector2 = Global.gameManager.DirectionToVector(args[0])
		var node :GridNode = Global.gridManager.GetNodeAt(Global.gameManager.player.position.x + dir.x,Global.gameManager.player.position.y + dir.y)
		if node != null && node.dolt != null:
			Global.itemManager.PrintInventory(node.dolt)
			
	pass
	
func Perform(args):
	if !Global.gameManager.playerHasPriority:
		return
	Global.actionsManager.PerformCommand(args)
	pass
	
func Wait(args):
	if !Global.gameManager.playerHasPriority:
		return
	Global.gameManager.Wait()
	pass
	
func Forage(args):
	if !Global.gameManager.playerHasPriority:
		return
		
	if args.size()==0:
		Global.gameManager.player.occupiedGridNode.Forage(Global.gameManager.player)
	else:
		var direction:Vector2 = Global.gameManager.DirectionToVector(args[0])
		var node:GridNode = Global.gridManager.GetNodeFromPosition(Global.gameManager.player.position,direction,1)
		if node != null:
			node.Forage(Global.gameManager.player)
	pass
	
func Drop(args):
	if !Global.gameManager.playerHasPriority:
		return
		
	if args.size() == 0:
		Global.terminal.PrintRed("Specify an item to drop. (e.g. 'drop Stick')")
		return
		pass
		
	if args.size() == 2: #amount specified
		
		if args[1].is_valid_int():
			var amount:int = int(args[1])
			Global.itemManager.PlayerDropItem(args[0],amount)
		else:
			Global.terminal.PrintRed("Use an integer to specify the amount of items to drop. (e.g. 'drop Stick 5')")
			pass
	else:#
		Global.itemManager.PlayerDropItem(args[0], 1)
		
	pass
