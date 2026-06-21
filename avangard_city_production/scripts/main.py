"""
в•”в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•—
в•‘          AVANGARD CITY  вЂ”  CINEMATIC AD  |  Blender 4.2             в•‘
в•‘   Scripting в†’ New в†’ Paste в†’ Run Script                              в•‘
в•‘   в… Р’Р•Р РЎРРЇ 2.0 вЂ” РґРІР° Р¶РёР»С‹С… РґРѕРјР° Р–Рљ + РёРЅС„СЂР°СЃС‚СЂСѓРєС‚СѓСЂР°                в•‘
в•љв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ќ

  РўРђР™РњР›РђР™Рќ (300 РєР°РґСЂРѕРІ / 30 fps = 10 СЃРµРє):
  1  вЂ“ 60   в”‚ Р”СЂРѕРЅ РІР·Р»РµС‚Р°РµС‚ вЂ” РѕС‚РєСЂС‹РІР°РµС‚СЃСЏ РІРµСЃСЊ РіРѕСЂРѕРґ СЃ РІС‹СЃРѕС‚С‹
  60 вЂ“ 120  в”‚ РћР±Р»С‘С‚ РїРѕ РґСѓРіРµ СЃР»РµРІР°: РґРµС‚Р°Р»Рё СѓР»РёС†, РґРµСЂРµРІСЊСЏ, РјР°С€РёРЅС‹
  120 вЂ“ 170 в”‚ РќР°РµР·Рґ РЅР° РіР»Р°РІРЅСѓСЋ Р±Р°С€РЅСЋ / РІРѕСЂРѕС‚Р° / Р»РѕРіРѕС‚РёРї
  170 вЂ“ 200 в”‚ РљР°РјРµСЂР° РѕС‚Р»РµС‚Р°РµС‚ РЅР°Р·Р°Рґ, РЅРµР±Рѕ СЂР°СЃС€РёСЂСЏРµС‚СЃСЏ
  200 вЂ“ 300 в”‚ Р¤РРќРђР› вЂ” 20 С„РµР№СЂРІРµСЂРєРѕРІ + Р»РѕРіРѕС‚РёРї РЅР° СЌРєСЂР°РЅРµ
"""

import bpy, math, os, random
random.seed(7)

try:
    PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
except NameError:
    PROJECT_ROOT = bpy.path.abspath("//") or os.getcwd()
OUTPUT_DIR = os.path.join(PROJECT_ROOT, "renders")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  0. РћР§РРЎРўРљРђ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
for c in list(bpy.data.collections):
    bpy.data.collections.remove(c)

scene = bpy.context.scene
scene.frame_start, scene.frame_end = 1, 300
scene.render.fps = 30

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  1. RENDER
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
engines = {e.identifier for e in
           scene.render.bl_rna.properties["engine"].enum_items}
scene.render.engine = ("BLENDER_EEVEE_NEXT"
                       if "BLENDER_EEVEE_NEXT" in engines else "CYCLES")

if scene.render.engine == "BLENDER_EEVEE_NEXT":
    ev = scene.eevee
    for attr, val in [
        ("taa_render_samples", 256),
        ("use_bloom",          True),
        ("bloom_intensity",    0.12),
        ("bloom_radius",       4.0),
        ("bloom_threshold",    0.6),
        ("use_gtao",           True),
        ("gtao_factor",        2.2),
        ("gtao_distance",      0.28),
        ("use_ssr",            True),
        ("use_ssr_refraction", True),
        ("ssr_quality",        1.0),
        ("use_motion_blur",    True),
        ("motion_blur_shutter",0.5),
    ]:
        if hasattr(ev, attr):
            setattr(ev, attr, val)
else:
    scene.cycles.samples = 128
    scene.cycles.use_denoising = True

scene.render.resolution_x  = 1920
scene.render.resolution_y  = 1080
scene.render.resolution_percentage = 100
scene.render.image_settings.file_format = "FFMPEG"
scene.render.ffmpeg.format  = "MPEG4"
scene.render.ffmpeg.codec   = "H264"
scene.render.ffmpeg.constant_rate_factor = "HIGH"
scene.render.filepath = os.path.join(OUTPUT_DIR, "avangard_city_")

try:
    scene.view_settings.look = "AgX - High Contrast"
except Exception:
    try:
        scene.view_settings.look = "AgX - Medium High Contrast"
    except Exception:
        pass
scene.view_settings.exposure = 0.15
scene.view_settings.gamma    = 1.05

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  2. WORLD вЂ” РЅРѕС‡РЅРѕРµ РЅРµР±Рѕ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
world = bpy.data.worlds.new("NightWorld")
scene.world = world
world.use_nodes = True
wn = world.node_tree.nodes
wl = world.node_tree.links
wn.clear()

w_out  = wn.new("ShaderNodeOutputWorld")
w_bg   = wn.new("ShaderNodeBackground")
w_mix  = wn.new("ShaderNodeMixRGB")
w_bg.inputs["Strength"].default_value = 1.2
w_mix.blend_type = "MIX"
w_mix.inputs["Fac"].default_value     = 0.0
w_mix.inputs["Color1"].default_value  = (0.003, 0.006, 0.025, 1)
w_mix.inputs["Color2"].default_value  = (0.18, 0.06, 0.02, 1)
w_grad  = wn.new("ShaderNodeTexGradient")
w_coord = wn.new("ShaderNodeTexCoord")
w_map   = wn.new("ShaderNodeMapping")
w_map.inputs["Rotation"].default_value[1] = math.radians(90)
wl.new(w_coord.outputs["Generated"], w_map.inputs["Vector"])
wl.new(w_map.outputs["Vector"],  w_grad.inputs["Vector"])
wl.new(w_grad.outputs["Fac"],    w_mix.inputs["Fac"])
wl.new(w_mix.outputs["Color"],   w_bg.inputs["Color"])
wl.new(w_bg.outputs["Background"], w_out.inputs["Surface"])

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  3. РњРђРўР•Р РРђР›Р«
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
def mat(name, color=(1,1,1,1), rough=0.5, metal=0.0, emit=0.0,
        transmission=0.0, ior=1.45, alpha=1.0):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get("Principled BSDF")
    if not bsdf:
        return m
    def si(k, v):
        if k in bsdf.inputs:
            bsdf.inputs[k].default_value = v
    si("Base Color", color)
    si("Roughness",  rough)
    si("Metallic",   metal)
    si("Emission Strength", emit)
    si("Emission Color",    color)
    si("Alpha",      alpha)
    if transmission > 0:
        si("Transmission", transmission)
        si("IOR", ior)
        m.blend_method = "BLEND"
    elif alpha < 1.0:
        m.blend_method = "BLEND"
    return m

M = {}
M["ground"]    = mat("M_Ground",    (0.014,0.018,0.025,1), 0.90)
M["road"]      = mat("M_Road",      (0.007,0.009,0.012,1), 0.22, 0.18)
M["pavement"]  = mat("M_Pave",      (0.10, 0.10, 0.11, 1), 0.70, 0.02)
M["concrete"]  = mat("M_Concrete",  (0.52, 0.55, 0.60, 1), 0.42, 0.04)
M["dark"]      = mat("M_Dark",      (0.04, 0.055, 0.08,1), 0.28, 0.22)
M["gold"]      = mat("M_Gold",      (1.0,  0.72,  0.22,1), 0.18, 0.92)
M["window"]    = mat("M_Window",    (1.0,  0.68,  0.32,1), 0.12, 0.0,  5.5)
M["logo"]      = mat("M_Logo",      (1.0,  0.90,  0.62,1), 0.08, 0.0, 10.0)
M["glass"]     = mat("M_Glass",     (0.25, 0.55,  0.90, 0.3), 0.02, 0.0, 0.0,
                      0.92, 1.45, 0.3)
