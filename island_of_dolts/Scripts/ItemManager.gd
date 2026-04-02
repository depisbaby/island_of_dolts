extends Node
class_name ItemManager

@export var itemsPackedScenes: Array[PackedScene]
var itemLibrary: Array[Item]
var items:Array[Item]

func _enter_tree() -> void:
	Global.itemManager = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	LoadItems()
	pass # Replace with function body.

func LoadItems():
	for ps in itemsPackedScenes:
		var item = ps.instantiate()
		itemLibrary.push_back(item)
	pass

func GetItemOfName(_itemName:String)->Item:
	var item :Item
	for _item in itemLibrary:
		if _item.itemName == _itemName:
			item == _item
			break
	return item
	pass

func GiveItem(dolt:Dolt, itemName:String, amount:int, data:String):
	var item:Item = GetItemOfName(itemName)
	if item == null:
		print(str("There is no item named ", itemName))
		push_error()
	
	
	pass
