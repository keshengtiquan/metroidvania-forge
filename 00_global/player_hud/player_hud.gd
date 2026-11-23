extends CanvasLayer
@onready var hp_margin_container: MarginContainer = %HpMarginContainer
@onready var hp_bar: TextureProgressBar = %HpBar


func _ready() -> void:
	Messages.player_healed_changed.connect(update_health_bar)
	pass

func update_health_bar(hp: float, max_hp: float) -> void:
	var value: float = hp / max_hp * 100
	hp_bar.value = value
	hp_margin_container.size.x = max_hp + 22
	pass