M["water"]     = mat("M_Water",     (0.04, 0.18,  0.40,1), 0.06, 0.08)
M["tree"]      = mat("M_Tree",      (0.04, 0.20,  0.07,1), 0.88)
M["trunk"]     = mat("M_Trunk",     (0.15, 0.07,  0.03,1), 0.90)
M["car"]       = mat("M_Car",       (0.01, 0.01,  0.015,1),0.18, 0.28)
M["crane"]     = mat("M_Crane",     (0.92, 0.60,  0.10,1), 0.32, 0.60)
M["marble"]    = mat("M_Marble",    (0.88, 0.82,  0.75,1), 0.22, 0.08)
M["copper"]    = mat("M_Copper",    (0.78, 0.44,  0.20,1), 0.30, 0.85)
# Р¶РёР»РѕР№ РґРѕРј вЂ” СЃРІРµС‚Р»С‹Р№ С„Р°СЃР°Рґ
M["jk_wall"]   = mat("M_JK_Wall",   (0.82, 0.80,  0.75,1), 0.55, 0.02)
M["jk_balc"]   = mat("M_JK_Balc",   (0.90, 0.88,  0.84,1), 0.40, 0.04)
M["jk_glass"]  = mat("M_JK_Glass",  (0.55, 0.78,  0.95, 0.35), 0.05, 0.0, 0.0,
                      0.88, 1.45, 0.35)
M["jk_accent"] = mat("M_JK_Accent", (0.15, 0.25,  0.55,1), 0.30, 0.15)
M["jk_window"] = mat("M_JK_Window", (0.95, 0.80,  0.45,1), 0.10, 0.0, 4.5)
M["jk_lobby"]  = mat("M_JK_Lobby",  (0.96, 0.92,  0.82,1), 0.20, 0.05)
# С„РµР№СЂРІРµСЂРєРё
M["fw_gold"]   = mat("M_FW_Gold",   (1.0,  0.82,  0.18,1), 0.08, 0.0, 16)
M["fw_red"]    = mat("M_FW_Red",    (1.0,  0.10,  0.04,1), 0.08, 0.0, 15)
M["fw_blue"]   = mat("M_FW_Blue",   (0.30, 0.60,  1.0, 1), 0.08, 0.0, 14)
M["fw_green"]  = mat("M_FW_Green",  (0.20, 1.0,   0.35,1), 0.08, 0.0, 14)
M["fw_violet"] = mat("M_FW_Violet", (0.80, 0.20,  1.0, 1), 0.08, 0.0, 14)
M["fw_white"]  = mat("M_FW_White",  (1.0,  0.96,  0.88,1), 0.08, 0.0, 18)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  4. Р‘РђР—РћР’Р«Р• РҐР•Р›РџР•Р Р«
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
def add_mat(obj, m):
    if obj.data.materials:
        obj.data.materials[0] = m
    else:
        obj.data.materials.append(m)

def cube(name, loc, scale, m):
    bpy.ops.mesh.primitive_cube_add(size=2, location=loc)
    o = bpy.context.active_object
    o.name = name
    o.scale = scale
    add_mat(o, m)
    return o

def cyl(name, loc, r, h, m, verts=48):
    bpy.ops.mesh.primitive_cylinder_add(
        vertices=verts, radius=r, depth=h, location=loc)
    o = bpy.context.active_object
    o.name = name
    add_mat(o, m)
    try:
        bpy.ops.object.shade_smooth()
    except Exception:
        pass
    return o

def sph(name, loc, r, m):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=r, location=loc)
    o = bpy.context.active_object
    o.name = name
    add_mat(o, m)
    try:
        bpy.ops.object.shade_smooth()
    except Exception:
        pass
    return o

def ico(name, loc, r, m):
    bpy.ops.mesh.primitive_ico_sphere_add(subdivisions=2, radius=r, location=loc)
    o = bpy.context.active_object
    o.name = name
    add_mat(o, m)
    return o

def cone(name, loc, r, h, m, verts=6):
    bpy.ops.mesh.primitive_cone_add(
        vertices=verts, radius1=r, radius2=0, depth=h, location=loc)
    o = bpy.context.active_object
    o.name = name
    add_mat(o, m)
    return o

def torus(name, loc, R, r, m, rot=(0,0,0)):
    bpy.ops.mesh.primitive_torus_add(
        major_radius=R, minor_radius=r, location=loc, rotation=rot)
    o = bpy.context.active_object
    o.name = name
    add_mat(o, m)
    return o

def smooth_keys(obj):
    if not (obj.animation_data and obj.animation_data.action):
        return
    for fc in obj.animation_data.action.fcurves:
        for kp in fc.keyframe_points:
            kp.interpolation = "BEZIER"
            kp.handle_left_type  = "AUTO_CLAMPED"
            kp.handle_right_type = "AUTO_CLAMPED"

def hide_range(obj, start, end):
    for fr, val in [(1, True), (start-1, True),
                    (start, False), (end, False),
                    (end+1, True)]:
        obj.hide_render   = val
        obj.hide_viewport = val
        obj.keyframe_insert("hide_render",   frame=fr)
        obj.keyframe_insert("hide_viewport", frame=fr)

def point_light(name, loc, energy, color=(1,1,1), radius=1.5):
    bpy.ops.object.light_add(type="POINT", location=loc)
    l = bpy.context.active_object
    l.name = name
    l.data.energy      = energy
    l.data.color       = color
    l.data.shadow_soft_size = radius
    return l

def area_light(name, loc, energy, size, size_y=None, rot=(0,0,0)):
    bpy.ops.object.light_add(type="AREA", location=loc)
    l = bpy.context.active_object
    l.name = name
    l.data.energy = energy
    l.data.shape  = "RECTANGLE"
    l.data.size   = size
    l.data.size_y = size_y or size
    l.rotation_euler = rot
    return l

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  5. Р—Р•РњР›РЇ / Р”РћР РћР“Р / РќРђР‘Р•Р Р•Р–РќРђРЇ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
cube("Ground",        (0,  0, -0.6),  (160, 160, 0.6),  M["ground"])
cube("Pavement_Main", (0,  0,  0.02), (90,  70,  0.04), M["pavement"])

cube("Road_H",  (0, -22, 0.04), (95, 5.0, 0.03), M["road"])
cube("Road_H2", (0,  34, 0.04), (95, 5.0, 0.03), M["road"])
cube("Road_V",  (0,   6, 0.04), (4.5, 72, 0.03), M["road"])

for xi in [-1.1, 1.1]:
    cube(f"RoadLine_{xi}", (xi, -22, 0.07), (0.06, 44, 0.015), M["gold"])

# С†РµРЅС‚СЂР°Р»СЊРЅР°СЏ Plaza
cube("Plaza",        (0, -6, 0.09),  (30, 10, 0.05),    M["marble"])
torus("PlazaRing_Outer", (0, -6, 0.16), 8.5, 0.07, M["gold"])
torus("PlazaRing_Inner", (0, -6, 0.16), 5.5, 0.04, M["gold"])

