extends Item

class_name Pickaxe

func _init() -> void:
    item_name = "Pickaxe"

func left_action(user:Entity):
    user.remove_block()