extends Node

# What goes into globals.gd?
# If the function depends on the something in the game, it's a global.
# If it's independent, it (probably) belongs in utils.gd

enum resource_type{WOOD, ROCK, PEOPLE, UNCOOKED, FOOD, WATER, WEIGHT}
enum building_type{MATERIALS, WELL, FARM}

## Use UI/MessageBox to display a status update message to the player
@warning_ignore("unused_signal")
signal post_ui_message(text: String)

## Emitted by UI/Controls when a action is remapped
@warning_ignore("unused_signal")
signal controls_changed(config: GUIDERemappingConfig)
@export	var resource_image : Dictionary[resource_type, CompressedTexture2D]
@export var available_blueprints : Dictionary[building_type, building_blueprint]
var resources : Dictionary[resource_type, float] = {
	resource_type.WOOD : 0, resource_type.ROCK : 0, resource_type.UNCOOKED : 0,
	resource_type.PEOPLE : 0, resource_type.FOOD : 0, resource_type.WEIGHT : 0.0,
	resource_type.WATER : 0
	}
var people : int = 0
var carrying_weight : float = 10
var campsite_food_consumed : int = 0
var campsite_weight : int = 0
var oxygen_radius : float = 3.0
var camera_speed : float = 400
var button_size : float = 32.0
var characters : Dictionary
var character_focused : bool = false
var campsite_spent : bool = false