cyl("Fountain_Basin",  (0, -6, 0.22), 2.8, 0.30, M["marble"])
cyl("Fountain_Column", (0, -6, 0.70), 0.22, 1.0,  M["gold"])
sph("Fountain_Top",    (0, -6, 1.30), 0.40, M["gold"])
point_light("Fountain_Light", (0, -6, 0.5), 1800, (0.9, 0.75, 0.4), 3)

cube("Embankment", (0, 62,  0.15), (90, 20, 0.10), M["pavement"])
cube("WaterBody",  (0, 80, -0.20), (90, 20, 0.20), M["water"])
for i in range(14):
    cube(f"WRef_{i}", (-52+i*8, 70, 0.06), (2.0, 0.06, 0.015), M["logo"])

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  6. Р’РЎРџРћРњРћР“РђРўР•Р›Р¬РќР«Р• Р¤РЈРќРљР¦РР Р—Р”РђРќРР™
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
def windows_facade(base_name, cx, cy, h, bw, depth,
                   win_mat, rows_per_unit=1.5, cols=3):
    floors = max(2, int(h * rows_per_unit))
    for f in range(1, floors+1):
        z = (f / (floors+1)) * h * 2 - h * 0.5
        for c in range(cols):
            t = (c / (cols-1) - 0.5) if cols > 1 else 0
            wx = cx + t * bw * 0.7
            w = cube(f"{base_name}_w{f}_{c}",
                     (wx, cy - depth - 0.08, z),
                     (0.22, 0.03, 0.16), win_mat)
            bsdf = w.data.materials[0].node_tree.nodes.get("Principled BSDF")
            if bsdf and "Emission Strength" in bsdf.inputs:
                base_e = random.uniform(2.5, 6.5)
                fl1 = random.randint(20, 80)
                fl2 = random.randint(81, 180)
                bsdf.inputs["Emission Strength"].default_value = 0.8
                bsdf.inputs["Emission Strength"].keyframe_insert("default_value", frame=1)
                bsdf.inputs["Emission Strength"].default_value = base_e
                bsdf.inputs["Emission Strength"].keyframe_insert("default_value", frame=fl1)
                bsdf.inputs["Emission Strength"].default_value = base_e * 0.6
                bsdf.inputs["Emission Strength"].keyframe_insert("default_value", frame=fl2)

