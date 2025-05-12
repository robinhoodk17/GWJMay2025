extends Control

@onready var _campsite: campsite = $".."

@export_group("tooltip buttons")
@export var move_button : Button
@export var setup_button : Button
@export var build_button : Button

func _ready() -> void:
	_campsite.showing_tooltip.connect(show_tooltip)
	_campsite.hiding_tooltip.connect(hide_tooltip)
	hide()

func show_tooltip() -> void:
	if _campsite.mobile:
		move_button.disabled = false
		build_button.disabled = true
	if !_campsite.mobile:
		move_button.disabled = true
		build_button.disabled = false
	show()
	SignalBus.campsite_showing_tooltip.emit(true)
func hide_tooltip() -> void:
	hide()
	SignalBus.campsite_showing_tooltip.emit(false)
