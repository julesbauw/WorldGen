extends Node

class_name Item
"""

Class for items, an item has two action (left/right click)

This class will be used for empty Item slots!
"""


var item_name:String



func left_action(user:Entity):
    """

    action when left mouse clicked, user is the Entity using the item, default is just block removing

    """

    pass

func right_action(user:Entity):
    """

    action when left mouse clicked, user is the Entity using the item, default is None

    """

    pass