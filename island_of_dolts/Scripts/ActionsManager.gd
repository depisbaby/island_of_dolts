extends Node
class_name ActionsManager

@export var actionsPackedScenes: Array[PackedScene]
var actions: Array[Action]

func PerformCommand(args):
	
	if args.size() == 0:
		Global.terminal.PrintRed("Provide an action name and direction. (e.g. 'perform swing n')")
		return
		
	var action : Action = GetActionByName(args[0])
	if action == null:
		Global.terminal.PrintRed(str("There is no such action as '",args[0],"'."))
		return
		
	var direction : Vector2
	if args.size() > 1:
		direction = Global.gameManager.DirectionToVector(args[1])
	
	action.Perform(Global.gameManager.player, direction, [])
	
	pass

func _enter_tree() -> void:
	Global.actionsManager =self
	pass

func _ready():
	await get_tree().process_frame
	LoadActions()
	pass

func LoadActions():
	for _action in actionsPackedScenes:
		var action = _action.instantiate()
		actions.push_back(action)
	pass

func GetAction(id: int)->Action:
	return actions[id]
	pass
	
func GetActionByName(name: String)->Action:
	for action in actions:
		if action.actionName == name:
			return action
	return null
	pass
