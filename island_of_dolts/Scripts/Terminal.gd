extends Node
class_name Terminal

@export var line:LineEdit
@export var terminalText:RichTextLabel
var commandHistory:Array[String] = [""]
var commandHistoryHead:int
var locked:bool
var waitingForInput:bool
var waitedInput:String

func _enter_tree():
	Global.terminal = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("repeat_last"):
		_on_line_edit_text_submitted(commandHistory[0])
	pass

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if !Global.settings.settingsOpen:
			Global.audioManager.PlayKeyPress()
		

func UpArrow():
	commandHistoryHead = commandHistoryHead + 1
	
	if commandHistoryHead > commandHistory.size()-1:
		commandHistoryHead = commandHistory.size()-1
	
	line.text = commandHistory[commandHistoryHead]
	line.caret_column = line.text.length()
	
	pass
	
func DownArrow():
	commandHistoryHead = commandHistoryHead - 1
	
	if commandHistoryHead < 0:
		commandHistoryHead = 0
	
	line.text = commandHistory[commandHistoryHead]
	line.caret_column = line.text.length()
	pass

func _on_line_edit_text_submitted(input):
	if Global.settings.settingsOpen:
		return
	
	if input == "":
		return
		
	if waitingForInput:
		
		waitedInput = input
		waitingForInput = false
		line.text = ""
		return
	
	if locked:
		return
	
	var parts = input.split(" ")

	if parts.size() == 0:
		return

	var cmd = parts[0]
	var args = parts.slice(1)
	Global.commands.RunCommand(cmd,args)
	line.text = ""
	
	if input != commandHistory[0]:
		commandHistory.push_front(input)
	
	commandHistoryHead = -1
		
	pass # Replace with function body.


func PrintRed(message):
	terminalText.text = str(terminalText.text,"\n[color=be7979]",message ,"[/color]")
	pass

func PrintWhite(message):
	terminalText.text = str(terminalText.text,"\n",message)
	pass

func PrintBlue(message):
	terminalText.text = str(terminalText.text,"\n[color=79bdbe]",message,"[/color]")
	pass

func PrintYellow(message):
	terminalText.text = str(terminalText.text,"\n[color=bebe79]",message,"[/color]")
	pass

func PrintGreen(message):
	terminalText.text = str(terminalText.text,"\n[color=7cbe79]",message,"[/color]")
	pass
	
func PrintPurple(message):
	terminalText.text = str(terminalText.text,"\n[color=9479be]",message,"[/color]")
	pass

func ClearTerminal():
	terminalText.text = ""

func LockTerminal(time:float):
	if locked:
		return
	locked = true
	await get_tree().create_timer(time).timeout
	locked = false

func WaitForInput()->String:
	if waitingForInput:
		return ""
	waitedInput = ""
	waitingForInput = true
	while waitedInput == "":
		await get_tree().create_timer(0.01).timeout
	
	waitingForInput = false
	return waitedInput
	
	pass