def build_tower(idx, cx, cy, h, bw, bd, style="dark"):
    fm = M["dark"] if style == "dark" else M["concrete"]
    cube(f"T{idx}_body",    (cx, cy, h),          (bw, bd, h),       fm)
    cube(f"T{idx}_glass",   (cx, cy-bd-0.12, h),  (bw*0.65, 0.07, h*0.90), M["glass"])
    cube(f"T{idx}_cornice", (cx, cy, h*2+0.25),   (bw*1.10, bd*1.08, 0.20), M["gold"])
    for sx in [-bw, bw]:
        cube(f"T{idx}_pylon_{sx}", (cx+sx, cy, h*0.5), (0.18, bd+0.1, h*0.5), M["gold"])
    windows_facade(f"T{idx}", cx, cy, h, bw, bd, M["window"], 1.4, 3)
    if style == "dark":
        cube(f"T{idx}_penthouse", (cx, cy, h*2+0.8), (bw*0.55, bd*0.55, 0.55), M["gold"])
    else:
        cone(f"T{idx}_spire", (cx, cy, h*2+0.6), bw*0.30, h*0.20, M["gold"])

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  в… 7. Р–РР›Р«Р• Р”РћРњРђ Р–Рљ вЂ” РўР’Рћ Р—Р”РђРќРРЇ
#     Р”РІР° СЃРёРјРјРµС‚СЂРёС‡РЅС‹С… РґРѕРјР° РїРѕ Р±РѕРєР°Рј РѕС‚ HQ
#     Р›РµРІС‹Р№: cx=-32   РџСЂР°РІС‹Р№: cx=+32
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
def build_jk(prefix, cx, cy=8):
    """
    Р–РёР»РѕР№ РґРѕРј Р–Рљ вЂ” 15 СЌС‚Р°Р¶РµР№.
    РЎРІРµС‚Р»С‹Р№ С„Р°СЃР°Рґ, Р±Р°Р»РєРѕРЅС‹ РЅР° РєР°Р¶РґРѕРј СЌС‚Р°Р¶Рµ,
    РїР°РЅРѕСЂР°РјРЅС‹Рµ РѕРєРЅР°, Р»РѕР±Р±Рё РЅР° 1 СЌС‚Р°Р¶Рµ,
    РєСЂС‹С€Р° СЃ С‚РµС…РЅРёС‡РµСЃРєРёРј СЌС‚Р°Р¶РѕРј.
    """
    bw = 6.0   # РїРѕР»СѓС€РёСЂРёРЅР° РїРѕ X
    bd = 3.0   # РїРѕР»СѓРіР»СѓР±РёРЅР° РїРѕ Y
    floor_h = 1.6
    floors  = 15
    total_h = floor_h * floors  # = 24.0

    # в”Ђв”Ђ РЎС‚РёР»РѕР±Р°С‚ / С†РѕРєРѕР»СЊ в”Ђв”Ђ
    cube(f"{prefix}_plinth", (cx, cy, 0.8),
         (bw+0.4, bd+0.4, 0.8), M["marble"])

    # в”Ђв”Ђ Р›РѕР±Р±Рё 1 СЌС‚Р°Р¶ в”Ђв”Ђ
    cube(f"{prefix}_lobby",       (cx, cy, 1.8),        (bw, bd, 1.0),   M["jk_lobby"])
    cube(f"{prefix}_lobby_glF",   (cx, cy-bd-0.02, 1.8),(bw*0.80, 0.05, 0.90), M["jk_glass"])
    cube(f"{prefix}_lobby_glL",   (cx-bw-0.02, cy, 1.8),(0.05, bd*0.70, 0.90), M["jk_glass"])
    cube(f"{prefix}_lobby_glR",   (cx+bw+0.02, cy, 1.8),(0.05, bd*0.70, 0.90), M["jk_glass"])
    # РІС‹РІРµСЃРєР° Р»РѕР±Р±Рё
    bpy.ops.object.text_add(
        location=(cx - 2.0, cy - bd - 0.10, 2.2),
        rotation=(math.radians(90), 0, 0))
    lsign = bpy.context.active_object
    lsign.name = f"{prefix}_lobby_sign"
    lsign.data.body = "AVANGARD RESIDENCE"
    lsign.data.extrude = 0.03
    lsign.scale = (0.22, 0.22, 0.22)
    add_mat(lsign, M["logo"])
    # РїРѕРґСЃРІРµС‚РєР° Р»РѕР±Р±Рё
    point_light(f"{prefix}_lobby_lt", (cx, cy-bd+0.5, 1.8), 2000, (1.0, 0.92, 0.68), 2.5)

    # в”Ђв”Ђ РћСЃРЅРѕРІРЅРѕР№ РєРѕСЂРїСѓСЃ (СЃРµРєС†РёРё РїРѕ 5 СЌС‚Р°Р¶РµР№) в”Ђв”Ђ
    # СЃРµРєС†РёСЏ Рђ (1вЂ“5 СЌС‚.)
    cube(f"{prefix}_secA", (cx, cy, 2.8 + 4.0), (bw, bd, 4.0), M["jk_wall"])
    # СЃРµРєС†РёСЏ Р‘ (6вЂ“10 СЌС‚.)
    cube(f"{prefix}_secB", (cx, cy, 2.8 + 12.0), (bw, bd, 4.0), M["jk_wall"])
    # СЃРµРєС†РёСЏ Р’ (11вЂ“15 СЌС‚.) вЂ” С‡СѓС‚СЊ СѓР¶Рµ РґР»СЏ СЃС‚СѓРїРµРЅС‡Р°С‚РѕРіРѕ СЃРёР»СѓСЌС‚Р°
    cube(f"{prefix}_secC", (cx, cy, 2.8 + 20.0), (bw*0.88, bd*0.92, 4.0), M["jk_wall"])

    # в”Ђв”Ђ РђРєС†РµРЅС‚РЅС‹Рµ РІРµСЂС‚РёРєР°Р»СЊРЅС‹Рµ РїРѕР»РѕСЃС‹ (РїРёР»СЏСЃС‚СЂС‹) в”Ђв”Ђ
    for px_off in [-bw*0.65, 0, bw*0.65]:
        cube(f"{prefix}_pilaster_{px_off:.1f}",
             (cx + px_off, cy - bd - 0.04, 2.8 + total_h/2),
             (0.18, 0.06, total_h/2 + 1.0), M["jk_accent"])

    # в”Ђв”Ђ Р‘Р°Р»РєРѕРЅС‹ вЂ” РєР°Р¶РґС‹Р№ С‡С‘С‚РЅС‹Р№ СЌС‚Р°Р¶, С„СЂРѕРЅС‚Р°Р»СЊРЅС‹Р№ С„Р°СЃР°Рґ в”Ђв”Ђ
    for fl in range(2, floors+1, 2):
        z_balc = 2.8 + fl * floor_h - floor_h * 0.5
        for bx_off in [-bw*0.55, 0, bw*0.55]:
            # РїР»РёС‚Р° Р±Р°Р»РєРѕРЅР°
            cube(f"{prefix}_balc_pl_{fl}_{bx_off:.0f}",
                 (cx + bx_off, cy - bd - 0.28, z_balc),
                 (1.35, 0.28, 0.07), M["jk_balc"])
            # РѕРіСЂР°Р¶РґРµРЅРёРµ (С‚СЂРё С‚РѕРЅРєРёС… СЃС‚РѕР»Р±РёРєР° + РїРѕСЂСѓС‡РµРЅСЊ)
            for rail_x in [-0.55, 0, 0.55]:
                cube(f"{prefix}_rail_{fl}_{bx_off:.0f}_{rail_x}",
                     (cx + bx_off + rail_x, cy - bd - 0.52, z_balc + 0.35),
                     (0.04, 0.04, 0.35), M["jk_accent"])
            cube(f"{prefix}_rail_top_{fl}_{bx_off:.0f}",
                 (cx + bx_off, cy - bd - 0.52, z_balc + 0.72),
                 (1.40, 0.04, 0.04), M["jk_accent"])
            # Р·Р°СЃС‚РµРєР»С‘РЅРЅС‹Р№ Р±Р°Р»РєРѕРЅ (Р»С‘РіРєРѕРµ СЃС‚РµРєР»Рѕ)
            cube(f"{prefix}_balc_gl_{fl}_{bx_off:.0f}",
                 (cx + bx_off, cy - bd - 0.50, z_balc + 0.25),
                 (1.30, 0.03, 0.28), M["jk_glass"])

    # в”Ђв”Ђ РћРєРЅР° вЂ” РЅРµС‡С‘С‚РЅС‹Рµ СЌС‚Р°Р¶Рё, С„СЂРѕРЅС‚Р°Р»СЊРЅС‹Р№ С„Р°СЃР°Рґ в”Ђв”Ђ
    for fl in range(1, floors+1):
        z_win = 2.8 + fl * floor_h - floor_h * 0.5
        for wx_off in [-bw*0.55, 0, bw*0.55]:
            w = cube(f"{prefix}_win_{fl}_{wx_off:.0f}",
                     (cx + wx_off, cy - bd - 0.06, z_win),
                     (0.55, 0.04, 0.55), M["jk_window"])
            # РјРµСЂС†Р°РЅРёРµ РѕРєРѕРЅ
            bsdf = w.data.materials[0].node_tree.nodes.get("Principled BSDF")
            if bsdf and "Emission Strength" in bsdf.inputs:
                base_e = random.uniform(2.0, 5.5)
                bsdf.inputs["Emission Strength"].default_value = 0.5
                bsdf.inputs["Emission Strength"].keyframe_insert("default_value", frame=1)
                bsdf.inputs["Emission Strength"].default_value = base_e
                bsdf.inputs["Emission Strength"].keyframe_insert("default_value",
                                                                  frame=random.randint(15, 90))
                bsdf.inputs["Emission Strength"].default_value = base_e * 0.55
                bsdf.inputs["Emission Strength"].keyframe_insert("default_value",
                                                                  frame=random.randint(91, 200))

    # в”Ђв”Ђ Р“РѕСЂРёР·РѕРЅС‚Р°Р»СЊРЅС‹Рµ РјРµР¶СЌС‚Р°Р¶РЅС‹Рµ РїРѕСЏСЃР° в”Ђв”Ђ
    for belt_fl in range(5, floors+1, 5):
        z_belt = 2.8 + belt_fl * floor_h
        cube(f"{prefix}_belt_{belt_fl}",
             (cx, cy, z_belt),
             (bw + 0.15, bd + 0.12, 0.14), M["jk_accent"])

    # в”Ђв”Ђ РўРµС…РЅРёС‡РµСЃРєРёР№ СЌС‚Р°Р¶ + РєСЂС‹С€Р° в”Ђв”Ђ
    tech_z = 2.8 + total_h + 1.2
    cube(f"{prefix}_tech",  (cx, cy, 2.8 + total_h + 0.6), (bw*0.85, bd*0.85, 0.6), M["jk_accent"])
    cube(f"{prefix}_roof",  (cx, cy, tech_z),               (bw*0.90, bd*0.90, 0.25), M["jk_balc"])
    # РїР°СЂР°РїРµС‚ РєСЂС‹С€Рё
    for px, py, pw, ph in [
        (cx, cy - bd*0.90 - 0.08, bw*0.90, 0.08),
        (cx, cy + bd*0.90 + 0.08, bw*0.90, 0.08),
        (cx - bw*0.90 - 0.08, cy, 0.08, bd*0.90),
        (cx + bw*0.90 + 0.08, cy, 0.08, bd*0.90),
    ]:
        cube(f"{prefix}_parapet_{px:.0f}_{py:.0f}",
             (px, py, tech_z + 0.5), (pw, ph, 0.50), M["jk_balc"])

    # в”Ђв”Ђ Р›РёС„С‚РѕРІР°СЏ РЅР°РґСЃС‚СЂРѕР№РєР° в”Ђв”Ђ
    cyl(f"{prefix}_lift_shaft", (cx, cy + bd*0.4, tech_z + 1.2),
        0.60, 2.4, M["jk_accent"])
    cube(f"{prefix}_lift_top",  (cx, cy + bd*0.4, tech_z + 2.8),
         (0.75, 0.75, 0.35), M["gold"])

    # в”Ђв”Ђ РџРѕРґСЃРІРµС‚РєР° С„Р°СЃР°РґР° СЃРЅРёР·Сѓ в”Ђв”Ђ
    point_light(f"{prefix}_facade_lt1", (cx-4, cy-bd-1.5, 1.0),
                3500, (0.95, 0.88, 0.72), 4.0)
    point_light(f"{prefix}_facade_lt2", (cx+4, cy-bd-1.5, 1.0),
                3500, (0.95, 0.88, 0.72), 4.0)
    point_light(f"{prefix}_top_lt",     (cx, cy, total_h + 4),
                1800, (0.80, 0.85, 1.0),  3.5)

    # в”Ђв”Ђ РџРµС€РµС…РѕРґРЅР°СЏ РґРѕСЂРѕР¶РєР° Рє РІС…РѕРґСѓ в”Ђв”Ђ
    cube(f"{prefix}_path",  (cx, cy - bd - 2.5, 0.06),
         (bw*0.55, 2.5, 0.04), M["marble"])


