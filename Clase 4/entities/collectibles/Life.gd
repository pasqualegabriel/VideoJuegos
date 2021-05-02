extends CanvasLayer

const text = "Life: "

func initialize(nro):
	$Label.text = text + str(nro)
	
func update(nro):
	if nro >= 0:
		$Label.text = text + str(nro)
	
func lost():
	$Label.text = "You Lost"

func win():
	$Label.text = "You Win"
