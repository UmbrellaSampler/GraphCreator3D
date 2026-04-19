class_name TransportGraph
extends Resource


@export var format_version: String = "0.1"
@export var id: String = ""
@export var name: String = ""
@export var nodes: Array[TransportNode] = []
@export var links: Array[TransportLink] = []


func to_dictionary() -> Dictionary:
	var serialized_nodes: Array[Dictionary] = []
	for node in nodes:
		if node != null:
			serialized_nodes.append(node.to_dictionary())

	var serialized_links: Array[Dictionary] = []
	for link in links:
		if link != null:
			serialized_links.append(link.to_dictionary())

	return {
		"format_version": format_version,
		"id": id,
		"name": name,
		"nodes": serialized_nodes,
		"links": serialized_links,
	}


static func from_dictionary(data: Dictionary) -> TransportGraph:
	assert(data.get("nodes", []) is Array, "graph nodes must be an array")
	assert(data.get("links", []) is Array, "graph links must be an array")

	var graph := TransportGraph.new()
	graph.format_version = str(data.get("format_version", "0.1"))
	graph.id = str(data.get("id", ""))
	graph.name = str(data.get("name", ""))

	for raw_node in data.get("nodes", []):
		assert(raw_node is Dictionary, "graph nodes must contain dictionaries")
		graph.add_node(TransportNode.from_dictionary(raw_node))

	for raw_link in data.get("links", []):
		assert(raw_link is Dictionary, "graph links must contain dictionaries")
		graph.add_link(TransportLink.from_dictionary(raw_link))

	return graph


func to_json() -> String:
	return JSON.stringify(to_dictionary(), "\t")


static func from_json(json_text: String) -> TransportGraph:
	var parsed: Variant = JSON.parse_string(json_text)
	assert(parsed is Dictionary, "graph JSON root must be an object")
	var parsed_dictionary: Dictionary = parsed
	return from_dictionary(parsed_dictionary)


func save_to_json_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	assert(file != null, "failed to open graph JSON for writing: %s" % path)
	file.store_string(to_json())


static func load_from_json_file(path: String) -> TransportGraph:
	var file := FileAccess.open(path, FileAccess.READ)
	assert(file != null, "failed to open graph JSON for reading: %s" % path)
	return from_json(file.get_as_text())


func has_node(node_id: String) -> bool:
	return get_node_by_id(node_id) != null


func get_node_by_id(node_id: String) -> TransportNode:
	for node in nodes:
		if node != null and node.id == node_id:
			return node
	return null


func get_link_by_id(link_id: String) -> TransportLink:
	for link in links:
		if link != null and link.id == link_id:
			return link
	return null


func add_node(node: TransportNode) -> void:
	assert(node != null, "node must not be null")
	assert(node.id != "", "node.id must not be empty")
	assert(not has_node(node.id), "node.id must be unique within the graph")
	nodes.append(node)


func remove_node(node_id: String) -> void:
	for index in range(nodes.size()):
		var node := nodes[index]
		if node != null and node.id == node_id:
			nodes.remove_at(index)
			_remove_links_for_node(node_id)
			return


func add_link(link: TransportLink) -> void:
	assert(link != null, "link must not be null")
	assert(link.id != "", "link.id must not be empty")
	assert(get_link_by_id(link.id) == null, "link.id must be unique within the graph")
	assert(has_node(link.start_node_id), "link.start_node_id must reference an existing node")
	assert(has_node(link.end_node_id), "link.end_node_id must reference an existing node")
	links.append(link)


func remove_link(link_id: String) -> void:
	for index in range(links.size()):
		var link := links[index]
		if link != null and link.id == link_id:
			links.remove_at(index)
			return


func duplicate_graph() -> TransportGraph:
	var result := TransportGraph.new()
	result.format_version = format_version
	result.id = id
	result.name = name
	for node in nodes:
		if node != null:
			result.nodes.append(node.duplicate_node())
	for link in links:
		if link != null:
			result.links.append(link.duplicate_link())
	return result


func _remove_links_for_node(node_id: String) -> void:
	for index in range(links.size() - 1, -1, -1):
		var link := links[index]
		if link != null and (link.start_node_id == node_id or link.end_node_id == node_id):
			links.remove_at(index)