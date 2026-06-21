import bpy
import math
import random


RNG = random.Random(42)


def get_scene():
    return bpy.context.scene


def ensure_collection(name, color_tag="COLOR_04"):
    scene = get_scene()
    col = bpy.data.collections.get(name)
    if col is None:
        col = bpy.data.collections.new(name)
        scene.collection.children.link(col)
    if hasattr(col, "color_tag"):
        col.color_tag = color_tag
    return col


def move_object_to_collection(obj, target_col):
    if obj.name not in target_col.objects:
        target_col.objects.link(obj)
    for col in tuple(obj.users_collection):
        if col != target_col:
            col.objects.unlink(obj)


def organize_scene_for_cloud():
    rules = [
        ("HQ_Tower", ("HQ_",)),
        ("Residential_Left", ("JK_L",)),
        ("Residential_Right", ("JK_R",)),
        ("Neighbor_Towers", ("T0_", "T1_", "T2_", "T3_", "T4_", "T5_", "T6_", "T7_", "T8_", "T9_", "T10", "T11", "T12", "T13", "T14")),
        ("Cars", ("Car",)),
        ("Fireworks", ("FW_",)),
        ("Trees_Lamps", ("Tr_", "Lp_")),
        ("Ground_Roads", ("Ground", "Road", "Plaza", "Pavement", "Embankment", "Water")),
        ("Gate_Entrance", ("Gate_", "Restaurant", "Rest_")),
        ("Infrastructure", ("Fountain", "Bench", "Flower", "Bike", "Play", "Sandbox", "Parking", "Park_", "Pspot", "Path_")),
        ("Mountains", ("Mount_", "Hill_", "Snow_", "MtnFog", "HorizonFog")),
        ("Fog_Lights", ("Fog", "Moon", "Fill", "Rim", "Side", "Uplight", "Glow", "Sunset", "Cold")),
        ("Skyline", ("Sky_",)),
        ("Camera", ("CineCamera", "CamTarget")),
        ("Logo_Text", ("FinalTitle", "FinalSubtitle", "LogoA", "Gate_Text", "RestaurantSign")),
        ("Cranes", ("Crane",)),
    ]

    matched = set()
    objects = list(get_scene().objects)
    for col_name, keywords in rules:
        col = ensure_collection(col_name)
        for obj in objects:
            if any(key in obj.name for key in keywords):
                move_object_to_collection(obj, col)
                matched.add(obj.name)

    misc = ensure_collection("Misc_Unsorted", "COLOR_08")
    for obj in objects:
        if obj.name not in matched:
            move_object_to_collection(obj, misc)


