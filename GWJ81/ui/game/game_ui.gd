extends UiPage

@onready var end_turn_button: Button = $MarginContainer/EndTurnButton

func _ready() -> void:
	end_turn_button.button_up.connect(turn_end)


func turn_end() -> void:
	SignalBus.turn_ended.emit()
	SignalBus.turn_started.emit()
