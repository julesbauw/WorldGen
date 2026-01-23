extends Listener

class_name InventoryUI

@export var h_box:HBoxContainer

@export var item_panel:PackedScene

var inventory:Inventory

@onready var style_selected:StyleBoxFlat = load("res://resources/UI/inventory_item_selected.tres")
@onready var style_unselected:StyleBoxFlat = load("res://resources/UI/inventory_item_unselected.tres")


func update_listener():
	for child in h_box.get_children():
		child.queue_free()
	

	for i in range(inventory.size):
		var child:InventoryItemUI = item_panel.instantiate()
		
		if i < len(inventory.item_list) and inventory.item_list[i]:
			var item = inventory.item_list[i]
			child.image.texture = item.item_image
			child.amount_label.text = str(item.amount)
			if inventory.selected_item == i:
				child.add_theme_stylebox_override("panel",style_selected)
			else:
				child.add_theme_stylebox_override("panel",style_unselected)
		else:
			child.image.texture = null
			child.amount_label.text = ""
		h_box.add_child(child)
		i += 1
