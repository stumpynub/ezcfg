extends Control


@onready var hslider1 = $CenterContainer/VBoxContainer3/SliderValue1/HSlider
@onready var hslider2 = $CenterContainer/VBoxContainer3/SliderValue2/HSlider2
@onready var checkbox = $CenterContainer/VBoxContainer3/CheckboxValue/CheckBox
@onready var ez_cfg: EzCfg = $EzCfg
	

# Called when the node enters the scene tree for the first time.
func _ready():
	ez_cfg.load_file()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_check_box_toggled(button_pressed):
	ez_cfg.save_value("settings", "checkbox", button_pressed)

func _on_h_slider_value_changed(value):
	ez_cfg.save_value("settings", "slider1", value)

func _on_h_slider_2_value_changed(value):
	ez_cfg.save_value("settings", "slider2", value)

func _on_ez_cfg_loaded():
	hslider1.value = ez_cfg.get_value("settings", "slider1")
	hslider2.value = ez_cfg.get_value("settings", "slider2")
	checkbox.button_pressed = ez_cfg.get_value("settings", "checkbox")
