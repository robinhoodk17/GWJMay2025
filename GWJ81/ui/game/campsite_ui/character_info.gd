extends Control

@onready var portrait: TextureRect = $VBoxContainer/HBoxContainer/Portrait
@onready var character_name: Label = $VBoxContainer/HBoxContainer/Name

@onready var hp_stat: Label = $VBoxContainer/HBoxContainer/Abilities/Hp/HPStat
@onready var speed_stat: Label = $VBoxContainer/HBoxContainer/Abilities/Speed/SpeedStat
@onready var strength_stat: Label = $VBoxContainer/HBoxContainer/Abilities/Strength/StrengthStat
@onready var figh_stat: Label = $VBoxContainer/HBoxContainer/Abilities/Fight/FighStat
@onready var foraging_check: CheckBox = $VBoxContainer/HBoxContainer/Abilities2/Foraging/ForagingCheck
@onready var wood_check: CheckBox = $VBoxContainer/HBoxContainer/Abilities2/WoodStone/WoodCheck
@onready var craft_check: CheckBox = $VBoxContainer/HBoxContainer/Abilities2/Crafting/CraftCheck


var char_name : String
var portrait_texture : CompressedTexture2D

var hp : int = 5
var speed : int = 5
var strength : int = 5
var fight : int = 1
var foraging : bool = true
var wood : bool = true
var crafting : bool = true

func _ready() -> void:
	portrait.texture = portrait_texture
	character_name.text = char_name
	hp_stat.text = str(hp)
	speed_stat.text = str(speed)
	strength_stat.text = str(strength)
	figh_stat.text = str(fight)
	
	foraging_check.button_pressed = foraging
	wood_check.button_pressed = wood
	craft_check.button_pressed = crafting
	
	
