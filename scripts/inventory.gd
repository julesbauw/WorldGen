extends Model

class_name Inventory

var item_list:Array[Item]

var size:int


func add_item(new_item:Item):
	
	if len(item_list) >= size:
		return
	
	for item in item_list:
		if new_item.is_equal(item):
			item.amount += new_item.amount
			update_listeners()
			return	
	item_list.append(new_item)

	update_listeners()

func get_item(i:int) -> Item:

	return item_list[i]

func print_inventory():
	
	var line := ""
	for item in item_list:
		
		line += item.item_name + ":" + str(item.amount)
	print(line)