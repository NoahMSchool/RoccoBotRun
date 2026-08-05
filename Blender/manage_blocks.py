import bpy
from mathutils import Vector

grid_width = 4
grid_spacing = 1

print("========================================================")

#class BlockManagement:      
def get_highest_id(container):
    highest = -1
    for m in container.children:
        ml_id = m.get("mesh_lib_id")
        print(m.name, ml_id, "highest", highest)
        print(ml_id>highest)
        print(ml_id==None)
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



current_container = bpy.data.objects["CathedralCityBlocks"]

mesh_object = bpy.data.meshes["Cube.001"]

#add_to_collection(current_container, "stevebob", mesh_object, mesh_object)
#add_by_reference(current_container, "DarkMarbleBlock", bpy.data.objects["021DarkMarbleBlock"])

#set_selection_and_visibility_of_collisions(current_container, False, False)
#gridify_container_children(current_container)
unwrap_children(current_container)