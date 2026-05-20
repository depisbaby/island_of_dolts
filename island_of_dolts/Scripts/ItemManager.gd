extends Node
class_name ItemManager

@export var grassItems: Array[String]
var itemLibrary: Array[Item]
var items:Array[Item]
@onready var itemsPackedScenes: Array[PackedScene] = [
	preload("res://PackedScenes/Items/item_berries.tscn"),
	preload("res://PackedScenes/Items/item_worm.tscn"),
	preload("res://PackedScenes/Items/item_stone.tscn"),
	preload("res://PackedScenes/Items/item_stick.tscn"),
	preload("res://PackedScenes/Items/item_vine.tscn"),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
]


func _enter_tree() -> void:
	Global.itemManager = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	InitItems()
	pass # Replace with function body.

func InitItems():
	for ps in itemsPackedScenes:
		var item :Item= ps.instantiate()
		item.position = Vector2(-1,-1)
		itemLibrary.push_back(item)
		
		
	pass

func GetItemOfName(_itemName:String)->Item:
	for _item in itemLibrary:
		if _item.itemName == _itemName:
			return _item
			break
	return null
	pass

func GiveItem(dolt:Dolt, itemName:String, amount:int, data:Array[String])-> bool:
	if !dolt.canTakeItems:
		Global.terminal.PrintRed(str(dolt.displayName, " is unable to carry items."))
		return false
	
	var item:Item = GetItemOfName(itemName)
	#print(item.itemName)
	if item == null:
		print(str("There is no item named ", itemName))
		push_error()
	
	var totalWeight:float = amount*item.weightPerItem
	var oldItem:Item = null
	for _item in dolt.items:
		if _item.itemName == item.itemName:
			oldItem = _item
		var weight:float = _item.amount * _item.weightPerItem
		totalWeight = totalWeight + weight
	
	if totalWeight > dolt.strength:
		Global.terminal.PrintRed(str(itemName, " is too heavy to be carried."))
		return false
		
	if data.size() == 0 && oldItem != null && oldItem.data.size() == 0: #combine with old item
		oldItem.amount = oldItem.amount +amount
		if dolt.isPlayer:
			Global.terminal.PrintWhite(str("You picked up ", amount, "x ",itemName))
	else: # make a new item
		var newItem = item.duplicate()
		newItem.amount = amount
		newItem.data = data
		dolt.items.push_back(newItem)
		items.push_back(newItem)
		if dolt.isPlayer:
			Global.terminal.PrintWhite(str("You picked up ", amount, "x ",itemName))
			
		print("new item")
		
	return true

func OnLoadGiveItem(dolt:Dolt, item:Item):
	dolt.items.push_back(item)
	items.push_back(item)
	pass

func PrintInventory(dolt:Dolt):

	
	Global.terminal.PrintWhite(str(dolt.displayName, " has the following items:"))
	
	for item in dolt.items:
		match item.rarity:
			0:
				Global.terminal.PrintWhite(str(" - ",item.amount,"x ", item.itemName," (",item.amount*item.weightPerItem,"kg)"))
			1:
				Global.terminal.PrintBlue(str(" - ",item.amount,"x ", item.itemName," (",item.amount*item.weightPerItem,"kg)"))
			2: 
				Global.terminal.PrintGreen(str(" - ",item.amount,"x ", item.itemName," (",item.amount*item.weightPerItem,"kg)"))
			3:
				Global.terminal.PrintYellow(str(" - ",item.amount,"x ", item.itemName," (",item.amount*item.weightPerItem,"kg)"))
			4:
				Global.terminal.PrintPurple(str(" - ",item.amount,"x ", item.itemName," (",item.amount*item.weightPerItem,"kg)"))
			

func Forage(forager:Dolt,groundDescription:String):
	match groundDescription:
		"Grass":
			GiveItem(forager,grassItems[randi_range(0,grassItems.size()-1)],1,[])
		
	pass

func PlaceItemInWorld(position:Vector2, item:Item)->bool:
	var node:GridNode = Global.gridManager.GetNodeAt(position.x, position.y)
	if node == null:
		return false
	
	if node.block != null:
		return false
		
	for _item in node.items:
		if _item.itemName == item.itemName:
			if item.data.size() == 0 && _item.data.size() == 0:
				_item.amount = item.amount
				item.queue_free()
				return true
		
	node.items.push_front(item)
	item.position = position
	return true

func PlayerDropItem(itemName:String, amount:int):
	
	var found:Item 
	for item in Global.gameManager.player.items:
		if item.itemName == itemName:
			found = item
			
	if found == null:
		Global.terminal.PrintRed(str("There is no '",itemName, "' in your inventory."))
		return
	
	var _itemName:String = found.itemName
	var _amount:int
	
	if amount >= found.amount || amount < 1: #drop all
		_amount = found.amount
		Global.gameManager.player.items.erase(found)
		PlaceItemInWorld(Global.gameManager.player.position, found)
	else :
		_amount = amount
		found.amount = found.amount - _amount
		var newItem:Item = found.duplicate()
		PlaceItemInWorld(Global.gameManager.player.position, newItem)
	
	Global.terminal.PrintWhite(str("You dropped ",_amount,"x ",_itemName))
	pass
