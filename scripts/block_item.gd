extends Item

class_name BlockItem

var block:Block


#override
func right_action(user:Entity):
	if amount > 0:
		user.place_block(block)
		amount -= 1
	
#override
func is_equal(other:Item) -> bool:
	var s_e := super.is_equal(other)
	# at this point it must be a block
	if !s_e:
		return false
	var other_block := other as BlockItem

	return other_block.block.block_number == self.block.block_number
