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
	"i": Inventory
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
	Global.gameManager.PlayerMove(args)
	pass

func Save(args):
	Global.saveManager.Save(args)
	pass

func Examine(args):
	Global.gameManager.Examine(args)
	pass
	
func Inventory(args):
	Global.itemManager.PrintInventory(Global.gameManager.player)
	pass
