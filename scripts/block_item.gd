extends Item

class_name BlockItem

var block:Block


#override

func right_action(user:Entity):
    user.place_block(block)

