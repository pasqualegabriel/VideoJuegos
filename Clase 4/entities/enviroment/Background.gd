extends TextureRect

export var color: Color

func _ready():
	modulate = color
