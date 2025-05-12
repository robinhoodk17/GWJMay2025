extends Node2D
# This scene is started by clicking the "Play" button in main.tscn.
# Change Project Settings: application/run/start_scene to game/game.tscn to skip the menus while developing

@export var default_mapping_context: GUIDEMappingContext
@export var select_unit : GUIDEAction
@export var move_unit : GUIDEAction
@onready var terrain: TileMapLayer = %Terrain
@onready var tile_map_ui: TileMapLayer = %TileMapUI

@onready var tile_ground = %Terrain
@onready var tile_feature = %Resources

@export var humidity_noise_texture : NoiseTexture2D
@export var altitude_noise_texture : NoiseTexture2D
@export var tree_noise_texture : NoiseTexture2D
@export var village_noise_texture : NoiseTexture2D

# For tile generation
var width : int = 50
var height : int =  50

var humidity_noise : Noise
var altitude_noise : Noise

var tree_noise : Noise
var village_noise : Noise

var ground_id = 2
var water_tile_atlas = Vector2i(0,1)
var canyon_tile_atlas = Vector2i(0,0)
var mud_tile_atlas = Vector2i(0,5)
var soil_tile_atlas = Vector2i(0,2)
var fertile_tile_atlas = Vector2i(0,6)
var desert_tile_atlas = Vector2i(0,7)
var barren_tile_atlas = Vector2i(0,3)

var feature_id = 1
var tree_atlas = 1
var tree2_atlas = 1
var village_atlas = Vector2i(2,3)
# For tile generation

func _ready() -> void:
	GUIDE.enable_mapping_context(default_mapping_context)
	select_unit.triggered.connect(unit_selected)
	move_unit.triggered.connect(unit_moved)
	HexNavi.set_current_map(terrain)
	
	# For tile generation
	humidity_noise = humidity_noise_texture.noise
	humidity_noise.seed = randi()
	altitude_noise = altitude_noise_texture.noise
	altitude_noise.seed = randi()
	tree_noise = tree_noise_texture.noise
	tree_noise.seed = randi()
	village_noise = village_noise_texture.noise
	village_noise.seed = randi()
	generate_world()

func unit_selected() -> void:
	SignalBus.unit_selected.emit()

func unit_moved() -> void:
	var target_tile : Vector2i = HexNavi.global_to_cell(get_global_mouse_position())
	SignalBus.unit_moved.emit(target_tile)
	
func generate_world():
	var humidity_noise_val
	var altitude_noise_val 
	var tree_noise_val 
	var village_noise_val 
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var coords = Vector2i(x,y)
			humidity_noise_val = humidity_noise.get_noise_2d(x,y)
			altitude_noise_val = altitude_noise.get_noise_2d(x,y)
			tree_noise_val = tree_noise.get_noise_2d(x,y)
			village_noise_val = village_noise.get_noise_2d(x,y)
			
			if humidity_noise_val > 0.3:
				set_water(coords)
			elif altitude_noise_val > 0.3:
				set_canyon(coords)
			elif humidity_noise_val > 0.2:
				set_mud(coords)
			elif humidity_noise_val > 0.1:
				set_soil(coords,tree_noise_val,village_noise_val)
			elif humidity_noise_val > 0.075:
				set_fertile(coords,tree_noise_val,village_noise_val)
			elif humidity_noise_val > -0.3:
				set_desert(coords,tree_noise_val,village_noise_val)
			else:
				set_barren(coords,village_noise_val)

#set terrain
func set_water(coords: Vector2i):
	tile_ground.set_cell(coords,ground_id,water_tile_atlas)
	
func set_canyon(coords: Vector2i):
	tile_ground.set_cell(coords,ground_id,canyon_tile_atlas)
	
func set_mud(coords: Vector2i):
	tile_ground.set_cell(coords,ground_id,mud_tile_atlas)
	
func set_soil(coords: Vector2i, tree_val: float, village_val: float):
	tile_ground.set_cell(coords,ground_id,soil_tile_atlas)
	if tree_val > 0.3 and tree_val < 0.5:
		tile_feature.set_cell(coords,feature_id,Vector2i.ZERO,1)
		
func set_fertile(coords: Vector2i, tree_val: float, village_val: float):
	tile_ground.set_cell(coords,ground_id,fertile_tile_atlas)
	if tree_val > 0.3 and tree_val < 0.5:
		tile_feature.set_cell(coords,feature_id,Vector2i.ZERO,1)
		
func set_desert(coords: Vector2i, tree_val: float, village_val: float):
	tile_ground.set_cell(coords,ground_id,desert_tile_atlas)
	if tree_val < -0.4:
		tile_feature.set_cell(coords,feature_id,Vector2i.ZERO,1)
		
func set_barren(coords: Vector2i, landmark_val: float):
	tile_ground.set_cell(coords,ground_id,barren_tile_atlas)
	
