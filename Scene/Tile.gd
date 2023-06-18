extends TextureButton
class_name Tile

signal buttonPressed(id)
signal flagPressed(id)
signal cordPresed(id)


var id = 0 # current objec ID
var tilehidden = true # is the tile contents hidden
var flag = false # is it a flag
var mine = false # is it a mine
var tile_position : Vector2i # current position
var mineCount = 0

func _process(delta):
	$Label.text = str(mineCount)
	if mine:
		$Label.text = "* " + str(mineCount)


func addCount():
	mineCount += 1
	

func subCount():
	mineCount -= 1


func addMine():
	mine = true

func removeMine():
	mine = false
	mineCount -= 1
	
func press():
	if !flag:
		_on_pressed()
#	if tilehidden:
#		tilehidden = false
#		_on_pressed()

func test():
	print("tile test ID: " + str(id) + " obj: " + str(self))

func _on_pressed():
	#print("pressed: " + str(id))
	emit_signal("buttonPressed", id)
	#disabled = true
	
func setVisiblie():
	$Cord.visible = true
	$Flag.visible = false
	
func UpdateImage(image):
	texture_normal = image
	texture_pressed = image

func toggleLableVis():
	$Label.visible = !$Label.visible
	
	
	
func _on_flag_pressed():
	emit_signal("flagPressed", id)


func _on_cord_pressed():
	emit_signal("cordPresed", id)
