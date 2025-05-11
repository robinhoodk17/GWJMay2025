extends Node2D
# This scene is started by clicking the "Play" button in main.tscn.
# Change Project Settings: application/run/start_scene to game/game.tscn to skip the menus while developing

@export var default_mapping_context: GUIDEMappingContext
@export var select_unit : GUIDEAction
@export var move_unit : GUIDEAction

func _ready() -> void:
	GUIDE.enable_mapping_context(default_mapping_context)
	select_unit.triggered.connect(unit_selected)
	move_unit.triggered.connect(unit_moved)

func unit_selected() -> void:
	SignalBus.unit_selected.emit()

func unit_moved() -> void:
	SignalBus.unit_moved.emit()
