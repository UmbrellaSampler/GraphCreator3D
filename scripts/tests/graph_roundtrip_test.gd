extends SceneTree

const TransportGraphScript = preload("res://scripts/transport_graph/transport_graph.gd")
const TransportNodeScript = preload("res://scripts/transport_graph/transport_node.gd")
const TransportLinkScript = preload("res://scripts/transport_graph/transport_link.gd")

const FIRST_SAVE_PATH := "user://graph_roundtrip_a.json"
const SECOND_SAVE_PATH := "user://graph_roundtrip_b.json"

func _init() -> void:
	var graph = _build_sample_graph()
	graph.save_to_json_file(FIRST_SAVE_PATH)

	var loaded = TransportGraphScript.load_from_json_file(FIRST_SAVE_PATH)
	loaded.save_to_json_file(SECOND_SAVE_PATH)

	var first_data = _read_json_dictionary(FIRST_SAVE_PATH)
	var second_data = _read_json_dictionary(SECOND_SAVE_PATH)

	if first_data != second_data:
		push_error("round-trip mismatch: save->load->save changed serialized data")
		quit(1)
		return

	print("graph-roundtrip-test: PASS")
	quit(0)


func _build_sample_graph():
	var graph = TransportGraphScript.new()
	graph.id = "test-graph"
	graph.name = "Roundtrip Test"

	graph.add_node(TransportNodeScript.new("n-a", Vector3(1, 2, 3), "A"))
	graph.add_node(TransportNodeScript.new("n-b", Vector3(4, 5, 6), "B"))
	graph.add_node(TransportNodeScript.new("n-c", Vector3(-1, 0, 9.25), "C"))

	graph.add_link(TransportLinkScript.new(
		"l-ab",
		"n-a",
		"n-b",
		true,
		[Vector3(1.5, 2.5, 3.5), Vector3(2.5, 3.5, 4.5)],
		"A to B"
	))
	graph.add_link(TransportLinkScript.new(
		"l-bc",
		"n-b",
		"n-c",
		false,
		[Vector3(2.0, 2.0, 2.0)],
		"B to C"
	))

	return graph


func _read_json_dictionary(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	assert(file != null, "failed to read test json: %s" % path)

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	assert(parsed is Dictionary, "test json root must be a dictionary")
	var data: Dictionary = parsed
	return data
