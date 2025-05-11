extends Sprite2D

func _ready() -> void:
	SignalBus.oxygen_radius_changed.connect(update_radius)

func update_radius(new_radius : float = 3.0) -> void:
	scale = Vector2(new_radius,new_radius)
