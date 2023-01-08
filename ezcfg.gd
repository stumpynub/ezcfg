extends Node

# path root where our file will be saved
# 0 = project folder 
# 1 = users folder (persistent data) 
@export_enum(res, user) var path_root = 1

const filename = "config" # filename for our config file
var configs: Dictionary = {} # empty dictionary to hold our config values

# signals to emit on save/load Usage e.g., updating UI values on config_saved
signal config_saved 
signal config_loaded

func _ready():
	load_configs() # load any saved config file to the configs dict 
	
func delete_config():
	# checks if a file exists, if so delete it 
	if is_file_found():
		DirAccess.remove_absolute(get_config_path())
		print_debug("Config file deleted!")
		
func save_config(file=get_config_file()) -> ConfigFile: 
	var config = ConfigFile.new()
	
	if file: 
		config = file
	
	var err = config.save(get_config_path())
	if err == OK: 
		print_debug("saved!")
		config.save(get_config_path())
		load_configs()
		return config 
	
	emit_signal("config_saved")
	return ConfigFile.new()
	
func load_configs(): 
	if is_file_found(): 
		var cfg: ConfigFile = get_config_file()
		for section in cfg.get_sections(): 
			configs[section] = {}
			for key in cfg.get_section_keys(section):
				configs[section][key] = cfg.get_value(section, key)
	else: 
		save_config()
		
	emit_signal("config_loaded")
	
func get_config_value(section, key): 
	# returns the request value from our cfg file
	if is_file_found(): 
		var file = get_config_file()
		
		# if no value is found save a new value with the given params
		# TODO: may not be desired outcome so make an option to not save 
		if !file.has_section_key(section, key): 
			file.set_value(section, key, 0)
			save_config(file)
		return file.get_value(section, key, 0)

func save_config_value(section, key, value): 
	if is_file_found():  
		var file = get_config_file()
		file.set_value(section, key, value)
		save_config(file)
	else: 
		print_debug("file not found!")
	
func get_config_file() -> ConfigFile: 
	var config: ConfigFile = ConfigFile.new()
	# if no file with the given path is found create a new one 
	if !is_file_found(): 
		return save_config()
		
	config.load(get_config_path())
	return config 
	
func get_path_root() -> String: 
	# returns path root where our file will be saved 
	# 0 = project folder
	# 1 = users folder (persistent data) 
	if path_root == 0: 
		return "res"
		print_debug(
			"Path is set to the project folder! Change the {path} propertry before exporting"
			)
	return "user"
	
func get_config_path() -> String: 
	var file_extention = ".cfg"
	return get_path_root() + "://" + filename + file_extention
	
func is_file_found() -> bool:
	var config: ConfigFile = ConfigFile.new()
	var err = config.load(get_config_path())
	
	if err == OK: 
		return true 

	return false
