extends Area2D

# Signal to tell the puzzle board this specific cell was clicked
signal cell_clicked(grid_position: Vector2)

@onready var color_rect: ColorRect = $ColorRect
var current_color: Color = Color.WHITE

func _ready() -> void:
	# Ensure the Area2D has input pickable turned on so it detects clicks
	input_pickable = true

func set_cell_color(new_color: Color) -> void:
	current_color = new_color
	
	# If the scene is fully loaded, apply the color to the visual rectangle
	if is_node_ready():
		color_rect.color = new_color
	else:
		# Fallback if the node isn't fully ready in memory yet
		await ready
		color_rect.color = new_color

# Godot's built-in event listener for Area2D nodes
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	# Detect when a left mouse button click or a mobile finger tap happens
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_on_cell_tapped()

func _on_cell_tapped() -> void:
	print("Cell clicked! Current color is: ", current_color)
	# Can add game logic here, like cycling to the next color:
	# _cycle_color()

func _cycle_color() -> void:
	# Quick gameplay test: Cycle through RGBY colors when clicked
	if current_color == Color.RED:
		set_cell_color(Color.GREEN)
	elif current_color == Color.GREEN:
		set_cell_color(Color.BLUE)
	elif current_color == Color.BLUE:
		set_cell_color(Color.YELLOW)
	else:
		set_cell_color(Color.RED)
