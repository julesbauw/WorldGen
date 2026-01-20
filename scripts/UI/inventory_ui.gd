extends Listener

class_name InventoryUI

@export var h_box:HBoxContainer

@export var item_panel:PackedScene

var inventory:Inventory

func update_listener():
	for child in h_box.get_children():
		child.queue_free()
	
	for item in inventory.item_list:
		print(item.item_name)
		var child:InventoryItemUI = item_panel.instantiate()
		
		child.image.texture = item.item_image
		child.amount_label.text = str(item.amount)
		h_box.add_child(child)