def make_mat(name, color, roughness=0.65, metallic=0.0, emission_strength=0.0):
    mat = bpy.data.materials.get(name) or bpy.data.materials.new(name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf:
        if "Base Color" in bsdf.inputs:
            bsdf.inputs["Base Color"].default_value = color
        if "Roughness" in bsdf.inputs:
            bsdf.inputs["Roughness"].default_value = roughness
        if "Metallic" in bsdf.inputs:
            bsdf.inputs["Metallic"].default_value = metallic
        if "Emission Strength" in bsdf.inputs:
            bsdf.inputs["Emission Strength"].default_value = emission_strength
        if "Emission Color" in bsdf.inputs:
            bsdf.inputs["Emission Color"].default_value = color
    return mat


def assign_mat(obj, mat):
    if not hasattr(obj.data, "materials"):
        return
    if obj.data.materials:
        obj.data.materials[0] = mat
    else:
        obj.data.materials.append(mat)


def cube(name, loc, scale, mat):
    bpy.ops.mesh.primitive_cube_add(size=2, location=loc)
    obj = bpy.context.active_object
    obj.name = name
    obj.scale = scale
    assign_mat(obj, mat)
    return obj


def add_realistic_floor_and_background():
    scene = get_scene()
    col = ensure_collection("Realism_Polish", "COLOR_06")

    asphalt = make_mat("M_Asphalt_NotPerfect", (0.018, 0.019, 0.018, 1), 0.86, 0.02)
    curb = make_mat("M_Curb_Concrete", (0.46, 0.45, 0.42, 1), 0.78, 0.0)
    wet = make_mat("M_Wet_Patches", (0.028, 0.032, 0.035, 1), 0.18, 0.0)
    dirt = make_mat("M_Dust_Dirt", (0.16, 0.13, 0.09, 1), 0.95, 0.0)
    warm_window = make_mat("M_Distant_Warm_Windows", (1.0, 0.68, 0.28, 1), 0.25, 0.0, 2.4)

    floor = cube("Human_Floor_Asphalt_Base", (0, 0, -0.02), (125, 105, 0.025), asphalt)
    move_object_to_collection(floor, col)

    for i in range(70):
        x = RNG.uniform(-80, 80)
        y = RNG.uniform(-55, 65)
        sx = RNG.uniform(0.15, 1.8)
        sy = RNG.uniform(0.03, 0.28)
        patch_mat = wet if i % 3 else dirt
        patch = cube(f"Floor_Scuff_{i:02d}", (x, y, 0.035 + i * 0.00005), (sx, sy, 0.004), patch_mat)
        patch.rotation_euler[2] = RNG.uniform(0, math.tau)
        move_object_to_collection(patch, col)

    for i, y in enumerate([-31.8, -12.4, 25.4, 39.8]):
        c = cube(f"Curb_Line_{i:02d}", (0, y, 0.13), (84, 0.22, 0.11), curb)
        move_object_to_collection(c, col)

    for i in range(18):
        x = -72 + i * 8.5 + RNG.uniform(-0.5, 0.5)
        stripe = cube(f"Parking_Line_Handmade_{i:02d}", (x, -36.5, 0.09), (0.055, 2.2, 0.006), curb)
        stripe.rotation_euler[2] = RNG.uniform(-0.025, 0.025)
        move_object_to_collection(stripe, col)

    for i in range(34):
        x = -115 + i * 7.0 + RNG.uniform(-1.5, 1.5)
        y = RNG.uniform(105, 132)
        h = RNG.uniform(8, 34)
        w = RNG.uniform(1.6, 4.6)
        d = RNG.uniform(1.0, 3.4)
        tower = cube(f"Background_Block_{i:02d}", (x, y, h), (w, d, h), make_mat(f"M_BG_Building_{i:02d}", (0.025 + RNG.random() * 0.035, 0.028 + RNG.random() * 0.03, 0.035 + RNG.random() * 0.04, 1), 0.72, 0.02))
        move_object_to_collection(tower, col)

        for row in range(int(h / 3)):
            if RNG.random() < 0.45:
                win = cube(f"Background_Window_{i:02d}_{row:02d}", (x + RNG.uniform(-w * 0.9, w * 0.9), y - d - 0.05, 3 + row * 3), (0.16, 0.015, 0.09), warm_window)
                move_object_to_collection(win, col)

    for obj in scene.objects:
        if obj.type == "MESH" and not obj.name.startswith(("FW_", "Floor_Scuff")):
            try:
                if not obj.modifiers.get("Small_Bevel"):
                    bevel = obj.modifiers.new("Small_Bevel", "BEVEL")
                    bevel.width = 0.025
                    bevel.segments = 2
                if not obj.modifiers.get("Weighted_Normals"):
                    normals = obj.modifiers.new("Weighted_Normals", "WEIGHTED_NORMAL")
                    normals.keep_sharp = True
            except Exception:
                pass

    if scene.world:
        scene.world.color = (0.004, 0.006, 0.012)


def add_human_imperfections():
    for obj in bpy.context.scene.objects:
        if obj.type != "MESH":
            continue
        if obj.name.startswith(("HQ_", "JK_", "T", "Background_Block")):
            obj.rotation_euler[2] += RNG.uniform(-0.004, 0.004)
            obj.location.x += RNG.uniform(-0.035, 0.035)
            obj.location.y += RNG.uniform(-0.035, 0.035)


def apply_cloud_realism():
    organize_scene_for_cloud()
    add_realistic_floor_and_background()
    add_human_imperfections()
    organize_scene_for_cloud()


apply_cloud_realism()
