extends CanvasLayer

const text = "Life: "

func initialize(nro):
	$Label.text = text + str(nro)
	
func update(nro):
	$Label.text = text + str(nro)
