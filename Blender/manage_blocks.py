import bpy
from mathutils import Vector

grid_width = 6
grid_spacing = 2

print("========================================================")

class BlockCollection:
    def __init__(self, name):
        #self.container_object = 
        self.name = name
        print(name)        
    def add_to_collection(object):
        print("adding")

        return
    

#spaceblocks = BlockCollection("seee")


def gridify_container_children(container):
    container_children = container.children
    for i in range(len(container_children)):
        print(container_children[i].name)
        container_children[i].location = Vector((0.5+(i//grid_width)*grid_spacing, 0.5+(i%grid_width)*grid_spacing, 0.5))

def set_selection_and_visibility_of_collisions(container, selectable, visible):
    #print(container.children)
    if len(container.children) == 0:
        print("nochildren")
        return
    for obj in container.children:
        print("hji")
        child = obj.children[0]
        child.hide_select = not selectable
        child.hide_set(not visible)



current_container = bpy.data.objects["SpaceCityBlocks"]

gridify_container_children(current_container)
set_selection_and_visibility_of_collisions(current_container, False, False)