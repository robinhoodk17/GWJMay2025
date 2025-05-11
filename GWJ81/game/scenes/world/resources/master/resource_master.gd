extends StaticBody2D

@export var resource_type : Globals.resource_type
@export var amount : int = 10:
	set(value):
		amount = value
		update_label()
@onready var label: Label = $Label

func _ready() -> void:
	update_label()

func update_label() -> void:
	label.text = str(amount)
