extends Node2D
signal return_to_menu
@onready var board_background: ColorRect = $GridAnchor/BoardBackground
@onready var grid_anchor: Marker2D = $GridAnchor
@onready var label: Label = $GameplayUI/TopBar/HBoxContainer/lbl_StageMode

var cell_scene = preload("res://src/scenes/grid_cell.tscn") # The individual cell asset
var grid_width: int = 5
var grid_height: int = 5
var cell_size: float = 64.0 # Pixel dimensions of your cell sprites/boxes

func _ready() -> void:
	# Hide or clear placeholder elements on start
	label.text = "Initializing..."

# ─── THE ROUTING METHOD ───
func start_mode(mode_type: String) -> void:
	match mode_type:
		"preset":
			label.text = "Preset Stage"
			_load_preset_level_data()
		"import":
			label.text = "Custom Stage"
			_open_import_dialog()
		"endless":
			label.text = "Endless Mode"
			_generate_random_procedural_grid()

# ─── CORE LAYOUT ENGINE ───
func _generate_grid_layout(color_data_matrix: Array) -> void:
	# Clear out any old board components first
	for child in grid_anchor.get_children():
		child.queue_free()
	# Center the GridAnchor based on the total width and height of the puzzle board
	var total_width = grid_width * cell_size
	var total_height = grid_height * cell_size
	# Centers the grid anchor on responsive layout screen
	var screen_center = get_viewport_rect().size / 2
	grid_anchor.position = screen_center - Vector2(total_width / 2, total_height / 2)
	
	# These below doesn't seem to work...
	board_background.size = Vector2(total_width + 40, total_height + 40)
	board_background.position = Vector2(-20, -20)
	board_background.show_behind_parent = false
	board_background.z_index = -1
	board_background.z_as_relative = false

	# Build the grid using loop counters
	for y in range(grid_height):
		for x in range(grid_width):
			var cell_instance = cell_scene.instantiate()		
			# Position each item inside the local anchor offset framework
			cell_instance.position = Vector2(x * cell_size, y * cell_size)
			grid_anchor.add_child(cell_instance)
			# Assign its specific RGBY color from passed data matrix array
			var cell_color = color_data_matrix[y][x]
			cell_instance.set_cell_color(cell_color)

# ─── GENERATION WRAPPERS ───
func _generate_random_procedural_grid() -> void:
	grid_width = 4
	grid_height = 4
	var matrix = []
	var available_colors = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW]
	
	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			row.append(available_colors.pick_random()) # Choose a random RGBY color
		matrix.append(row)
		
	_generate_grid_layout(matrix)

func _load_preset_level_data() -> void:
	# Hardcoded fallback matrix example for Testing
	grid_width = 3
	grid_height = 3
	var test_matrix = [
		[Color.RED, Color.BLUE, Color.RED],
		[Color.GREEN, Color.YELLOW, Color.GREEN],
		[Color.BLUE, Color.RED, Color.BLUE]
	]
	_generate_grid_layout(test_matrix)

func _open_import_dialog() -> void:
	# Placeholder configuration: To be replaced by custom layout UI panel logic
	_load_preset_level_data()

# ─── INTERACTION UI ───
func _on_back_to_menu_button_pressed() -> void:
	return_to_menu.emit()
