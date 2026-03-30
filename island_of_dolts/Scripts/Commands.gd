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
	"save": Save
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
		Global.terminal.PrintRed("Usage: load [save number]")
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