# в”Ђв”Ђ Р›Р•Р’Р«Р™ Р–Рљ в”Ђв”Ђ
build_jk("JK_L", cx=-32, cy=8)

# в”Ђв”Ђ РџР РђР’Р«Р™ Р–Рљ в”Ђв”Ђ
build_jk("JK_R", cx=+32, cy=8)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  8. Р“Р›РђР’РќРђРЇ Р‘РђРЁРќРЇ HQ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
cube("HQ_Base",  (0, 14, 8),  (12, 5, 8),   M["dark"])
cube("HQ_Mid",   (0, 14, 20), (9.5, 4.2, 6), M["dark"])
cube("HQ_Top",   (0, 14, 30), (7.0, 3.5, 4), M["dark"])
cube("HQ_Spire", (0, 14, 37), (1.2, 1.2, 3), M["gold"])
cyl("HQ_Antenna", (0, 14, 43), 0.10, 5, M["gold"])
sph("HQ_Antball", (0, 14, 46), 0.28, M["logo"])
point_light("HQ_AntLight", (0, 14, 46), 3000, (1, 0.9, 0.5), 0.5)
# РјРёРіР°СЋС‰РёР№ РјР°СЏРє РЅР° Р°РЅС‚РµРЅРЅРµ
ant_bsdf = bpy.data.objects["HQ_Antball"].data.materials[0].node_tree.nodes.get("Principled BSDF")
if ant_bsdf and "Emission Strength" in ant_bsdf.inputs:
    for fr in range(1, 301, 30):
        ant_bsdf.inputs["Emission Strength"].default_value = 0.5
        ant_bsdf.inputs["Emission Strength"].keyframe_insert("default_value", frame=fr)
        ant_bsdf.inputs["Emission Strength"].default_value = 18.0
        ant_bsdf.inputs["Emission Strength"].keyframe_insert("default_value", frame=fr+4)
        ant_bsdf.inputs["Emission Strength"].default_value = 0.5
        ant_bsdf.inputs["Emission Strength"].keyframe_insert("default_value", frame=fr+8)

cube("HQ_GlL", (-12.1, 14, 8),   (0.07, 5, 8),   M["glass"])
cube("HQ_GlR", ( 12.1, 14, 8),   (0.07, 5, 8),   M["glass"])
cube("HQ_GlF", (0, 8.85, 8),     (12, 0.07, 8),  M["glass"])
windows_facade("HQ_F", 0, 14, 16, 10, 5, M["window"], 1.6, 4)
for lz, lw in [(16.2, 12.5), (26.2, 10.2), (34.2, 7.5)]:
    cube(f"HQ_Ledge_{lz}", (0, 14, lz), (lw, 5.3, 0.22), M["gold"])

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  9. Р’РћР РћРўРђ / Р’РҐРћР”
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
cube("Gate_L",  (-11, 2.5, 5.5), (0.6, 1.1, 5.5), M["gold"])
cube("Gate_R",  ( 11, 2.5, 5.5), (0.6, 1.1, 5.5), M["gold"])
cube("Gate_T",  (  0, 2.5, 11.2),(11.8, 1.1, 0.5), M["gold"])
for sx in [-1, 1]:
    b = cube(f"Gate_Brace_{sx}", (sx*5.5, 2.5, 8.5), (0.2, 0.8, 3.5), M["gold"])
    b.rotation_euler[2] = math.radians(sx * 18)

bpy.ops.object.text_add(
    location=(-7.2, 1.45, 9.6),
    rotation=(math.radians(80), 0, 0))
arch_txt = bpy.context.active_object
arch_txt.name = "Gate_Text"
arch_txt.data.body  = "AVANGARD CITY"
arch_txt.data.extrude = 0.07
arch_txt.data.bevel_depth = 0.008
arch_txt.scale = (0.95, 0.95, 0.95)
add_mat(arch_txt, M["logo"])

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  10. Р Р•РЎРўРћР РђРќ РќРђ 1 Р­РўРђР–Р• (РјРµР¶РґСѓ Р–Рљ Рё HQ)
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
cube("Restaurant_Base",   (0, 8.5, 1.5),   (13, 5.5, 1.5),  M["dark"])
cube("Restaurant_GlassF", (0, 5.8, 1.5),   (12, 0.06, 1.3), M["glass"])
cube("Restaurant_GlassL", (-6.1, 8.5, 1.5),(0.06, 5.5, 1.3),M["glass"])
cube("Restaurant_GlassR", ( 6.1, 8.5, 1.5),(0.06, 5.5, 1.3),M["glass"])
bpy.ops.object.text_add(
    location=(-3.8, 5.72, 2.1),
    rotation=(math.radians(90), 0, 0))
rest_sign = bpy.context.active_object
rest_sign.name = "RestaurantSign"
rest_sign.data.body = "RESTAURANT"
rest_sign.data.extrude = 0.04
rest_sign.scale = (0.35, 0.35, 0.35)
add_mat(rest_sign, M["logo"])
point_light("Rest_Lt_L", (-4, 6.5, 1.8), 1200, (1.0, 0.85, 0.55), 1.5)
point_light("Rest_Lt_R", ( 4, 6.5, 1.8), 1200, (1.0, 0.85, 0.55), 1.5)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  11. Р”Р•РўРЎРљРђРЇ РџР›РћР©РђР”РљРђ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
cube("Play_Ground",    (-22, 52, 0.12),  (9,  6,  0.08), M["pavement"])
cone("Slide_Top",      (-22, 52, 1.6),   0.7, 0.6, M["fw_blue"], 4)
cyl( "Slide_Pole",     (-22, 52, 0.8),   0.08, 1.6, M["dark"])
cube("Slide_Ramp",     (-20, 52, 0.8),   (0.15, 1.5, 0.7), M["fw_blue"])
cyl("Swing_PoleL1",    (-25, 48, 1.5),   0.06, 3.0, M["dark"])
cyl("Swing_PoleL2",    (-25, 50, 1.5),   0.06, 3.0, M["dark"])
cube("Swing_Bar",      (-25, 49, 3.1),   (0.06, 1.1, 0.06), M["gold"])
cube("Swing_Seat",     (-25, 49, 1.5),   (0.3, 0.06, 0.06), M["dark"])
cube("Sandbox",        (-18, 50, 0.18),  (3, 2.5, 0.14), M["pavement"])
cube("Sandbox_Border", (-18, 50, 0.22),  (3.2, 2.7, 0.06), M["trunk"])
point_light("Play_Light", (-22, 51, 4),  2200, (0.95, 0.85, 0.6), 4)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  12. РџРђР РљРћР’РљРђ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
cube("Parking_Ground", (30, -10, 0.05), (22, 14, 0.04), M["road"])
for pi in range(3):
    for pj in range(3):
        px = 22 + pi * 7
        py = -16 + pj * 5
        cube(f"Pspot_{pi}_{pj}",  (px, py,      0.08), (2.8, 0.05, 0.01), M["gold"])
        cube(f"Pspot2_{pi}_{pj}", (px, py + 2.4, 0.08),(2.8, 0.05, 0.01), M["gold"])
