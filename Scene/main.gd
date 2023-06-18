extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().size = $MarginContainer.size
	$MarginContainer/VBoxContainer/HBoxContainer/FlagsTotal.text = "0"
	$MarginContainer/VBoxContainer/HBoxContainer/BombTotal.text = "0"
	$MarginContainer/VBoxContainer/GameControler.connect("flagCountChange", updateFlagTotal)
	$MarginContainer/VBoxContainer/GameControler.connect("bombCountChange", updateBombTotal)
	$MarginContainer/VBoxContainer/GameControler.connect("EndGameLose", isEndGameLose)
	$MarginContainer/VBoxContainer/GameControler.connect("EndGameWin", isInGameWin)
	$MarginContainer/Menu/CenterContainer/VBoxContainer/GameEndMessage.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnResume.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnCheet.visible = false




func updateFlagTotal(count):
	$MarginContainer/VBoxContainer/HBoxContainer/FlagsTotal.text = str(count)

func updateBombTotal(count):
	$MarginContainer/VBoxContainer/HBoxContainer/BombTotal.text = str(count)

func isEndGameLose():
	$MarginContainer/Menu.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnResume.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/GameEndMessage.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnCheet.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/GameEndMessage.text = "YOU LOSE"
	
func isInGameWin():
	$MarginContainer/Menu.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnResume.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/GameEndMessage.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnCheet.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/GameEndMessage.text = "YOU WIN"


func _on_btn_menu_pressed():
	$MarginContainer/Menu.visible = true
	


func _on_btn_easy_pressed():
	get_tree().call_group("GameBord", "GameReset", 9, 9, 10)
	$MarginContainer/Menu.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnResume.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnCheet.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/GameEndMessage.visible = false


func _on_btn_med_pressed():
	get_tree().call_group("GameBord", "GameReset", 16, 16, 40)
	$MarginContainer/Menu.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnResume.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnCheet.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/GameEndMessage.visible = false


func _on_btn_hard_pressed():
	get_tree().call_group("GameBord", "GameReset", 24, 24, 99)
	$MarginContainer/Menu.visible = false
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnResume.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/BtnCheet.visible = true
	$MarginContainer/Menu/CenterContainer/VBoxContainer/GameEndMessage.visible = false


func _on_btn_exit_pressed():
	get_tree().quit()
	



func _on_btn_resume_pressed():
	$MarginContainer/Menu.visible = false



func _on_margin_container_resized():
	get_window().size = $MarginContainer.size



func _on_btn_cheet_pressed():
	get_tree().call_group("Tiles", "toggleLableVis")

