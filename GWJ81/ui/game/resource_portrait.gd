extends TextureRect
class_name resource_portrait

@export var resource_type : Globals.resource_type = Globals.resource_type.FOOD

func _ready() -> void:
	if Globals.resource_image.has(resource_type):
		texture = Globals.resource_image[resource_type]
