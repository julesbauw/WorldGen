extends Resource

class_name Item
"""

Class for items, an item has two action (left/right click)

This class will be used for empty Item slots!
"""


var item_name:String

var item_image:Texture

var amount:int = 1

enum type_enum {
    ITEM,
    BLOCK_ITEM,
}

func get_type() -> type_enum:
    return type_enum.ITEM

func is_equal(other:Item) -> bool:

    return other.get_type() == self.get_type() and self.item_name == other.item_name


func left_action(user:Entity):
    """

    action when left mouse clicked, user is the Entity using the item, default is just block removing

    """
    user.remove_block()

func right_action(user:Entity):
    """

    action when left mouse clicked, user is the Entity using the item, default is None

    """

    pass