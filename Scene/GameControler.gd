extends GridContainer

var width = 3
var height = 3
var mines = 1

signal flagCountChange(count)
signal bombCountChange(count)
signal GameStateChange(state)
signal EndGameWin()
signal EndGameLose()


var boardActive = false

#tile images
const tileImages = {
	"hidden": preload("res://tiles/hidden.png"),
	"flag": preload("res://tiles/flag.png"),
	"0": preload("res://tiles/empty.png"),
	"1": preload("res://tiles/one.png"),
	"2": preload("res://tiles/two.png"),
	"3": preload("res://tiles/three.png"),
	"4": preload("res://tiles/four.png"),
	"5": preload("res://tiles/five.png"),
	"6": preload("res://tiles/six.png"),
	"7": preload("res://tiles/seven.png"),
	"8": preload("res://tiles/eight.png"),
	"mine": preload("res://tiles/mine.png"),
	"minehit": preload("res://tiles/minehit.png"),	
}

var tileScn = preload("res://Scene/Tile.tscn")
var totalTiles
var mine_ids = [] # Array containing all mine tile IDs
var tile_array = [] # Array containing all non-mine tile IDs
var numEmptyTiles = 0
var numRevealedTiles = 0
var flagCount = 0
var firstClick = true


#func _ready():
#	GameReset()
	
	
# when you click on a tile this runs
func TileRevealed(id : int):
	if not GameActive(): return
	
	#print("tile revealed: " + str(id))
	var _tile : Tile = get_child(id)
	if _tile.flag: return
	if _tile.tilehidden:
		_tile.tilehidden = false
	

	if firstClick and _tile.mine:
		MoveMine(_tile.id)
		#if you click on a mine, move the mine to another open sqaure
	firstClick = false
	if _tile.mine:
		GameLose()
		_tile.UpdateImage(tileImages["minehit"])
	else:
		_tile.UpdateImage(tileImages[str(_tile.mineCount)])
	
	tile_array.erase(_tile.id)
	
		
		
	if _tile.mineCount == 0:
		var cascade = GetNeighbors(_tile)
		for t in cascade:
			if t.tilehidden:
				t.press() 
	_tile.setVisiblie()
	

	if tile_array.size() == 0:
		GameWin()
	
#right clicking on a tile sets the flag
func flagToggle(id):
	if not GameActive(): return
	
	var _tile : Tile = get_child(id)
	if !_tile.tilehidden: return
	
	_tile.flag = !_tile.flag
	
	if _tile.flag:
		_tile.UpdateImage(tileImages["flag"])
		flagCount += 1
		emit_signal("flagCountChange", flagCount)
	else:
		_tile.UpdateImage(tileImages["hidden"])
		flagCount -= 1
		emit_signal("flagCountChange", flagCount)

# when the tile is empty you can reveal all the sorunding tiles 
# if you have the right number of flags
func TileCord(id : int):
	if not GameActive(): return
	#print("cord " + str(id))
	var _tile : Tile = get_child(id)
	var neighbor
	var flagcount = 0
	
	neighbor = GetNeighbors(_tile)
	
	for nei in neighbor:
		if nei.flag:
			flagcount += 1
	
	if flagcount == _tile.mineCount:
		for nei in neighbor: 
			nei.press()


func SetupBoard():
	#black magic that is stolen
	for tile in totalTiles:
		var curTile = tileScn.instantiate()
		curTile.id = tile 
		var x = tile % width
		var y = tile / width
		curTile.tile_position = Vector2i(x,y)
		tile_array.push_back(tile)
		curTile.connect("buttonPressed", TileRevealed)
		curTile.connect("flagPressed", flagToggle)
		curTile.connect("cordPresed", TileCord)
		add_child(curTile)


func SetupMines():
	#black magic that is stolen
	for _n in mines:
		# Choose random index from array
		var rand_idx = randi_range(0,tile_array.size()-1)
		var tile_id = tile_array[rand_idx]
		var target = get_child(tile_id)
		target.addMine()
		target.addCount()
		var getN = GetNeighbors(target)
		for _neighbor in getN:
			_neighbor.addCount()
		# Remove ID from array when mine chosen so it cannot get chosen again
		tile_array.remove_at(rand_idx) # Can be slow, but it is better than a while loop
		mine_ids.push_back(tile_id)

func MoveMine(id):
	var _tile : Tile = get_child(id)
	var _neighbor = GetNeighbors(_tile)
	for n in _neighbor:
		n.subCount()
	_tile.removeMine()
	mine_ids.erase(_tile.id)
	var rand_idx = randi_range(0,tile_array.size()-1)
	var newMine = get_child( tile_array[rand_idx] )
	newMine.addMine()
	_neighbor = GetNeighbors(newMine)
	for n in _neighbor:
		n.addCount()




func GetNeighbors(tile) -> Array:
	#black magic that is stolen
	var _neightbors = []
	for xd in 3:
			for yd in 3:
				if yd == 1 and xd == 1: continue # No infinite looping!
				var x = xd-1 + tile.tile_position.x # -1, 0, 1
				var y = yd-1 + tile.tile_position.y
				if x < 0 or x > width-1: continue
				if y < 0 or y > height-1: continue
				var target = get_child(getid(Vector2i(x,y)))
				_neightbors.append(target)
	return _neightbors


func getid(vector : Vector2i):
	return vector.y * width + vector.x
	
func GameActive() -> bool: 
	return boardActive

func ToggleActive():
	boardActive = !boardActive

func GameStart():
	print("game start")
	boardActive = true

func GameLose():
	print("game over")
	boardActive = false
	for m in mine_ids:
		var n = get_child(m)
		n.UpdateImage(tileImages["mine"])
	emit_signal("EndGameLose")
	
	
func GameWin():
	print("game win")
	boardActive = false
	emit_signal("EndGameWin")
#	for n in tile_array:
#		var _tile = get_child(n)
#		_tile.UpdateImage(tileImages[str(_tile.mineCount)])

func GameReset(_width, _height, _bombs):
	width = _width
	height =_height
	mines = _bombs
	
	# remove children if you can
	if get_child_count() != 0:
		for n in get_children():
			remove_child(n)
			n.queue_free()
	
	mine_ids.clear()
	tile_array.clear()
	
	columns = width
	totalTiles = width * height
	SetupBoard()
	SetupMines() 
	numEmptyTiles = tile_array.size()
	emit_signal("bombCountChange", mines)
	boardActive = true
	firstClick = true
























