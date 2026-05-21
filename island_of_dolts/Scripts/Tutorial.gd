extends Node
class_name Tutorial

func Start():
	
	await get_tree().create_timer(1.0).timeout
	Global.terminal.PrintWhite("Welcome to Island of Dolts.\n")
	await get_tree().create_timer(5.0).timeout
	Global.terminal.PrintWhite("Island of Dolts is a revival of a text-based RPG.\n")
	await get_tree().create_timer(5.0).timeout
	Global.terminal.PrintWhite("Everything is done using the terminal below.\n")
	await get_tree().create_timer(5.0).timeout
	Global.terminal.PrintWhite("Many aspects of the game are purposely obscure.\n")
	await get_tree().create_timer(5.0).timeout
	Global.terminal.PrintWhite("A notepad and a pencil are recommended.\n")
	await get_tree().create_timer(5.0).timeout
	Global.terminal.ClearTerminal()
	Global.terminal.PrintWhite("Use 'move e' to move east.\n")
	await get_tree().create_timer(10.0).timeout
	Global.terminal.PrintWhite("To move in other directions use 'n', 's' and 'w'. To move diagonally use 'ne' and 'sw' for example.\n")
	await get_tree().create_timer(20.0).timeout
	Global.terminal.PrintWhite("Using arrow up and down you can cycle through previously used commands. Pressing tab will execute the last used command.\n")
	
	while Global.gameManager.player.position.x < 90:
		await get_tree().create_timer(1.0).timeout
	
	Global.terminal.PrintWhite("Your path is blocked by a rock. You need a tool to remove it.\n")
	
	pass
