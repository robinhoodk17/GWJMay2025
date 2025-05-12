extends HBoxContainer
class_name cost

@export var resource_type : Globals.resource_type = Globals.resource_type.FOOD
@export var amount : int

@onready var texture_rect: resource_portrait = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	texture_rect.resource_type = resource_type
	label.text = str(amount)
