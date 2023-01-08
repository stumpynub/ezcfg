extends Node

const file_name = "configs.cfg" # filename for our config file
var configs: Dictionary = {} # empty dictionary to hold our config values

# signals to emit on save/load Usage e.g., updating UI values on config_saved
signal config_saved 
signal config_loaded

func _ready():
	load_configs() # loads to 'config' dict or creates new file 
	
func delete_config():
	# checks if a file exists, if so delete it 
	if is_file_found():
		DirAccess.remove_absolute("user://" + file_name)
		print_debug("Config file deleted!")
		
func save_config() -> ConfigFile: 
	var config = ConfigFile.new()
	var err = config.save(get_config_path())
	
	if err == OK: 
		return config 
	
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
	if is_file_found(): 
		var file = get_config_file()
		if !file.has_section_key(section, key): 
			file.set_value(section, key, 0)
			file.save(get_config_path())
		return file.get_value(section, key, 0)

func save_value(section, key, value): 
	if is_file_found(): 
		var file = get_config_file()
		file.set_value(section, key, value)
		file.save(get_config_path())
		load_configs()
		
		emit_signal("config_saved")
	else: 
		print_debug("file not found!")
	
func get_config_path() -> String: 
	return "user://" + file_name

func get_config_file() -> ConfigFile: 
	var config: ConfigFile = ConfigFile.new()
	# if no file with the given path is found create a new one 
	if !is_file_found(): 
		return save_config()
		
	config.load(get_config_path())
	return config 

func is_file_found() -> bool:
	var config: ConfigFile = ConfigFile.new()
	var err = config.load(get_config_path())
	
	if err == OK: 
		return true 
		
	return false
