extends TextureButton

@export var is_currently_scout : bool
@export_group("character_stats")
##hit points before death
@export var hp : int = 5
##how much weight they can carry
@export var strength : int = 5
##tiles moved per turn
@export var speed : int = 2
##can gather wood and stone
@export var raw_resources : bool = true
##can hunt and/or forage
@export var hunting_foraging : bool = true
##can they craft stuff
@export var crafting : bool = true
##amount of damage done per attack
@export var fighting : int = 5

@onready var selection_audio: AudioStreamPlayer = $SelectionAudio
@onready var sprite: Control = $sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var offset : Vector2 = Vector2.ZERO
var currently_selected = false
var resources : Dictionary[Globals.resource_type, int] = {
	Globals.resource_type.FOOD : 0,
	Globals.resource_type.WATER : 0
}

func _ready() -> void:
	size.x = Globals.button_size
	size.y = Globals.button_size
	global_position -= size/2
	offset = size/2
	sprite.position += offset
	SignalBus.turn_ended.connect(end_turn)
	SignalBus.unit_selected.connect(func():currently_selected = false)
	SignalBus.unit_moved.connect(move_unit)
	button_up.connect(select_unit)
	await get_tree().process_frame
	grab_focus()

func select_unit() -> void:
	selection_audio.play()
	currently_selected = true

func move_unit() -> void:
	if !currently_selected:
		return
	var tilemap : TileMapLayer = %TileMapLayer
	var current_coords = tilemap.get_coords_for_body_rid(sprite)
	tilemap.distanc
	global_position = get_global_mouse_position() - offset
	
func end_turn() -> void:
	resources[Globals.resource_type.FOOD] -= 1
	resources[Globals.resource_type.WATER] -= 1
	if resources[Globals.resource_type.FOOD]  < 0 or resources[Globals.resource_type.WATER] < 0:
		die()

func die() -> void:
	SignalBus.unit_died.emit(sprite)
	await get_tree().create_timer(1).timeout
	animation_player.play("die")
