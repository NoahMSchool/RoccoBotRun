@tool
extends GLTFDocumentExtension



func _import_node(state: GLTFState, gltf_node: GLTFNode, json: Dictionary, node: Node) -> Error:
	if json.has("extras"):
		#print(node.name, json)
		var extras = json["extras"]
		
		for key in extras:
			if key == "mesh_lib_id":
				node.set_meta(key, int(extras[key]))
	return OK