for pi in range(4):
    cyl(f"Pbollard_{pi}", (19 + pi*7, -3.5, 0.4), 0.10, 0.8, M["gold"])
cyl("Park_Sign_Pole",   (30, -3, 2.0),  0.06, 4.0,  M["dark"])
cube("Park_Sign_Board",  (30, -3, 4.2),  (0.6, 0.06, 0.5), M["fw_blue"])
point_light("Park_Lt1", (22, -10, 5),   1800, (0.85, 0.85, 1.0), 3)
point_light("Park_Lt2", (38, -10, 5),   1800, (0.85, 0.85, 1.0), 3)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  13. Р›РђР’РћР§РљР, РљР›РЈРњР‘Р«, Р’Р•Р›РћРџРђР РљРћР’РљРђ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
for bi, bx in enumerate([-12, -6, 6, 12]):
    cube(f"Bench_{bi}",      (bx, -4, 0.30),  (1.2, 0.40, 0.10), M["trunk"])
    cube(f"Bench_leg1_{bi}", (bx-0.45, -4, 0.16),(0.08, 0.40, 0.14), M["dark"])
    cube(f"Bench_leg2_{bi}", (bx+0.45, -4, 0.16),(0.08, 0.40, 0.14), M["dark"])

for fi, (fx, fy) in enumerate([(-14,-8),(14,-8),(-14,-2),(14,-2)]):
    cyl(f"Flower_{fi}",   (fx, fy, 0.28),  0.9, 0.22, M["pavement"])
    sph(f"FlowerTop_{fi}",(fx, fy, 0.55),  0.55, M["tree"])

for vi in range(5):
    cube(f"Bike_rack_{vi}", (-8 + vi*3, -18.5, 0.5), (0.06, 0.8, 0.5), M["dark"])
cube("Bike_Bar", (-3, -18.5, 0.90), (10, 0.06, 0.06), M["gold"])

# РїРµС€РµС…РѕРґРЅС‹Рµ РґРѕСЂРѕР¶РєРё РјРµР¶РґСѓ Р–Рљ
cube("Path_JKL", (-32, -0.5, 0.06), (5.5, 8.5, 0.04), M["marble"])
cube("Path_JKR", ( 32, -0.5, 0.06), (5.5, 8.5, 0.04), M["marble"])

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  14. РЎРћРЎР•Р”РќРР• Р‘РђРЁРќР
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
city_blocks = [
    (-54,  5,  5.2, 2.6, 1.8, "dark"),
    (-46, 14,  6.8, 3.0, 2.0, "light"),
    (-22,  5,  7.0, 3.0, 2.0, "dark"),
    (-14, 20,  9.2, 3.4, 2.2, "dark"),
    ( 14, 20,  9.2, 3.4, 2.2, "dark"),
    ( 22,  5,  7.0, 3.0, 2.0, "dark"),
    ( 46, 14,  6.8, 3.0, 2.0, "light"),
    ( 54,  5,  5.2, 2.6, 1.8, "dark"),
    # Р·Р°РґРЅРёР№ СЂСЏРґ
    (-46, 36,  7.5, 3.0, 2.0, "dark"),
    (-32, 40, 11.0, 3.8, 2.5, "light"),
    (-18, 37, 13.5, 4.0, 2.6, "dark"),
    (  3, 39, 15.0, 4.2, 2.7, "light"),
    ( 18, 37, 11.5, 3.8, 2.5, "dark"),
    ( 32, 40,  9.5, 3.4, 2.3, "light"),
    ( 46, 36,  8.0, 3.0, 2.2, "dark"),
]
for idx, (bx, by, bh, bw, bd, sty) in enumerate(city_blocks):
    build_tower(idx, bx, by, bh, bw, bd, sty)

# в”Ђв”Ђв”Ђ Р”РђР›Р¬РќРР™ РЎРР›РЈР­Рў в”Ђв”Ђв”Ђ
for i in range(-22, 23):
    sx = i * 7 + random.uniform(-2, 2)
    sy = random.uniform(72, 100)
    sh = random.uniform(4, 24)
    cube(f"Sky_{i}", (sx, sy, sh),
         (random.uniform(2, 5), random.uniform(2, 4), sh), M["dark"])

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  15. РљР РђРќР«
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
def crane(name, cx, cy, angle_deg):
    cube(name+"_mast",  (cx, cy, 6),    (0.24, 0.24, 6),    M["crane"])
    cube(name+"_arm",   (cx+5, cy, 12.3),(5.0,  0.14, 0.14), M["crane"])
    cube(name+"_cback", (cx-2, cy, 12.3),(2.0,  0.14, 0.14), M["crane"])
    cube(name+"_wire",  (cx+9, cy, 10.8),(0.03, 0.03, 1.5),  M["logo"])
    cube(name+"_hook",  (cx+9, cy, 9.2), (0.20, 0.10, 0.14), M["gold"])
    for p_name in [name+"_mast", name+"_arm", name+"_cback",
                   name+"_wire", name+"_hook"]:
        bpy.data.objects[p_name].rotation_euler[2] = math.radians(angle_deg)

crane("CraneL", -42, 30, 12)
crane("CraneR",  42, 30, -12)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  16. Р”Р•Р Р•Р’Р¬РЇ + Р¤РћРќРђР Р
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
def tree(idx, tx, ty):
    cyl(f"Tr_trunk_{idx}", (tx, ty, 1.0), 0.14, 2.0, M["trunk"])
    top = sph(f"Tr_top_{idx}", (tx, ty, 2.6), 0.95, M["tree"])
    top.scale.z = 1.3

for i, tx in enumerate(range(-52, 53, 8)):
    tree(i*2,   tx, -10)
    tree(i*2+1, tx,  18)

# РґРµСЂРµРІСЊСЏ РІРґРѕР»СЊ Р–Рљ
for i, tx in enumerate([-38, -28, 26, 36]):
    tree(200+i, tx, 1)

def lamp_post(idx, lx, ly):
    cyl(f"Lp_pole_{idx}",  (lx, ly, 2.8), 0.075, 5.6, M["dark"])
    sph(f"Lp_globe_{idx}", (lx, ly, 5.7), 0.22, M["logo"])
    point_light(f"Lp_light_{idx}", (lx, ly, 5.7), 1400, (0.98, 0.88, 0.55), 0.8)

