extends Button
class_name building_button

@export var costs : Dictionary[Globals.resource_type, int]
@export var building_name : String = "well"
@export var portrait : CompressedTexture2D
const RESOURCE_COST = preload("res://ui/game/campsite_ui/resource_cost.tscn")

@onready var costs_container: GridContainer = $HBoxContainer/CostsContainer

func _ready() -> void:
	for i in costs.keys():
		var new_cost : cost = RESOURCE_COST.instantiate()
		new_cost.amount = costs[i]
		new_cost.resource_type = i
		costs_container.add_child(new_cost)
