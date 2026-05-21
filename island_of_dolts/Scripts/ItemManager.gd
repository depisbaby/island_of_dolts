extends Node
class_name ItemManager

@export var grassItems: Array[String]
var itemLibrary: Array[Item]
var items:Array[Item]
@onready var craftingRecipes:Array[CraftingRecipe] = [
	preload("res://PackedScenes/CraftingRecipes/club.tres"),
]
@onready var itemsPackedScenes: Array[PackedScene] = [
	preload("res://PackedScenes/Items/item_berries.tscn"),
	preload("res://PackedScenes/Items/item_worm.tscn"),
	preload("res://PackedScenes/Items/item_stone.tscn"),
	preload("res://PackedScenes/Items/item_stick.tscn"),
	preload("res://PackedScenes/Items/item_vine.tscn"),
	preload("res://PackedScenes/Items/item_club.tscn"),
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
	
	var item:Item = GetItemOfName(itemName)
	#print(item.itemName)
	if item == null:
		print(str("There is no item named '", itemName,"'."))
		push_error()
	
	var newItem = item.duplicate()
	newItem.position = Vector2(-1,-1)
	newItem.amount = amount
	newItem.data = data
	
	if !PickUpItem(dolt,newItem,amount):
		newItem.queue_free()
		return false
	
	return true
	
		#print("new item")
		

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

func PickUpItem(dolt:Dolt, item:Item, amount:int)->bool:
	
	if amount <= 0 || amount >= item.amount: #pickup all
		amount = item.amount
	
	var oldNode:GridNode
	if item.position != Vector2(-1,-1):
		oldNode = Global.gridManager.GetNodeAt(item.position.x, item.position.y)
	
	var totalWeight:float = amount*item.weightPerItem #get total weight
	var oldItem:Item = null
	for _item in dolt.items:
		if _item.itemName == item.itemName:
			oldItem = _item
		var weight:float = _item.amount * _item.weightPerItem
		totalWeight = totalWeight + weight
	
	if totalWeight > dolt.strength: #check if can carry
		if dolt.isPlayer:
			Global.terminal.PrintRed(str(item.itemName, " is too heavy to be carried. Use 'drop Stone 1' to drop an item."))
		return false
		
	if item.data.size() == 0 && oldItem != null && oldItem.data.size() == 0: #combine with old item
		oldItem.amount = oldItem.amount + amount
		if dolt.isPlayer:
			Global.terminal.PrintWhite(str("You picked up ", amount, "x ",item.itemName))
		
	else: # make a new item
		var newItem = item.duplicate()
		newItem.amount = amount
		newItem.data = item.data
		newItem.position = Vector2(-1,-1)
		dolt.items.push_back(newItem)
		items.push_back(newItem)
		if dolt.isPlayer:
			Global.terminal.PrintWhite(str("You picked up ", amount, "x ",item.itemName))
		
	
	item.amount = item.amount - amount 
	if item.amount <= 0:#did we pick up all?
		if oldNode != null:
			oldNode.items.erase(item)
		item.queue_free()
	return true
	
	pass

func PlaceItemInWorld(position:Vector2, item:Item)->bool:
	var oldNode:GridNode
	if item.position != Vector2(-1,-1):
		oldNode = Global.gridManager.GetNodeAt(item.position.x, item.position.y)
	
	var node:GridNode = Global.gridManager.GetNodeAt(position.x, position.y)
	if node == null:
		return false
	
	if node.block != null:
		return false
		
	for _item in node.items:
		if _item.itemName == item.itemName:
			if item.data.size() == 0 && _item.data.size() == 0: #combine with existing
				_item.amount = _item.amount + item.amount
				item.queue_free()
				if oldNode != null:
					oldNode.items.erase(item)
				return true
		
	node.items.push_front(item)
	item.position = position
	
	if oldNode != null:
		oldNode.items.erase(item)
		
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
		newItem.amount = _amount
		newItem.position = Vector2(-1,-1)
		PlaceItemInWorld(Global.gameManager.player.position, newItem)
	
	Global.terminal.PrintWhite(str("You dropped ",_amount,"x ",_itemName))
	pass

func PlayerPickUp(position:Vector2,itemName:String,amount:int):
	var node:GridNode = Global.gridManager.GetNodeAt(position.x,position.y)
	var item:Item = null
	for _item in node.items:
		if _item.itemName == itemName:
			item = _item
	
	if item == null:
		Global.terminal.PrintRed(str("There is no '",itemName,"' here."))
		return
	
	PickUpItem(Global.gameManager.player,item,amount)
	
	
	pass

func Craft(crafter:Dolt, itemName:String)->bool:
	var recipe:CraftingRecipe = null
	for _recipe:CraftingRecipe in craftingRecipes:
		if _recipe.itemName == itemName:
			recipe = _recipe
	if recipe == null:
		if crafter.isPlayer:
			Global.terminal.PrintRed(str("There is no recipe for '",itemName,"'."))
		return false
	
	var missingItems: Array[String]
	var missingAmounts: Array[int]
	var i:int
	for required:String in recipe.itemsRequired:
		var itemFound:bool = false
		for item in crafter.items:
			if item.itemName == required:
				itemFound = true
				var x:int = item.amount - recipe.amountsRequired[i]
				if x < 0:
					missingAmounts.push_back(abs(x))
					missingItems.push_back(required)
					
		if !itemFound:
			missingAmounts.push_back(recipe.amountsRequired[i])
			missingItems.push_back(required)
			
		i=i+1
	i = 0
	
	if missingItems.size()>0:
		if crafter.isPlayer:
			Global.terminal.PrintRed("Missing following items:")
			for missing:String in missingItems:
				Global.terminal.PrintRed(str("- ",missingAmounts[i],"x ", missing))
				i=i+1
		return false
		
	for required:String in recipe.itemsRequired:
		for item: Item in crafter.items:
			if required == item.itemName:
				item.amount = item.amount - recipe.amountsRequired[i]
				if item.amount == 0:
					crafter.items.erase(item)
					item.queue_free()		
		i=i+1
	
	GiveItem(crafter, recipe.itemName, recipe.amountCrafted,[])
	
	if crafter.isPlayer:	
		Global.terminal.PrintWhite("Crafting...")		
	
	return true
