class_name Game extends Control

## Seconds before the ball starts to decay.
@export_range(1, 20) var ball_lifetime: float

@onready var click_button: Button = $VBoxContainer/ClickButton
@onready var counter_label: RichTextLabel = $VBoxContainer/CounterLabel

const BALL = preload("res://ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	click_button.pressed.connect(_button_pressed)

func _button_pressed():
	# Shrink the button. Note that it never actually becomes unclickable :(
	var button_font_size := click_button.get_theme_font_size("font_size")
	click_button.add_theme_font_size_override("font_size", max(button_font_size - 1, 1))
	
	# Embiggen the counter label
	var label_font_size := counter_label.get_theme_font_size("normal_font_size")
	counter_label.add_theme_font_size_override("normal_font_size", label_font_size + 1)
	
	# Also increment the counter text
	var counter_value: = counter_label.text.to_int()
	counter_label.text = str(counter_value + 1)
	
	# Create a random "ball" for the lulz
	var ball := BALL.instantiate()
	var velocity := Vector2(1000, 0).rotated(randf() * 2 * PI)
	ball.linear_velocity = velocity
	add_child(ball)
	ball.global_position = get_global_mouse_position()
	
	# Fade the ball out to a random transparent color after a while
	var timer := get_tree().create_timer(ball_lifetime)
	timer.timeout.connect(func(): 
		var tween = get_tree().create_tween()
		var color := Color(randf(), randf(), randf(), 0)
		tween.tween_property(ball, "modulate", color, 1)
		tween.tween_callback(func(): ball.queue_free())
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
