@tool
extends EditorPlugin

func _enter_tree() -> void:
	pass

func _enable_plugin() -> void:
	if ProjectSettings.get_setting("rust/manifest_path") == null:
		ProjectSettings.set_setting("rust/manifest_path", "")
		ProjectSettings.set_setting("rust/cargo_path", "")

		var info_manifest = {
			"name": "rust/manifest_path",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE,
			"hint_string": "*.toml"
		}
		var info_cargo = {
			"name": "rust/cargo_path",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE,
		}

		ProjectSettings.add_property_info(info_manifest)
		ProjectSettings.add_property_info(info_cargo)
		ProjectSettings.save()
	pass

func _build():
	var output = []
	var cargo_path = ProjectSettings.get_setting("rust/cargo_path")
	var manifest_path = ProjectSettings.get_setting("rust/manifest_path")

	print(!cargo_path, !manifest_path)

	# if no cargo or manifest path just skip building the library
	if !cargo_path or !manifest_path:
		var path_arr = try_get_from_env()
		print(path_arr)

		if !path_arr[0] or !path_arr[1]:
			return

		manifest_path = path_arr[0]
		cargo_path = path_arr[1]

	print("Compiling Rust Code (%s, %s)" % [manifest_path, cargo_path])
	var exit_code = OS.execute(cargo_path, ["build", "--manifest-path", manifest_path], output, true)
	print("Done compiling Rust")
	if exit_code != 0:
		for s in output:
			push_error(s)
	return exit_code == 0

func _exit_tree() -> void:
	pass

func try_get_from_env() -> Array:
	var file_name = "res://.env"

	if !FileAccess.file_exists(file_name):
		return [null, null]

	var file = FileAccess.open(file_name, FileAccess.READ)

	var man_path = null
	var cargo_path = null

	while !file.eof_reached():
		var line = file.get_line()
		var split = line.split("=")

		if split.size() < 2 or split[0] not in ["RUST_MANIFEST_PATH", "RUST_CARGO_PATH"]:
			continue

		var path = split[1].strip_edges().lstrip("\"").rstrip("\"")

		if split[0] == "RUST_MANIFEST_PATH":
			man_path = path
		elif split[0] == "RUST_CARGO_PATH":
			cargo_path = path

	return [man_path, cargo_path]
