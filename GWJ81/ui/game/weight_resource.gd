extends Label

@export var resource : Globals.resource_type = Globals.resource_type.WEIGHT

func _ready() -> void:
	SignalBus.resource_changed.connect(update_count)


func update_count(resource_type : Globals.resource_type) -> void:
	if resource_type == resource:
		text = str(Globals.resources[resource], " / ", Globals.carrying_weight)
		
