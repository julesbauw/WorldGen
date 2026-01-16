class_name Inventory

var item_list:Array[Item]

var size:int


func add_item(item:Item):
	
	if len(item_list) >= size:
		return
	
	item_list.append(item)

func get_item(i:int) -> Item:

	return item_list[i]
