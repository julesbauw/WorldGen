extends Resource

class_name Model

var listeners:Array[Listener]


func add_listener(listener:Listener):

    listeners.append(listener)


func update_listeners():

    for listener in listeners:
        listener.update_listener()
