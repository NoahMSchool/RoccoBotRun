import bpy
from mathutils import Vector

grid_width = 4
grid_spacing = 1

print("========================================================")
def test_func():
    print("test sucess")
    
#class BlockManagement:      
def get_highest_id(container):
    highest = -1
    for m in container.children:
        ml_id = m.get("mesh_lib_id")
        if ml_id != None:
            if ml_id > highest:
                print("swapping to ", ml_id)
                highest = ml_id
    print("highest", highest)
    return highest

def add_to_collection(container, name, mesh, col_mesh):
    obj = bpy.data.objects.new(name=name, object_data=mesh)
    obj["mesh_lib_id"] = get_highest_id(container)+1
    bpy.context.collection.objects.link(obj)
    col_obj = bpy.data.objects.new(name=(name+"-colonly"), object_data=col_mesh)
    bpy.context.collection.objects.link(col_obj)
    obj.parent = container
    col_obj.parent = obj
    gridify_container_children(container)
    set_selection_and_visibility_of_collisions(current_container, False, False)


def add_by_reference(container, name, reference):
    ref_mesh = reference.data
    ref_col = reference.children[0].data
    add_to_collection(container, name, ref_mesh, ref_col)

def gridify_container_children(container):
    container_children = container.children
    container_children = sorted(container_children, key=lambda c:c["mesh_lib_id"])
    for i in range(len(container_children)):
        container_children[i].location = Vector((0.5+(i//grid_width)*grid_spacing, 0.5+(i%grid_width)*grid_spacing, 0.5))

def set_selection_and_visibility_of_collisions(container, selectable, visible):
    #print(container.children)
    if len(container.children) == 0:
         return
    for obj in container.children:
        child = obj.children[0]
        child.hide_select = not selectable
        child.hide_set(not visible)

def unwrap_children(container):
    container_children = container.children

    #UV unwraping
    bpy.ops.object.mode_set(mode='OBJECT')
    bpy.ops.object.select_all(action='DESELECT')
    for obj in container_children:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = container_children[0]
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.uv.smart_project(island_margin=0.005)
    bpy.ops.object.mode_set(mode='OBJECT')
    bpy.ops.object.select_all(action='DESELECT')

def bake_atlas_texture(container, bake_type = "color"):
    unwrap_children(container)
    #give it unique name
    all_names = []
    for t in bpy.data.images:
        all_names.append(t.name)
    texture_name = ""
    num = 0
    while texture_name == "" or texture_name in all_names:
        texture_name = container.name+"_"+bake_type+"_atlas"+str(num)
        num = num + 1
        print(texture_name)

    #make texture
    texture = bpy.data.images.new(texture_name,width=1048, height=1048, alpha = False)
    texture.file_format = 'PNG'
    texture.filepath_raw = '/Users/noahmarks/Desktop/Godot/RoccoBotRun/Environment/GridMapMaterialAtlases/'+texture.name+".png"
    #get list of used materials
    container_children = container.children
    used_materials = []
    for obj in container_children:
        for m in obj.data.materials:
            if m is not None:
                if m not in used_materials:
                    used_materials.append(m)

    #add image texture node to all materials
    bake_nodes = []
    for mat in used_materials:
        mat.use_nodes = True
        nodes = mat.node_tree.nodes
        tex_node = nodes.new(type="ShaderNodeTexImage")
        bake_nodes.append(tex_node)
        tex_node.image = texture
        nodes.active = tex_node
    #select all objects
    bpy.ops.object.mode_set(mode='OBJECT')
    bpy.ops.object.select_all(action='DESELECT')
    for obj in container_children:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = container_children[0]
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.object.mode_set(mode='OBJECT')    
    #bake
    bpy.context.scene.render.engine = 'CYCLES'
    if bake_type == "color":
        bpy.ops.object.bake(
        type='DIFFUSE',
        pass_filter={'COLOR'},   # base color only, no lighting baked in
        margin=4,
        margin_type='EXTEND',
        use_selected_to_active=False,
        save_mode='INTERNAL'
        )
    elif bake_type == "roughness":
        bpy.ops.object.bake(
        type='ROUGHNESS',
        pass_filter={'COLOR'},   # base color only, no lighting baked in
        margin=4,
        margin_type='EXTEND',
        use_selected_to_active=False,
        save_mode='INTERNAL'
        )
    elif bake_type == "normal":
        bpy.ops.object.bake(
        type='NORMAL',
        pass_filter={'COLOR'},   # base color only, no lighting baked in
        margin=4,
        margin_type='EXTEND',
        use_selected_to_active=False,
        save_mode='INTERNAL'
        )
    for n in bake_nodes: #remove tempory bake nodes
        n.id_data.nodes.remove(n)
    texture.save()
    bpy.ops.object.select_all(action='DESELECT') #deselect all

current_container = bpy.data.objects["SpaceCityBlocks"]

#add_to_collectioncurrent_container, "stevebob", mesh_object, mesh_object)
#add_by_reference(current_container, "DarkMarbleBlock", bpy.data.objects["021DarkMarbleBlock"])

#set_selection_and_visibility_of_collisions(bpy.data.objects["SpaceCityBlocks"], False, False)
#set_selection_and_visibility_of_collisions(bpy.data.objects["CathedralCityBlocks"], False, False)

#gridify_container_children(current_container)
#unwrap_children(current_container)
bake_atlas_texture(current_container, "normal")

'''
terminal commands
#assign variable to call fucntions from terminal;
manage_blocks = bpy.data.texts[1].as_module();
#add the block;
manage_blocks.add_by_reference(bpy.data.objects["CathedrLoalCityBlocks"], "Hello there", bpy.contexts.object)

'''