class_name Block
extends Resource


@export var name:String
@export var block_number:int
@export var block_location:Vector2i

@export var inventory_image:Texture

@export var is_empty:bool = false


func get_item() -> BlockItem:

    var item = BlockItem.new()

    item.block = self
    item.item_name = name
    item.item_image = inventory_image
    return item