for i, lx in enumerate(range(-48, 49, 12)):
    lamp_post(i*2,   lx, -17)
    lamp_post(i*2+1, lx,  24)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  17. РњРђРЁРРќР«
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
car_mats = [M["car"],
            mat("CarRed",   (0.4,0.02,0.02,1), 0.20, 0.25),
            mat("CarBlue",  (0.03,0.08,0.35,1),0.20, 0.25),
            mat("CarWhite", (0.8, 0.8, 0.82,1),0.18, 0.12)]

for ci in range(6):
    cm = car_mats[ci % len(car_mats)]
    cy_pos = -22 + random.uniform(-0.8, 0.8)
    body  = cube(f"Car{ci}_body",  (-56-ci*4, cy_pos, 0.50),      (0.70, 1.20, 0.32), cm)
    glass = cube(f"Car{ci}_glass", (-56-ci*4, cy_pos+0.10, 0.82), (0.60, 0.60, 0.24), M["glass"])
    flt   = cube(f"Car{ci}_flt",   (-56-ci*4, cy_pos+1.22, 0.52), (0.48, 0.09, 0.09), M["logo"])
    blt   = cube(f"Car{ci}_blt",   (-56-ci*4, cy_pos-1.22, 0.52), (0.48, 0.09, 0.09),
                  mat(f"BrakeLt{ci}",(1,0.05,0.02,1),0.1,0,6))
    speed  = random.uniform(0.7, 1.0)
    fr_end = int(200 * speed)
    for obj in [body, glass, flt, blt]:
        obj.location.x = -60 - ci*4
        obj.keyframe_insert("location", frame=1)
        obj.location.x = 70 + ci*3
        obj.keyframe_insert("location", frame=fr_end)
        smooth_keys(obj)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  18. Р¤РРќРђР›Р¬РќР«Р™ Р›РћР“РћРўРРџ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
bpy.ops.object.text_add(
    location=(-18, -30, 6),
    rotation=(math.radians(76), 0, 0))
fin_title = bpy.context.active_object
fin_title.name = "FinalTitle"
fin_title.data.body  = "AVANGARD CITY"
fin_title.data.extrude = 0.22
fin_title.data.bevel_depth = 0.022
fin_title.scale = (2.6, 2.6, 2.6)
add_mat(fin_title, M["logo"])
fin_title.scale = (0.01, 0.01, 0.01)
fin_title.keyframe_insert("scale", frame=182)
fin_title.scale = (2.7, 2.7, 2.7)
fin_title.keyframe_insert("scale", frame=198)
fin_title.scale = (2.6, 2.6, 2.6)
fin_title.keyframe_insert("scale", frame=205)
smooth_keys(fin_title)

bpy.ops.object.text_add(
    location=(-13, -30, 3.0),
    rotation=(math.radians(76), 0, 0))
fin_sub = bpy.context.active_object
fin_sub.name = "FinalSubtitle"
fin_sub.data.body = "Строим будущее сегодня"
fin_sub.data.extrude = 0.06
fin_sub.data.bevel_depth = 0.008
fin_sub.scale = (0.85, 0.85, 0.85)
add_mat(fin_sub, M["logo"])
fin_sub.scale = (0.01, 0.01, 0.01)
fin_sub.keyframe_insert("scale", frame=195)
fin_sub.scale = (0.87, 0.87, 0.87)
fin_sub.keyframe_insert("scale", frame=210)
smooth_keys(fin_sub)

la = cube("LogoA_L",   (-2.2, -30, 8.2), (0.26, 0.10, 2.2), M["gold"])
la.rotation_euler[1] = math.radians(-22)
ra = cube("LogoA_R",   ( 2.2, -30, 8.2), (0.26, 0.10, 2.2), M["gold"])
ra.rotation_euler[1] = math.radians( 22)
cube("LogoA_Bar", (0, -30, 7.4), (1.4, 0.10, 0.20), M["gold"])

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  19. Р¤Р•Р™Р Р’Р•Р РљР
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
FW_COLORS = [
    ("gold",   M["fw_gold"],   (1.0, 0.82, 0.18)),
    ("red",    M["fw_red"],    (1.0, 0.10, 0.04)),
    ("blue",   M["fw_blue"],   (0.30, 0.60, 1.0)),
    ("green",  M["fw_green"],  (0.20, 1.0,  0.35)),
    ("violet", M["fw_violet"], (0.80, 0.20, 1.0)),
    ("white",  M["fw_white"],  (1.0,  0.96, 0.88)),
]

def firework_burst(name, cx, cy, cz, radius, count,
                   fw_mat, light_color,
                   start_frame, flash_dur=18, linger=35):
    rocket = cyl(f"{name}_rocket", (cx, cy, 5), 0.09, 0.5, fw_mat)
    rocket.location = (cx, cy, 5)
    rocket.keyframe_insert("location", frame=start_frame)
    rocket.location = (cx, cy, cz - 1)
    rocket.keyframe_insert("location", frame=start_frame + 14)
    rocket.hide_render = False; rocket.hide_viewport = False
    rocket.keyframe_insert("hide_render",   frame=start_frame - 1)
    rocket.keyframe_insert("hide_viewport", frame=start_frame - 1)
    rocket.hide_render = True; rocket.hide_viewport = True
    rocket.keyframe_insert("hide_render",   frame=start_frame + 15)
    rocket.keyframe_insert("hide_viewport", frame=start_frame + 15)
    smooth_keys(rocket)

    burst = sph(f"{name}_burst", (cx, cy, cz), 0.3, fw_mat)
    hide_range(burst, start_frame + 14, start_frame + linger)
    burst.scale = (0.3, 0.3, 0.3)
    burst.keyframe_insert("scale", frame=start_frame + 14)
    burst.scale = (radius * 0.7, radius * 0.7, radius * 0.7)
    burst.keyframe_insert("scale", frame=start_frame + 22)
    burst.scale = (radius * 0.9, radius * 0.9, radius * 0.5)
    burst.keyframe_insert("scale", frame=start_frame + linger - 3)
    smooth_keys(burst)

    for i in range(count):
        a  = random.uniform(0, math.tau)
        el = random.uniform(-0.8, 0.9)
        d  = random.uniform(radius * 0.4, radius)
        ex = cx + math.cos(a) * math.cos(el) * d
        ey = cy + math.sin(a) * math.cos(el) * d
        ez = cz + math.sin(el) * d * 0.65
        sp = ico(f"{name}_sp{i}", (cx, cy, cz),
                 random.uniform(0.08, 0.22), fw_mat)
        hide_range(sp, start_frame + 15, start_frame + linger + 5)
        sp.location = (cx, cy, cz)
        sp.keyframe_insert("location", frame=start_frame + 15)
        sp.location = (ex, ey, ez)
        sp.keyframe_insert("location", frame=start_frame + linger)
        sp.scale = (1, 1, 1)
        sp.keyframe_insert("scale", frame=start_frame + 15)
        sp.scale = (0.02, 0.02, 0.02)
        sp.keyframe_insert("scale", frame=start_frame + linger + 4)
        smooth_keys(sp)

    bpy.ops.object.light_add(type="POINT", location=(cx, cy, cz))
    fl = bpy.context.active_object
    fl.name = f"{name}_light"
    fl.data.color = light_color
    fl.data.shadow_soft_size = radius * 0.8
    fl.data.energy = 0
    fl.data.keyframe_insert("energy", frame=start_frame + 13)
    fl.data.energy = 25000 + radius * 800
    fl.data.keyframe_insert("energy", frame=start_frame + 15)
    fl.data.energy = 12000
    fl.data.keyframe_insert("energy", frame=start_frame + 20)
    fl.data.energy = 0
    fl.data.keyframe_insert("energy", frame=start_frame + flash_dur + 15)
    smooth_keys(fl)

