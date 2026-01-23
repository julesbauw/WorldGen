extends Model

class_name Inventory

var item_list:Array[Item]

var size:int

var selected_item:int:
	set(value): 
		selected_item = value
		update_listeners()

func _init() -> void:
	item_list.resize(size)

func check_empty_items():

	for i in range(len(item_list)):
		if item_list[i]:
			if item_list[i].amount <= 0:
				item_list[i].free()
				item_list[i] = null
	update_listeners()

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