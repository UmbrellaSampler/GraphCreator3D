class_name TransportNode
extends Resource


@export var id: String = ""
@export var position: Vector3 = Vector3.ZERO
@export var name: String = ""


func _init(node_id: String = "", node_position: Vector3 = Vector3.ZERO, node_name: String = "") -> void:
	id = node_id
	position = node_position
	name = node_name


func to_dictionary() -> Dictionary:
	return {
		"id": id,
		"position": _vector3_to_array(position),
		"name": name,
	}


static func from_dictionary(data: Dictionary):
	assert(data.has("id"), "node dictionary is missing id")
	assert(data.has("position"), "node dictionary is missing position")
	var node_script: Script = load("res://scripts/transport_graph/transport_node.gd")
	return node_script.new(
		str(data["id"]),
		_vector3_from_variant(data["position"]),
		str(data.get("name", ""))
	)


func duplicate_node():
	var node_script: Script = get_script()
	return node_script.new(id, position, name)


static func _vector3_to_array(value: Vector3) -> Array[float]:
	return [value.x, value.y, value.z]


static func _vector3_from_variant(value: Variant) -> Vector3:
	assert(value is Array, "expected a Vector3 array")
	var components: Array = value
	assert(components.size() == 3, "expected 3 components for Vector3")
	return Vector3(float(components[0]), float(components[1]), float(components[2]))