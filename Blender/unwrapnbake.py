import bpy
from mathutils import Vector

print("========================================================")

def unwrap(objs):

    #UV unwraping
    bpy.ops.object.mode_set(mode='OBJECT')
    bpy.ops.object.select_all(action='DESELECT')
    for obj in objs:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = objs[0]
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='SELECT')
    bpy.ops.uv.smart_project(island_margin=0.005)
    bpy.ops.object.mode_set(mode='OBJECT')
    bpy.ops.object.select_all(action='DESELECT')

def bake_atlas_texture(objs, name, bake_type = "color"):
    unwrap(objs)
    #give it unique name
    all_names = []
    for t in bpy.data.images:
        all_names.append(t.name)
    texture_name = ""
    num = 0
    while texture_name == "" or texture_name in all_names:
        texture_name = name+"_"+bake_type+"_atlas"+str(num)
        num = num + 1
        print(texture_name)

    #make texture
    texture = bpy.data.images.new(texture_name,width=1048, height=1048, alpha = False)
    texture.file_format = 'PNG'
    #texture.filepath_raw = save_path+name+".png"
    #get list of used materials
    
    used_materials = []
    for obj in objs:
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
    for obj in objs:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = objs[0]
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
    #texture.save()
    bpy.ops.object.select_all(action='DESELECT') #deselect all


#terminal commands
#assign variable to call fucntions from terminal;
#unwrapnbake = bpy.data.texts[1].as_module();

#save_path = "/Users/noahmarks/Desktop/Godot/RoccoBotRun/Environment/GridMapMaterialAtlases/"
name = "bob"

bake_atlas_texture(bpy.context.selected_objects, name)