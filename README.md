# QG_ArTeK_Camera_Feeds

![QG ArTeK Camera Feeds](img/cover.jpeg)

In-game monitor system for ARMA 3. Place screens in a command post and watch, in real time, what your men's helmet cameras see, what vehicle turrets and drones are looking at, or what a spotter has in his optic.

The video is rendered to a render target and applied as a texture on the object's screen: it is a working monitor inside the game world, visible to anyone who walks past it.

---

## Contents

- [Requirements](#requirements)
- [Setup](#setup)
- [The three sources](#the-three-sources)
  - [Operator Cam](#operator-cam)
  - [Spotter](#spotter)
  - [Turrets and vehicles](#turrets-and-vehicles)
- [The monitor menu](#the-monitor-menu)
- [The selection window](#the-selection-window)
- [Permissions](#permissions)
  - [1. Which sources exist](#1-which-sources-exist)
  - [2. Which sides](#2-which-sides)
  - [3. Vehicles: category per side](#3-vehicles-category-per-side)
  - [4. Which seats inside a vehicle](#4-which-seats-inside-a-vehicle)
  - [5. Operators and spotters: side and AI/player](#5-operators-and-spotters-side-and-aiplayer)
  - [6. Which optics count as a spotter](#6-which-optics-count-as-a-spotter)
  - [Order of precedence](#order-of-precedence)
- [Image quality](#image-quality)
- [Zoom and vision](#zoom-and-vision)
- [Full settings reference](#full-settings-reference)
- [Diagnostics](#diagnostics)
- [Multiplayer and performance](#multiplayer-and-performance)
- [Known limitations](#known-limitations)

---

## Requirements

| Mod | Required | Why |
|---|---|---|
| **CBA_A3** | yes | cTab dependency, and `CBA_fnc_getFov` measures the operator's zoom |
| **cTab** | yes | the `ItemcTabHCam` item and the `cTab_fnc_checkGear` function are used to identify operators |
| **ACE3** | optional | if present the menu uses ACE interaction, otherwise it falls back to `addAction` |

Without cTab the system will not run properly: the operator lookup calls `cTab_fnc_checkGear`.

**Mandatory video setting:** every player needs **PiP** enabled in the video options. With PiP off the monitors stay black. The PiP quality setting also determines the resolution the game actually renders the feed at — see [Image quality](#image-quality).

---

## Setup

The script is a single `.sqf` file that goes **in an object's init field** in Eden.

1. Place any object to act as the controller: a **Game Logic** works well (Entities → Logic Entities → Objects → Logic).
2. Place the **monitors**. You need an object whose screen is the first texture selection, for example `Land_TripodScreen_01_large_F` or `Land_TripodScreen_01_small_F`.
3. **Synchronize** every monitor to the controller (`F5` in Eden, then drag from the controller to the monitor).
4. Open the controller's init field and paste the whole contents of the file into it.

![Game Logic with synchronized monitors](img/logic_screen.png)

*The controller in Eden, with synchronization lines running to the monitors.*

On startup the synchronized monitors are read from `synchronizedObjects this`, automatically renamed `ARTEK_monitor_0`, `ARTEK_monitor_1` and so on, and given the interaction menu.

> An object that is not synchronized to the controller gets nothing. If the menu does not show up, check the synchronization first.

### How many monitors

`_rt_slots` (default `4`) is the number of distinct render targets available. From the fifth monitor onwards render targets get recycled and two screens will steal each other's image. You can raise it, but every active render target is one more scene rendered every frame: two or three feeds running at once is already a serious load.

Render targets are assigned by the server, one per monitor, in the order the screens were synchronized, and the clients only read the value: no two machines can end up disagreeing on who owns which target.

`_rt_base` (default `0`) shifts the whole block. Render target names are shared with everything else running in the game, so if another mod already holds the first slots — cTAB Advanced, for one, sits on 8, 9, 12 and 13 — point the base at a free number and every monitor moves out of the way at once.

---

## The three sources

### Operator Cam

Streams a unit's **helmet camera**.

**What the unit needs:** the **`ItemcTabHCam`** item in its inventory. It is a cTab item: put it in the uniform, vest or backpack from the arsenal by searching for the helmet cam among the items.

It does not need to be held or switched on — it just needs to be carried. The unit shows up in the list as long as it has one; if the item is lost or the unit dies, the feed disconnects by itself.

![Helmet Camera in the arsenal](img/IteamcTab-Cam_screen.png)

*The item to look for in the arsenal: Helmet Camera, class `ItemcTabHCam`.*

![Select Operator window](img/screenoperator.jpg)

*The operator list, split into tabs by side.*

The camera is attached to the unit's head with a small offset, adjustable through `_helmet_cam_offset`, `_helmet_cam_pitch`, `_helmet_cam_yaw`, `_helmet_cam_roll` and `_helmet_cam_fov`. There is no zoom: it films at a fixed field of view, like an action cam.

### Spotter

Streams **what the unit is looking at through its optic**: same direction, same magnification.

**What the unit needs:** a recognised optic, and it has to be **in hand**. The check is on `currentWeapon`, so the unit only appears in the list while the binoculars or designator are raised. If they switch back to their rifle they drop off the list, and if they do it with the feed running the feed disconnects.

Recognised optics are:

- every class listed in `_spotter_optics`;
- with `_spotter_any_binocular = true` (default), **any binocular-class item**, meaning `type = 4096` in `CfgWeapons`. That covers binoculars, rangefinders and every laser designator including modded ones, with no need to list classes by hand.

What you get on the monitor: the optic's real framing and magnification. You do **not** get the black mask and reticle — that is interface drawn on the player's screen, not part of the 3D scene, and it cannot enter a render target.

The camera is pushed forward by `_spotter_cam_forward` metres (default `0.35`) along the view direction, to clear the unit's own head and hands. If you still see fingers in frame, raise it to `0.5`.

![Select Spotter window](img/screenspotter.jpg)

*The optic currently in the unit's hands is shown next to the name.*

### Turrets and vehicles

Streams what a **turret** is looking at, or the driver seat where that makes sense.

**What is needed:** nothing carried. What matters is the vehicle: it has to be in an enabled category, on an enabled side, and satisfy the crew rule.

Six categories are recognised, plus one:

| Category | What it covers |
|---|---|
| `drone` | anything that is `unitIsUAV`, airborne or ground |
| `plane` | fixed wing aircraft |
| `heli` | helicopters |
| `tank` | tracked vehicles and heavy APCs |
| `car` | wheeled vehicles, MRAPs, quads |
| `boat` | naval and amphibious vehicles |
| `static` | static emplacements (off by default) |

The drone test runs **first**, so a UGV stays a drone instead of ending up among the wheeled vehicles.

![Select Turret window](img/screenturret.jpg)

*Tabs by side, and inside each tab one column per vehicle category.*

---

## The monitor menu

With ACE installed the entries live in the **object** interaction menu: aim at the monitor and hold the interaction key (`Win` by default). It is not in self-interaction.

Without ACE the same entries are in the scroll wheel menu.

![Monitor interaction menu](img/screenmenu.jpg)

*With the monitor off, only the three selection entries remain.*

| Entry | When it shows |
|---|---|
| **Select Operator** | always, if `_feed_operator` is on |
| **Select Turret** | always, if `_feed_turret` is on |
| **Select Spotter** | always, if `_feed_spotter` is on |
| **Change Vision** | while a feed is running |
| **Zoom In** / **Zoom Out** | only on a turret feed, and only if a step in that direction exists |
| **Disconnect Camera** | while a feed is running |

The three selection entries are available **even while a feed is already running**: picking a new source drops the previous one and attaches the new one by itself. There is no need to disconnect first, and you can jump straight from one source type to another.

---

## The selection window

The window is split into **tabs by side**. Tabs only exist for enabled sides, plus always your own.

- **Select Turret** opens the wide window: each tab holds **one column per vehicle category**, ordered like the rows of `_veh_rules`. Categories with no vehicles on that side are not drawn, so the remaining columns stay wide.
- **Select Operator** and **Select Spotter** open the narrow window with a single list.

Rows are coloured by side according to `_side_colors`. The colour is redundant next to the tab, but it is your free visual check: if a row comes out the wrong colour, you know side detection is misreading something.

An enabled but empty tab shows the `_string_tab_empty` message instead of disappearing, so you can tell "there is nothing" apart from "the filter is dropping it".

Switching tabs clears the selection and moves it to the first available entry.

---

## Permissions

They all live in the **first 32 lines of the file**, in blocks separated by blank lines. Everything below that is cosmetics and camera mechanics.

Permissions are layered: a higher layer switched off makes the ones below it irrelevant.

### 1. Which sources exist

```sqf
private _feed_operator = true;
private _feed_turret   = true;
private _feed_spotter  = true;
```

These switch the three menu entries on and off. **They are the top layer**: with all three set to `false` the monitor has no entries at all and the rest of the configuration is never even read.

### 2. Which sides

```sqf
private _show_additional_sides = [["blufor", true], ["opfor", true], ["independent", true], ["civilian", true]];
```

Decides which **tabs** exist in the selection window.

> It is called *additional* because these are the sides **on top of** your own. Your own side is always visible, even with everything set to `false`.

### 3. Vehicles: category per side

```sqf
private _rule_sides = ["west", "east", "guer", "civ"];
private _veh_rules = [
    ["drone",  ["free", "free", "free", "free"]],
    ["tank",   ["any",  "any",  "any",  "any" ]],
    ["car",    ["any",  "any",  "any",  "any" ]],
    ["plane",  ["any",  "any",  "any",  "any" ]],
    ["heli",   ["any",  "any",  "any",  "any" ]],
    ["boat",   ["any",  "any",  "any",  "any" ]],
    ["static", ["hide", "hide", "hide", "hide"]]
];
```

A matrix: **rows = category**, **columns = side**. The column order is declared in `_rule_sides`, on the line right above the table: reorder it there and the table follows.

Each cell says both whether the category is active for that side and what crew is required:

| Value | Meaning |
|---|---|
| `"hide"` | the category does not appear for that side |
| `"free"` | always appears, no crew check at all |
| `"any"` | someone must be aboard, player or AI |
| `"player"` | at least one player aboard |
| `"ai"` | at least one AI aboard |

**On drones `"player"` works differently.** A drone always has AI inside, so checking the crew would tell you nothing. For drones the rule reads `UAVControl`, meaning whoever is connected at the **terminal**: `"player"` means "a player is flying it right now".

Example — BLUFOR planes only when a player is flying, OPFOR tanks always, no civilian helicopters:

```sqf
["plane", ["player", "any",  "any", "hide"]],
["tank",  ["any",    "free", "any", "hide"]],
["heli",  ["any",    "any",  "any", "hide"]],
```

### 4. Which seats inside a vehicle

```sqf
private _turret_filter = "gunner";
private _list_driver_seat = true;
```

`_turret_filter` decides which positions make the list:

| Value | What it lists |
|---|---|
| `"gunner"` | **armed** turrets only — default |
| `"crewed"` | all real turrets, including unarmed ones, but no passenger seats |
| `"all"` | everything, including FFV passenger positions |

With `"gunner"` the copilot seats (`isCopilot = 1`), FFV positions and every unarmed station are dropped. **One exception: drones**, which often carry a sensor-only turret with no weapon — the weapon check does not apply to them.

`_list_driver_seat` includes the **driver seat**, which in SQF is turret path `[-1]`. It matters most for aircraft: a jet has no turrets, the pilot is the driver and the weapons are his, so without this option planes would not show up at all. With `_turret_filter = "gunner"` the driver seat only makes it in if it is armed. The entry is labelled `Pilot` on air vehicles and `Driver` on everything else.

### 5. Operators and spotters: side and AI/player

```sqf
private _operator_rules = ["any", "any", "any", "any"];
private _spotter_rules  = ["any", "any", "any", "any"];
```

One cell per side, same column order as `_rule_sides`. These are **two independent tables**, read by two different functions: you can make them diverge as much as you like.

| Value | Meaning |
|---|---|
| `"hide"` | that side does not appear for that source |
| `"any"` | players and AI |
| `"player"` | players only |
| `"ai"` | AI only |

There is no `"free"`: a person has no crew to check.

Example — helmet cams from BLUFOR players only, spotters from anyone except civilians:

```sqf
_operator_rules = ["player", "hide", "hide", "hide"];
_spotter_rules  = ["any",    "any",  "any",  "hide"];
```

### 6. Which optics count as a spotter

```sqf
private _spotter_optics = [
    "Nikon_DSLR_HUD", "Nikon_DSLR",
    "Hate_Smartphone_HUD", "Hate_Smartphone",
    "Laserdesignator"
];
private _spotter_any_binocular = true;
```

`_spotter_optics` is the explicit list of accepted classes. `_spotter_any_binocular` additionally accepts any binocular-class item (`type = 4096`), which covers binoculars, rangefinders and designators including modded ones without listing them.

Set it to `false` and only the hand-written classes count.

### Order of precedence

Strongest first:

1. `_feed_*` — if the menu entry does not exist, nothing else matters
2. `_show_additional_sides` — no tab for a side means you never see it
3. the per-source tables — `_veh_rules`, `_operator_rules`, `_spotter_rules`
4. `_turret_filter` and `_list_driver_seat` — which seats inside an already-allowed vehicle
5. `_spotter_optics` — what counts as an optic

Switching a side off at step 2 removes the tab entirely. Setting `"hide"` at step 3 keeps the tab and shows it empty: that is deliberate, so you can tell "I don't watch this side" apart from "I watch this side, but not its spotters".

---

## Image quality

```sqf
private _rt_width  = 2048;
private _rt_height = 2048;
private _rt_aspect = 1.777;
private _disable_dof = true;
```

`_rt_width` and `_rt_height` are the render target texture dimensions. **They must be powers of two**: the engine rejects values like 1920 or 1080 with a *Cannot load texture* error and the monitor stays black. The code rounds up to the next power of two anyway, capped at 2048, so a wrong value still produces a working feed.

That means a true 16:9 texture is not achievable. `_rt_aspect` is the ratio the engine **frames** the scene at (`1.777` = 16:9, `1.333` = 4:3, `1.0` = square) and is independent of the texture shape. The closest thing to 16:9 among powers of two is `2048 × 1024`, which also halves the memory per monitor.

`_disable_dof` set to `true` turns off depth of field on the feed: the whole scene stays in focus and the image is sharper.

> **The real ceiling is the PiP setting in the game's video options.** It governs the resolution the engine actually renders render targets at, and it overrides any number written here. If the feed looks grainy, check that first — and it is per player, so on a server everyone gets their own quality.

A note on models: PiP draws with reduced levels of detail. A large object half a metre from the lens comes out faceted, and that is not a resolution problem — raising the numbers will not fix it.

---

## Zoom and vision

```sqf
private _turret_zoom_steps = [0.25, 0.05, 0.0167];
private _turret_zoom_names = ["Wide", "Medium", "Narrow"];
private _turret_zoom_default = 0;
```

Three discrete steps, taken from real targeting pods (30/120, 6/120, 2/120). They apply **only to vehicle feeds**: the helmet cam has no zoom by design, and the spotter already follows his own optic's magnification.

The array runs from widest to narrowest, so a higher index means tighter. Zoom does not wrap around, it stops at the ends, and the menu entries only appear when a step in that direction exists.

![Zoom In on a turret feed](img/screenZoomTurret_IN_OUT.jpg)

*At the widest step only Zoom In shows: Zoom Out appears from Medium onwards.*

### Following the operator's zoom

```sqf
private _follow_operator_zoom = true;
private _operator_fov_step = 0.004;
private _operator_fov_interval = 0.15;
private _operator_fov_scale = 1;
```

When a **player** is looking through the vehicle — sitting in the turret, or connected to a drone from the UAV terminal — the feed reproduces his zoom instead of the fixed steps. Connecting to that turret starts from exactly what he is framing, and the three steps become relative: the first one is his own view, the other two can only narrow down from there. The monitor never goes wider than the operator.

The field of view can only be measured on the machine that is drawing that view, so the operator's own client measures it and publishes it on the vehicle, and the monitors read it from there. The measurement is taken every `_operator_fov_interval` seconds and only sent when it moves by more than `_operator_fov_step`, so a feed that is sitting still costs no traffic.

The last value stays on the vehicle after the operator leaves the station: zoom into a drone's FLIR, walk back to the command post, and you find the monitor framed the way you left it. If nobody is looking through the vehicle at all — AI gunner, drone with no one at the terminal — there is nothing to mirror and the fixed steps take over.

`_operator_fov_scale` (default `1`) multiplies the mirrored value, for when the feed comes out consistently wider or narrower than what the operator actually sees. `_follow_operator_zoom = false` turns the whole thing off and leaves the fixed steps in charge.

### Vision modes

```sqf
private _vision_modes = [
    ["Normal", [0]],
    ["Night",  [1]]
];
```

Each entry is `[display name, array passed to setPiPEffect]`. `Change Vision` cycles the table, and the change is **propagated to every client**: without that the effect would only apply to whoever pressed it.

`setPiPEffect` applies **one effect at a time**, they do not stack. Available indices:

![Night vision on the feed](img/screenNVG.jpg)

*Change Vision cycles the table, and the change applies on every client.*

| Index | Effect |
|---|---|
| `0` | normal |
| `1` | night vision |
| `2` | thermal white hot |
| `3` | colour correction `[3, enabled, brightness, contrast, offset, blend, lerp, weights]` |
| `4` | mirror |
| `5` | chromatic aberration |
| `6` | film grain `[6, enabled, intensity, sharpness, grain size, i1, i2, mono]` |
| `7` | thermal black hot |

Ready-made rows to drop into the table:

```sqf
["Contrast",  [3, 1, 1.05, 1.22, -0.02, [0,0,0,0], [1,1,1,1], [0.299, 0.587, 0.114, 0]]],
["White Hot", [2]],
["Black Hot", [7]]
```

---

## Full settings reference

### Permissions

| Variable | Default | What it does |
|---|---|---|
| `_feed_operator` | `true` | Select Operator entry |
| `_feed_turret` | `true` | Select Turret entry |
| `_feed_spotter` | `true` | Select Spotter entry |
| `_show_additional_sides` | all `true` | sides beyond your own |
| `_rule_sides` | `west east guer civ` | column order for the tables |
| `_veh_rules` | see above | vehicle category × side |
| `_turret_filter` | `"gunner"` | which positions to list |
| `_list_driver_seat` | `true` | include the driver seat |
| `_operator_rules` | all `"any"` | operators per side |
| `_spotter_rules` | all `"any"` | spotters per side |
| `_spotter_optics` | 5 classes | accepted optics |
| `_spotter_any_binocular` | `true` | accept any binocular |

### Image and camera

| Variable | Default | What it does |
|---|---|---|
| `_rt_width` / `_rt_height` | `2048` | render target texture, powers of two |
| `_rt_aspect` | `1.777` | framing ratio |
| `_rt_slots` | `4` | distinct render targets available |
| `_rt_base` | `0` | first render target used, shifts the whole block |
| `_disable_dof` | `true` | disables depth of field |
| `_turret_zoom_steps` | `0.25 0.05 0.0167` | turret zoom steps |
| `_turret_zoom_names` | `Wide Medium Narrow` | step labels |
| `_turret_zoom_default` | `0` | step on connect |
| `_follow_operator_zoom` | `true` | mirror the operator's zoom on vehicle feeds |
| `_operator_fov_step` | `0.004` | how far the zoom must move before it is published |
| `_operator_fov_interval` | `0.15` | seconds between measurements |
| `_operator_fov_scale` | `1` | multiplier on the mirrored zoom |
| `_vision_modes` | `Normal`, `Night` | vision modes |
| `_helmet_cam_offset` | `[0.2, 0, 0.175]` | helmet cam offset |
| `_helmet_cam_pitch` / `_yaw` / `_roll` | `0` | helmet cam orientation |
| `_helmet_cam_fov` | `0.87` | helmet cam field of view |
| `_spotter_cam_forward` | `0.35` | spotter camera forward push, in metres |

### Interface

| Variable | Default | What it does |
|---|---|---|
| `_use_ace_interaction` | `true` | use ACE when present |
| `_show_group` / `_show_group_number` | `false` | show group and number in lists |
| `_show_distance` | `true` | show distance in lists |
| `_side_colors` | 4 colours | row colour per side |
| `_ui_color_group_rgba` | amber | column header colour |
| `_string_side_*` | `BLUFOR` etc. | tab names |
| `_string_tab_empty` | `Nothing available` | empty tab message |
| `_string_pilot_seat` / `_string_driver_seat` | `Pilot` / `Driver` | driver seat label |
| `_string_change_vision` | `Change Vision` | vision entry label |
| `_string_zoom_in` / `_string_zoom_out` | `Zoom In` / `Zoom Out` | zoom labels |

### Diagnostics

| Variable | Default | What it does |
|---|---|---|
| `_spotter_fov_debug` | `false` | logs spotter zoom values to the .rpt |
| `_operator_fov_debug` | `false` | logs the mirrored zoom to the system chat and the .rpt |

---

## Diagnostics

On startup, in the `.rpt`:

```
[QG_ArTeK_Camera_Feeds] versione 4.13
```

If it is not there, the script is not running. If the number differs from what you expect, you are loading an old file.

Right after it, one line per monitor with the render target it was handed:

```
[QG_ArTeK_Camera_Feeds] monitor 0 render target 0
[QG_ArTeK_Camera_Feeds] init monitor ARTEK_monitor_0 su rendertarget0
```

Two screens on the same number means they are sharing a target and will steal each other's image: raise `_rt_slots`, or move the block with `_rt_base` if another mod is in the way.

Once the mission is up, at the first pass of the zoom mirroring:

```
[QG_ArTeK_Camera_Feeds] publisher FOV attivo, versione 4.13
```

On the first feed connection:

```
[QG_ArTeK_Camera_Feeds] render target #(argb,2048,2048,1)r2t(rendertarget0,1.777) | PiP abilitato true
```

This confirms the resolution actually reaching the engine, after the power-of-two rounding, and whether PiP is on.

With `_spotter_fov_debug = true`, while a spotter feed is running:

```
[QG_ArTeK_Camera_Feeds] spotter Rossi arma Laserdesignator getObjectFOV 0.42 usato 0.42 (live)
```

It is only written when the value changes, so it does not flood the log.

With `_operator_fov_debug = true`, while you are the one looking through a vehicle, the system chat reports what is being published:

```
[ArTeK] B_UAV_02_dynamicLoadout_F terminale ARTEK_fov_[0] FOV 0.0429 [cba]
```

Left to right: the vehicle, how you were recognised (`terminale` from the UAV terminal, `posto` from a seat), the variable the value is published under, the measured field of view and where the measurement came from (`cba` or `obj`). Anything outside 0.005–1.6 is discarded and never reaches the monitor.

### Troubleshooting

| Symptom | What to check |
|---|---|
| no entries in the menu | is the monitor synchronized to the controller? are the `_feed_*` on? are you aiming at the monitor rather than using self-interaction? |
| black monitor | is PiP enabled in the video options? |
| *Cannot load texture* | `_rt_width` / `_rt_height` are not powers of two |
| empty list | is the side enabled? is the table cell something other than `"hide"`? does the unit have the right item **in hand** (spotter) or **carried** (operator)? |
| planes never show up | set `_list_driver_seat` to `true`: a plane has no turrets |
| the list is enormous | `_turret_filter` set to `"all"` includes every passenger seat; switch to `"gunner"` |
| grainy image | PiP setting in the video options |
| the monitor ignores the operator's zoom | is `_follow_operator_zoom` on? is a **player** actually looking through that vehicle? with an AI gunner there is nothing to mirror |

---

## Multiplayer and performance

On a **dedicated server** the cost is zero: cameras and the per-frame handler are only created on machines with an interface. The server sets the variables and the texture, and stops there.

The cost falls on the **clients**, and it is one full scene render per running feed, every frame. Two active monitors mean two extra scenes.

---

## Known limitations

**Every client renders the feed.** Connecting a source is broadcast to every machine, so every connected player creates their own camera and pays the render cost — including people kilometres away who will never see that monitor. With a handful of players it does not show; on a full server it is a cost spread across everyone for an image two people care about.

**Players joining in progress do not get the feed.** They receive the menu but no camera, because the connect never ran on their machine: they see a black monitor until someone reselects the source.

**Redundant traffic on connect.** The connect routine runs on every machine and each one repeats the same global and public calls. Nothing breaks, but it is avoidable traffic.

**The optic frame does not enter the feed.** Reticle, black mask and designator readouts are interface drawn on the player's screen, not scene geometry: a render target only renders the 3D scene. The feed reproduces framing and magnification, not the optic's graphics.

**An object very close to the lens comes out faceted**, because PiP uses reduced levels of detail. It is not a resolution issue.

**Only a player's zoom can be mirrored.** The field of view is measured on the machine drawing that view, so a turret in AI hands publishes nothing and the feed falls back to the fixed steps.
