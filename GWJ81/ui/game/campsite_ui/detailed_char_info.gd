extends UiPage

@onready var portrait: TextureRect = $VBoxContainer/VBoxContainer2/HBoxContainer/Portrait
@onready var character_name: Label = $VBoxContainer/VBoxContainer2/HBoxContainer/Name

@onready var hp_stat: Label = $VBoxContainer/VBoxContainer2/HBoxContainer/Abilities/Hp/HPStat
@onready var speed_stat: Label = $VBoxContainer/VBoxContainer2/HBoxContainer/Abilities/Speed/SpeedStat
@onready var strength_stat: Label = $VBoxContainer/VBoxContainer2/HBoxContainer/Abilities/Strength/StrengthStat
@onready var figh_stat: Label = $VBoxContainer/VBoxContainer2/HBoxContainer/Abilities/Fight/FighStat
@onready var foraging_check: CheckBox = $VBoxContainer/VBoxContainer2/HBoxContainer/Abilities2/Foraging/ForagingCheck
@onready var wood_check: CheckBox = $VBoxContainer/VBoxContainer2/HBoxContainer/Abilities2/WoodStone/WoodCheck
@onready var craft_check: CheckBox = $VBoxContainer/VBoxContainer2/HBoxContainer/Abilities2/Crafting/CraftCheck
@onready var back: Button = $VBoxContainer/Panel/Back

var pl_char : player_character = null

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
	back.button_up.connect(back_to_campsite)
	SignalBus.showing_character.connect(update_data)

func update_data(_character : player_character) -> void:
	pl_char = _character
	await get_tree().process_frame
	if pl_char == null or !visible or !Globals.characters.has(pl_char):
		return
	portrait.texture = Globals.characters[pl_char]
	character_name.text = pl_char.character_name
	hp_stat.text = str(pl_char.hp , "/", pl_char.max_hp)
	speed_stat.text = str(pl_char.speed)
	strength_stat.text = str(pl_char.strength)
	figh_stat.text = str(pl_char.fighting)
	
	foraging_check.button_pressed = pl_char.hunting_foraging
	wood_check.button_pressed = pl_char.raw_resources
	craft_check.button_pressed = pl_char.crafting

func back_to_campsite() -> void:
	Ui.go_to("CampsiteUI")
