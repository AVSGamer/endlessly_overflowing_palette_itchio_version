extends Control

@onready var main_menu_screen: MarginContainer = $StaticUIOverlay/MainMenuScreen
@onready var game_level_container: Node2D = $GameLevelContainer
@onready var ad_container: MarginContainer = $StaticUIOverlay/AdContainer

# Preload core scenes
const PUZZLE_GAMEPLAY_SCENE = preload("res://src/scenes/puzzle_board.tscn")
const STAGE_EDITOR_SCENE = preload("res://src/scenes/stage_editor.tscn")

func _ready() -> void:
	main_menu_screen.show()
	_clear_current_container()
	
	# If this is the paid desktop/android build, completely hide the web ad container
	#if OS.has_feature("windows") or OS.has_feature("linux") or OS.has_feature("android"):
	#	ad_container.queue_free()

# ─── BUTTONS ROUTING ───
func _on_play_preset_stages_pressed() -> void:
	var game_instance = _transition_to_game()
	game_instance.start_mode("preset") # Tells the grid to load Stage 1, Stage 2, etc.

func _on_import_play_custom_stage_pressed() -> void:
	var game_instance = _transition_to_game()
	game_instance.start_mode("import") # Triggers a text-box or file reader to paste grid data

func _on_play_endless_randomized_pressed() -> void:
	var game_instance = _transition_to_game()
	game_instance.start_mode("endless") # Tells the grid generator to randomize colors/sizes

func _on_stage_editor_pressed() -> void:
	main_menu_screen.hide()
	_clear_current_container()
	
	var editor_instance = STAGE_EDITOR_SCENE.instantiate()
	game_level_container.add_child(editor_instance)
	editor_instance.return_to_menu.connect(_on_return_to_menu)

func _on_exit_pressed() -> void:
	# Web browsers ignore quit commands, so only execute on desktop/mobile builds
	if OS.has_feature("pc"):
		get_tree().quit()
	else:
		print("Exit requested (Ignored on Web/Browser platform)")

# ─── CORE PIPELINE METHODS ───
func _transition_to_game() -> Node:
	main_menu_screen.hide()
	_clear_current_container()
	
	var game_instance = PUZZLE_GAMEPLAY_SCENE.instantiate()
	game_level_container.add_child(game_instance)
	game_instance.return_to_menu.connect(_on_return_to_menu)
	return game_instance

func _on_return_to_menu() -> void:
	_clear_current_container()
	main_menu_screen.show()

func _clear_current_container() -> void:
	for child in game_level_container.get_children():
		child.queue_free()