fw_schedule = [
    (-30,  55,  52,  8, 32, 0, 202),
    (  0,  60,  56,  9, 38, 1, 210),
    ( 32,  52,  50,  7, 28, 2, 216),
    (-18,  58,  60,  8, 30, 3, 222),
    ( 18,  56,  54,  8, 30, 4, 228),
    (  8,  62,  64,  9, 36, 5, 232),
    (-40,  50,  48,7.5, 26, 1, 236),
    ( 40,  48,  46,  7, 26, 0, 238),
    (-10,  65,  70, 10, 42, 2, 240),
    ( 25,  60,  58,  8, 30, 3, 242),
    (-25,  52,  56,  8, 30, 4, 244),
    (  5,  55,  50,  7, 28, 1, 246),
    ( 15,  70,  72, 10, 40, 5, 248),
    (-35,  58,  60,  8, 30, 0, 250),
    ( 35,  62,  66,  9, 34, 2, 252),
    (  0,  50,  45,  7, 28, 3, 254),
    (-20,  68,  68,  9, 34, 1, 256),
    ( 20,  50,  52,  8, 30, 4, 258),
    ( -5,  75,  78, 11, 46, 5, 262),
    (  0,  60,  62,  9, 38, 0, 268),
]
for fi, (fcx,fcy,fcz,fr,fcount,fci,fstart) in enumerate(fw_schedule):
    cname, fm, fcol = FW_COLORS[fci]
    firework_burst(f"FW_{fi}_{cname}", fcx, fcy, fcz, fr, fcount,
                   fm, fcol, fstart, flash_dur=20, linger=40)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  20. РћРЎР’Р•Р©Р•РќРР•
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
bpy.ops.object.light_add(type="SUN", location=(0, 0, 50))
moon = bpy.context.active_object
moon.name = "Moon"
moon.data.energy = 0.5
moon.data.color  = (0.5, 0.6, 1.0)
moon.rotation_euler = (math.radians(55), 0, math.radians(20))

area_light("FillFront", (0, -50, 32), 7000, 70, 24, (math.radians(72), 0, 0))
area_light("RimBack",   (0,  40, 38), 3000, 50, 18, (math.radians(-75), 0, 0))
area_light("SideWarm",  (-65, 0, 40), 2200, 30, 30, (0, math.radians(-55), 0))

bpy.ops.object.light_add(type="SPOT", location=(0, 5, 0))
hq_spot = bpy.context.active_object
hq_spot.name = "HQ_Uplight"
hq_spot.data.energy    = 120000
hq_spot.data.spot_size = math.radians(28)
hq_spot.data.spot_blend= 0.35
hq_spot.data.color     = (1.0, 0.88, 0.52)
hq_spot.rotation_euler = (math.radians(-90), 0, 0)

# РїРѕРґСЃРІРµС‚РєР° Р–Рљ СЃРЅРёР·Сѓ
for jk_x in [-32, 32]:
    bpy.ops.object.light_add(type="SPOT", location=(jk_x, 4, 0))
    jk_spot = bpy.context.active_object
    jk_spot.name = f"JK_Uplight_{jk_x}"
    jk_spot.data.energy    = 60000
    jk_spot.data.spot_size = math.radians(35)
    jk_spot.data.spot_blend= 0.40
    jk_spot.data.color     = (0.88, 0.92, 1.0)
    jk_spot.rotation_euler = (math.radians(-90), 0, 0)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  21. РўРЈРњРђРќ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
bpy.ops.mesh.primitive_cube_add(location=(0, 15, 22))
fog_vol = bpy.context.active_object
fog_vol.name = "CineFog"
fog_vol.scale = (160, 160, 40)
fog_mat = bpy.data.materials.new("FogVol")
fog_mat.use_nodes = True
fn = fog_mat.node_tree.nodes
fl2 = fog_mat.node_tree.links
fn.clear()
fo  = fn.new("ShaderNodeOutputMaterial")
fvp = fn.new("ShaderNodeVolumePrincipled")
if "Density"    in fvp.inputs: fvp.inputs["Density"].default_value    = 0.0038
if "Anisotropy" in fvp.inputs: fvp.inputs["Anisotropy"].default_value = 0.25
fl2.new(fvp.outputs["Volume"], fo.inputs["Volume"])
fog_vol.data.materials.append(fog_mat)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  22. РљРђРњР•Р Рђ
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
bpy.ops.object.empty_add(type="PLAIN_AXES", location=(0, 20, 14))
cam_target = bpy.context.active_object
cam_target.name = "CamTarget"

target_path = [
    (1,   (0,   25,  14)),
    (60,  (0,   20,  13)),
    (100, (-4,  12,  10)),
    (120, (0,    8,  12)),
    (150, (0,   14,  18)),
    (175, (0,   20,  16)),
    (200, (2,   45,  34)),
    (250, (4,   58,  46)),
    (300, (6,   62,  52)),
]
for fr, loc in target_path:
    cam_target.location = loc
    cam_target.keyframe_insert("location", frame=fr)
smooth_keys(cam_target)

bpy.ops.object.camera_add(location=(-155, -130, 72))
cam = bpy.context.active_object
cam.name = "CineCamera"
scene.camera = cam

con = cam.constraints.new(type="TRACK_TO")
con.target     = cam_target
con.track_axis = "TRACK_NEGATIVE_Z"
con.up_axis    = "UP_Y"

cam.data.lens       = 36
cam.data.clip_start = 0.1
cam.data.clip_end   = 8000

if hasattr(cam.data, "dof"):
    cam.data.dof.use_dof       = True
    cam.data.dof.focus_object  = cam_target
    cam.data.dof.aperture_fstop = 8.0

cam_path = [
    (1,   (-155, -130,  72)),
    (30,  (-120, -105,  60)),
    (60,  ( -85,  -85,  50)),
    (90,  ( -48,  -68,  40)),
    (120, (  -8,  -58,  34)),
    (150, (  35,  -72,  44)),
    (175, (  65,  -96,  54)),
    (200, (  30,  -80,  62)),
    (230, (   8,  -60,  75)),
    (265, (   0,  -48,  85)),
    (300, (  -5,  -42,  92)),
]
for fr, loc in cam_path:
    cam.location = loc
    cam.keyframe_insert("location", frame=fr)
smooth_keys(cam)

# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
#  23. Р¤РРќРђР›
# в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ

# -------------------------------------------------------------
# CLOUD REALISM POLISH: floor, background, imperfections
# -------------------------------------------------------------
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

scene.frame_set(1)
print("=" * 65)
print("AVANGARD CITY v3.0 production scene is ready")
print(f"Frames: {scene.frame_start}-{scene.frame_end} | {scene.render.fps} fps | 1920x1080")
print(f"Engine: {scene.render.engine}")
print(f"Fireworks: {len(fw_schedule)}")
print("Residential blocks: JK_L (x=-32) | JK_R (x=+32)")
print("Production polish: realistic floor, background skyline, cloud-safe collections")
print("Render: Ctrl+F12 or blender --background file.blend --python scripts/main.py")
print("=" * 65)
