extends Node
class_name Helper

func _enter_tree():
	Global.helper = self
	pass

func Help(args):
	
	if args.size() == 0:
		Global.terminal.PrintBlue("help basics")
		return
		pass
	
	if args[0] == "basics":
		Global.terminal.PrintBlue("\n_____[MOVE COMMAND]_____")
		Global.terminal.PrintBlue("'move n' (Move north)")
		Global.terminal.PrintBlue("'move e' (Move east)")
		Global.terminal.PrintBlue("'move sw' (Move southwest)")
		Global.terminal.PrintBlue("\n____[TERMINAL SHORTCUTS]____")
		Global.terminal.PrintBlue("Press [Arrow Up] and [Arrow Down] to insert previously used commands.")
		Global.terminal.PrintBlue("Press [Tab] to execute last command.")
		return
	
	pass
