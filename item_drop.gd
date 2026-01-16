extends Node2D

class_name ItemBlock

@export var item:Item


func _on_area_2d_body_entered(body: Node2D) -> void:

    if not body is Player:
        return
    
    var player:Player = body as Player

    player.inventory.add_item(item)

    queue_free()
        
