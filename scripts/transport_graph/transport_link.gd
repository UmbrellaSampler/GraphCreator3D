class_name TransportLink
extends Resource


@export var id: String = ""
@export var start_node_id: String = ""
@export var end_node_id: String = ""
@export var directed: bool = false
@export var control_points: Array[Vector3] = []
@export var name: String = ""


func _init(
	link_id: String = "",
	link_start_node_id: String = "",
	link_end_node_id: String = "",
	link_directed: bool = false,
	link_control_points: Array[Vector3] = [],
	link_name: String = ""
) -> void:
	id = link_id
	start_node_id = link_start_node_id
	end_node_id = link_end_node_id
	directed = link_directed
	control_points = link_control_points.duplicate()
	name = link_name


func to_dictionary() -> Dictionary:
	var serialized_control_points: Array[Array] = []
	for control_point in control_points:
		serialized_control_points.append(_vector3_to_array(control_point))

	return {
		"id": id,
		"start_node_id": start_node_id,
		"end_node_id": end_node_id,
		"directed": directed,
		"control_points": serialized_control_points,
		"name": name,
	}


static func from_dictionary(data: Dictionary) -> TransportLink:
	assert(data.has("id"), "link dictionary is missing id")
	assert(data.has("start_node_id"), "link dictionary is missing start_node_id")
	assert(data.has("end_node_id"), "link dictionary is missing end_node_id")
	assert(data.get("control_points", []) is Array, "link control_points must be an array")

	var parsed_control_points: Array[Vector3] = []
	for raw_control_point in data.get("control_points", []):
		parsed_control_points.append(_vector3_from_variant(raw_control_point))

	return TransportLink.new(
		str(data["id"]),
		str(data["start_node_id"]),
		str(data["end_node_id"]),
		bool(data.get("directed", false)),
		parsed_control_points,
		str(data.get("name", ""))
	)


func duplicate_link() -> TransportLink:
	return TransportLink.new(id, start_node_id, end_node_id, directed, control_points, name)


static func _vector3_to_array(value: Vector3) -> Array[float]:
	return [value.x, value.y, value.z]


static func _vector3_from_variant(value: Variant) -> Vector3:
	assert(value is Array, "expected a Vector3 array")
	var components: Array = value
	assert(components.size() == 3, "expected 3 components for Vector3")
	return Vector3(float(components[0]), float(components[1]), float(components[2]))