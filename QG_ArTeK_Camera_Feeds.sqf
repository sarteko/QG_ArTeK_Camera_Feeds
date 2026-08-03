ARTEK_OperatorCam_Version = "4.13";
diag_log format ["[QG_ArTeK_Camera_Feeds] versione %1", ARTEK_OperatorCam_Version];

private _feed_operator = true;
private _feed_turret = true;
private _feed_spotter = true;

private _show_additional_sides = [["blufor", true], ["opfor", true], ["independent", true], ["civilian", true]];

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

private _turret_filter = "gunner";
private _list_driver_seat = true;

private _operator_rules = ["any", "any", "any", "any"];
private _spotter_rules  = ["any", "any", "any", "any"];

private _spotter_optics = [
    "Nikon_DSLR_HUD", "Nikon_DSLR",
    "Hate_Smartphone_HUD", "Hate_Smartphone",
    "Laserdesignator"
];
private _spotter_any_binocular = true;

private _use_ace_interaction = true;
private _show_group = false;
private _show_group_number = false;
private _show_distance = true;
private _ui_color_list_rgba = [0, 0.42, 1, 1];
private _ui_color_confirm_rgba = [0, 0.42, 1, 0.8];
private _ui_color_cancel_rgba = [0.1, 0.1, 0.3, 0.8];
private _ui_color_header_hex_RRGGBB = "#006BC4";
private _string_ui_confirm = "Confirm";
private _string_ui_cancel = "Cancel";
private _string_interactionMenu_select_operator = "Select Operator";
private _string_interactionMenu_disconnect_camera = "Disconnect Cameras";
private _string_noCams_found_hint = "No operators with cameras available";
private _helmet_cam_offset = [0.2, 0, 0.175];
private _helmet_cam_pitch = 0;
private _helmet_cam_yaw = 0;
private _helmet_cam_roll = 0;
private _helmet_cam_fov = 0.87;

private _rt_width  = 2048;
private _rt_height = 2048;
private _rt_aspect = 1.777;

private _rt_slots = 4;
private _rt_base = 0;

private _disable_dof = true;

private _turret_zoom_steps = [0.25, 0.05, 0.0167];
private _turret_zoom_names = ["Wide", "Medium", "Narrow"];
private _turret_zoom_default = 0;

private _follow_operator_zoom = true;
private _operator_fov_step = 0.004;
private _operator_fov_interval = 0.15;
private _operator_fov_debug = false;
private _operator_fov_scale = 1;

private _string_side_west = "BLUFOR";
private _string_side_east = "OPFOR";
private _string_side_guer = "INDIP";
private _string_side_civ = "CIVILI";
private _string_tab_empty = "Nothing available";
private _string_pilot_seat = "Pilot";
private _string_driver_seat = "Driver";
private _ui_color_group_rgba = [1, 0.75, 0.2, 1];
private _side_colors = [
    ["west", [0.25, 0.6, 1, 1]],
    ["east", [1, 0.28, 0.28, 1]],
    ["guer", [0.3, 0.9, 0.35, 1]],
    ["civ",  [0.85, 0.45, 1, 1]]
];

private _spotter_cam_forward = 0.35;
private _spotter_fov_debug = false;

private _vision_modes = [
    ["Normal", [0]],
    ["Night",  [1]]
];

private _string_change_vision = "Change Vision";
private _string_zoom_in = "Zoom In";
private _string_zoom_out = "Zoom Out";

ARTEK_fnc_getOperatorTextureIndex = { 0 };

if ((count _ui_color_header_hex_RRGGBB) == 9) then {
    _ui_color_header_hex_RRGGBB = _ui_color_header_hex_RRGGBB select [0,7];
};

if (isServer) then {
    missionNamespace setVariable ["ARTEK_allow_groupID", _show_group, true];
    missionNamespace setVariable ["ARTEK_allow_groupNumber", _show_group_number, true];
    missionNamespace setVariable ["ARTEK_allow_distance", _show_distance, true];
    missionNamespace setVariable ["ARTEK_allowed_sides", _show_additional_sides, true];
    missionNamespace setVariable ["ARTEK_feed_operator", _feed_operator, true];
    missionNamespace setVariable ["ARTEK_feed_turret", _feed_turret, true];
    missionNamespace setVariable ["ARTEK_feed_spotter", _feed_spotter, true];
    missionNamespace setVariable ["ARTEK_operator_rules", _operator_rules, true];
    missionNamespace setVariable ["ARTEK_spotter_rules", _spotter_rules, true];
    missionNamespace setVariable ["ARTEK_ui_color_list", _ui_color_list_rgba, true];
    missionNamespace setVariable ["ARTEK_ui_color_confirm", _ui_color_confirm_rgba, true];
    missionNamespace setVariable ["ARTEK_ui_color_cancel", _ui_color_cancel_rgba, true];
    missionNamespace setVariable ["ARTEK_ui_color_header", _ui_color_header_hex_RRGGBB, true];
    missionNamespace setVariable ["ARTEK_string_ui_confirm", _string_ui_confirm, true];
    missionNamespace setVariable ["ARTEK_string_ui_cancel", _string_ui_cancel, true];
    missionNamespace setVariable ["ARTEK_string_interactionMenu_select", _string_interactionMenu_select_operator, true];
    missionNamespace setVariable ["ARTEK_string_interactionMenu_disconnect", _string_interactionMenu_disconnect_camera, true];
    missionNamespace setVariable ["ARTEK_helmet_cam_offset", _helmet_cam_offset, true];
    missionNamespace setVariable ["ARTEK_helmet_cam_pitch", _helmet_cam_pitch, true];
    missionNamespace setVariable ["ARTEK_helmet_cam_yaw", _helmet_cam_yaw, true];
    missionNamespace setVariable ["ARTEK_helmet_cam_roll", _helmet_cam_roll, true];
    missionNamespace setVariable ["ARTEK_helmet_cam_fov", _helmet_cam_fov, true];
    missionNamespace setVariable ["ARTEK_string_nocams_hint", _string_noCams_found_hint, true];

    missionNamespace setVariable ["ARTEK_rt_width", _rt_width, true];
    missionNamespace setVariable ["ARTEK_rt_height", _rt_height, true];
    missionNamespace setVariable ["ARTEK_rt_aspect", _rt_aspect, true];
    missionNamespace setVariable ["ARTEK_rt_slots", _rt_slots, true];
    missionNamespace setVariable ["ARTEK_rt_base", _rt_base, true];
    missionNamespace setVariable ["ARTEK_disable_dof", _disable_dof, true];
    missionNamespace setVariable ["ARTEK_turret_zoom_steps", _turret_zoom_steps, true];
    missionNamespace setVariable ["ARTEK_turret_zoom_names", _turret_zoom_names, true];
    missionNamespace setVariable ["ARTEK_turret_zoom_default", _turret_zoom_default, true];
    missionNamespace setVariable ["ARTEK_follow_operator_zoom", _follow_operator_zoom, true];
    missionNamespace setVariable ["ARTEK_operator_fov_step", _operator_fov_step, true];
    missionNamespace setVariable ["ARTEK_operator_fov_interval", _operator_fov_interval, true];
    missionNamespace setVariable ["ARTEK_operator_fov_debug", _operator_fov_debug, true];
    missionNamespace setVariable ["ARTEK_operator_fov_scale", _operator_fov_scale, true];
    missionNamespace setVariable ["ARTEK_vision_modes", _vision_modes, true];
    missionNamespace setVariable ["ARTEK_rule_sides", _rule_sides, true];
    missionNamespace setVariable ["ARTEK_veh_rules", _veh_rules, true];
    missionNamespace setVariable ["ARTEK_turret_filter", _turret_filter, true];
    missionNamespace setVariable ["ARTEK_list_driver_seat", _list_driver_seat, true];
    missionNamespace setVariable ["ARTEK_string_side_west", _string_side_west, true];
    missionNamespace setVariable ["ARTEK_string_side_east", _string_side_east, true];
    missionNamespace setVariable ["ARTEK_string_side_guer", _string_side_guer, true];
    missionNamespace setVariable ["ARTEK_string_side_civ", _string_side_civ, true];
    missionNamespace setVariable ["ARTEK_string_tab_empty", _string_tab_empty, true];
    missionNamespace setVariable ["ARTEK_string_pilot_seat", _string_pilot_seat, true];
    missionNamespace setVariable ["ARTEK_string_driver_seat", _string_driver_seat, true];
    missionNamespace setVariable ["ARTEK_ui_color_group", _ui_color_group_rgba, true];
    missionNamespace setVariable ["ARTEK_side_colors", _side_colors, true];
    missionNamespace setVariable ["ARTEK_spotter_optics", _spotter_optics, true];
    missionNamespace setVariable ["ARTEK_spotter_any_binocular", _spotter_any_binocular, true];
    missionNamespace setVariable ["ARTEK_spotter_cam_forward", _spotter_cam_forward, true];
    missionNamespace setVariable ["ARTEK_spotter_fov_debug", _spotter_fov_debug, true];
    missionNamespace setVariable ["ARTEK_string_change_vision", _string_change_vision, true];
    missionNamespace setVariable ["ARTEK_string_zoom_in", _string_zoom_in, true];
    missionNamespace setVariable ["ARTEK_string_zoom_out", _string_zoom_out, true];

    if (isClass (configFile >> "CfgPatches" >> "ace_main") && _use_ace_interaction) then {
        missionNamespace setVariable ["ARTEK_use_ace_interaction", true, true];
    };

    private _slotCount = _rt_slots max 1;
    private _ARTEK_OperatorCam_SyncConfig = [];
    {
        _ARTEK_OperatorCam_SyncConfig pushBack _x;
        _x setVehicleVarName format ["ARTEK_monitor_%1", _forEachIndex];
        _x setVariable ["operatorRenderTarget", format ["rendertarget%1", _rt_base + (_forEachIndex mod _slotCount)], true];
        diag_log format ["[QG_ArTeK_Camera_Feeds] monitor %1 render target %2", _forEachIndex, _rt_base + (_forEachIndex mod _slotCount)];
    } forEach synchronizedObjects this;
    missionNamespace setVariable ["ARTEK_OperatorCam_SyncConfig", _ARTEK_OperatorCam_SyncConfig, true];
};

if (isNil "ARTEK_OperatorCam_Index") then { ARTEK_OperatorCam_Index = 0; };
if (isNil "ARTEK_OperatorCam_Initialized") then { ARTEK_OperatorCam_Initialized = false; };
if (isNil "ARTEK_activeMonitors") then { ARTEK_activeMonitors = []; };

ARTEK_fnc_objectSide = {
    params ["_obj"];
    if (isNull _obj) exitWith { civilian };
    if (_obj isKindOf "CAManBase") exitWith { side (group _obj) };
    private _s = side _obj;
    private _c = crew _obj;
    if (count _c > 0) then {
        private _u = effectiveCommander _obj;
        if (isNull _u) then { _u = _c select 0; };
        _s = side (group _u);
    };
    _s
};

ARTEK_fnc_sideKey = {
    params ["_side"];
    private _k = "";
    switch (_side) do {
        case west: { _k = "west"; };
        case east: { _k = "east"; };
        case independent: { _k = "guer"; };
        case civilian: { _k = "civ"; };
    };
    _k
};

ARTEK_fnc_sideColor = {
    params ["_obj"];
    private _key = [[_obj] call ARTEK_fnc_objectSide] call ARTEK_fnc_sideKey;
    private _table = missionNamespace getVariable ["ARTEK_side_colors", []];
    private _i = _table findIf { (_x select 0) == _key };
    if (_i < 0) exitWith { missionNamespace getVariable ["ARTEK_ui_color_list", [0, 0.42, 1, 1]] };
    (_table select _i) select 1
};

ARTEK_fnc_sideAllowed = {
    params ["_obj", "_caller"];
    (call ARTEK_fnc_getAllowedSides) params ["_blufor", "_opfor", "_independent", "_civilian"];
    private _s = [_obj] call ARTEK_fnc_objectSide;
    (_s == ([_caller] call ARTEK_fnc_objectSide)) ||
    (_s == blufor && _blufor) ||
    (_s == opfor && _opfor) ||
    (_s == independent && _independent) ||
    (_s == civilian && _civilian)
};

ARTEK_fnc_getAllowedSides = {
    private _blufor = false;
    private _opfor = false;
    private _independent = false;
    private _civilian = false;
    {
        switch (true) do {
            case (_x#0 == "blufor" && _x#1 == true): { _blufor = true; };
            case (_x#0 == "opfor" && _x#1 == true): { _opfor = true; };
            case (_x#0 == "independent" && _x#1 == true): { _independent = true; };
            case (_x#0 == "civilian" && _x#1 == true): { _civilian = true; };
        };
    } forEach (missionNamespace getVariable ["ARTEK_allowed_sides", [["blufor", false], ["opfor", false], ["independent", false], ["civilian", false]]]);
    [_blufor, _opfor, _independent, _civilian]
};

ARTEK_fnc_unitWhoOk = {
    params ["_unit", "_rule"];
    switch (_rule) do {
        case "player": { isPlayer _unit };
        case "ai": { !(isPlayer _unit) };
        default { true };
    }
};

ARTEK_fnc_getOperatorsWithCamera = {
    params ["_caller"];
    private _cells = missionNamespace getVariable ["ARTEK_operator_rules", []];

    allUnits select {
        private _u = _x;
        private _rule = [_cells, [_u] call ARTEK_fnc_objectSide] call ARTEK_fnc_ruleForSide;
        ([_u, _caller] call ARTEK_fnc_sideAllowed) &&
        alive _u &&
        !isNull _u &&
        (_rule != "hide") &&
        ([_u, _rule] call ARTEK_fnc_unitWhoOk) &&
        ([_u, ["ItemcTabHCam"]] call cTab_fnc_checkGear || "ItemcTabHCam" in (items _u))
    }
};

ARTEK_fnc_vehicleType = {
    params ["_veh"];
    private _t = "other";
    switch (true) do {
        case (unitIsUAV _veh): { _t = "drone"; };
        case (_veh isKindOf "Plane"): { _t = "plane"; };
        case (_veh isKindOf "Helicopter"): { _t = "heli"; };
        case (_veh isKindOf "Ship"): { _t = "boat"; };
        case (_veh isKindOf "Tank"): { _t = "tank"; };
        case (_veh isKindOf "Car"): { _t = "car"; };
        case (_veh isKindOf "StaticWeapon"): { _t = "static"; };
        default { _t = "other"; };
    };
    _t
};

ARTEK_fnc_vehicleTypeLabel = {
    params ["_type"];
    switch (_type) do {
        case "drone": { "DRONE" };
        case "plane": { "PLANE" };
        case "heli": { "HELI" };
        case "boat": { "BOAT" };
        case "tank": { "TANK" };
        case "car": { "CAR" };
        case "static": { "STATIC" };
        default { "OTHER" };
    }
};

ARTEK_fnc_vehicleTurrets = {
    params ["_veh"];
    private _mode = missionNamespace getVariable ["ARTEK_turret_filter", "gunner"];
    private _turrets = allTurrets [_veh, _mode == "all"];
    if (_mode == "gunner") then {
        _turrets = _turrets select {
            private _tc = [_veh, _x] call BIS_fnc_turretConfig;
            private _copilot = (getNumber (_tc >> "isCopilot")) == 1;
            !_copilot && {(count (_veh weaponsTurret _x)) > 0 || {unitIsUAV _veh}}
        };
    };
    if (missionNamespace getVariable ["ARTEK_list_driver_seat", true]) then {
        private _driverOk = true;
        if (_mode == "gunner") then {
            _driverOk = (count (_veh weaponsTurret [-1])) > 0 || {unitIsUAV _veh};
        };
        if (_driverOk) then { _turrets = [[-1]] + _turrets; };
    };
    _turrets
};

ARTEK_fnc_ruleForSide = {
    params ["_cells", "_side"];
    private _sides = missionNamespace getVariable ["ARTEK_rule_sides", ["west", "east", "guer", "civ"]];
    private _si = _sides find ([_side] call ARTEK_fnc_sideKey);
    if (_si < 0 || {_si >= count _cells}) exitWith { "hide" };
    _cells select _si
};

ARTEK_fnc_vehicleRuleForSide = {
    params ["_type", "_side"];
    private _rules = missionNamespace getVariable ["ARTEK_veh_rules", []];
    private _ri = _rules findIf { (_x select 0) == _type };
    if (_ri < 0) exitWith { "hide" };
    [(_rules select _ri) select 1, _side] call ARTEK_fnc_ruleForSide
};

ARTEK_fnc_crewRuleOk = {
    params ["_veh", "_type", "_rule"];
    if (_rule == "free") exitWith { true };
    private _units = [];
    if (_type == "drone") then {
        private _ctrl = UAVControl _veh;
        if (count _ctrl > 0 && {!isNull (_ctrl select 0)}) then { _units pushBack (_ctrl select 0); };
        { _units pushBackUnique _x; } forEach (crew _veh);
    } else {
        _units = crew _veh;
    };
    private _ok = false;
    switch (_rule) do {
        case "player": { _ok = (_units findIf { isPlayer _x }) > -1; };
        case "ai": { _ok = (_units findIf { !isPlayer _x }) > -1; };
        default { _ok = (count _units) > 0; };
    };
    _ok
};

ARTEK_fnc_getVehiclesWithTurrets = {
    params ["_caller"];
    vehicles select {
        private _veh = _x;
        private _type = [_veh] call ARTEK_fnc_vehicleType;
        private _rule = [_type, [_veh] call ARTEK_fnc_objectSide] call ARTEK_fnc_vehicleRuleForSide;
        ([_veh, _caller] call ARTEK_fnc_sideAllowed) &&
        alive _veh &&
        !isNull _veh &&
        (_rule != "hide") &&
        ([_veh, _type, _rule] call ARTEK_fnc_crewRuleOk) &&
        (count ([_veh] call ARTEK_fnc_vehicleTurrets) > 0)
    }
};

ARTEK_fnc_isSpotterOptic = {
    params ["_weapon"];
    if (_weapon == "") exitWith { false };
    private _ok = _weapon in (missionNamespace getVariable ["ARTEK_spotter_optics", []]);
    if (!_ok && {missionNamespace getVariable ["ARTEK_spotter_any_binocular", true]}) then {
        _ok = (getNumber (configFile >> "CfgWeapons" >> _weapon >> "type")) == 4096;
    };
    _ok
};

ARTEK_fnc_getSpottersWithOptics = {
    params ["_caller"];
    private _cells = missionNamespace getVariable ["ARTEK_spotter_rules", []];

    allUnits select {
        private _u = _x;
        private _rule = [_cells, [_u] call ARTEK_fnc_objectSide] call ARTEK_fnc_ruleForSide;
        ([_u, _caller] call ARTEK_fnc_sideAllowed) &&
        alive _u &&
        !isNull _u &&
        (_rule != "hide") &&
        ([_u, _rule] call ARTEK_fnc_unitWhoOk) &&
        {[currentWeapon _u] call ARTEK_fnc_isSpotterOptic}
    }
};

ARTEK_fnc_getTurretCamPoints = {
    params ["_vehicle", "_turretPath"];
    private _config = configFile >> "CfgVehicles" >> typeOf _vehicle;
    private _posPoint = getText (_config >> "uavCameraGunnerPos");
    private _dirPoint = getText (_config >> "uavCameraGunnerDir");

    if (_posPoint == "" && {_turretPath isEqualTo [-1]}) then {
        {
            if (_x != "" && {!((_vehicle selectionPosition _x) isEqualTo [0,0,0])}) exitWith { _posPoint = _x; };
        } forEach [getText (_config >> "memoryPointDriverOptics"), "pilotview", "driverview", "commanderview"];
    };
    if (_posPoint == "" && {_turretPath isEqualType []} && {count _turretPath > 0} && {!(_turretPath isEqualTo [-1])}) then {
        private _turretConfig = [_vehicle, _turretPath] call BIS_fnc_turretConfig;
        if (isClass _turretConfig) then {
            private _optics = getText (_turretConfig >> "memoryPointGunnerOptics");
            if (_optics != "" && {!((_vehicle selectionPosition _optics) isEqualTo [0,0,0])}) then {
                _posPoint = _optics;
            };
        };
    };

    if (_posPoint == "") then {
        {
            private _testPos = _vehicle selectionPosition _x;
            if (!(_testPos isEqualTo [0,0,0])) exitWith {_posPoint = _x;};
        } forEach ["PiP0_pos", "PiP1_pos", "pip0_pos", "pip1_pos"];
    };
    if (_dirPoint == "") then {
        {
            private _testDir = _vehicle selectionPosition _x;
            if (!(_testDir isEqualTo [0,0,0])) exitWith {_dirPoint = _x;};
        } forEach ["PiP0_dir", "PiP1_dir", "pip0_dir", "pip1_dir"];
    };
    [_posPoint, _dirPoint]
};

ARTEK_fnc_potSize = {
    params ["_v"];
    private _p = 128;
    while { _p < _v && {_p < 2048} } do { _p = _p * 2; };
    _p
};

ARTEK_fnc_feedTexture = {
    params ["_renderTarget"];
    private _w = [missionNamespace getVariable ["ARTEK_rt_width", 2048]] call ARTEK_fnc_potSize;
    private _h = [missionNamespace getVariable ["ARTEK_rt_height", 2048]] call ARTEK_fnc_potSize;
    private _a = missionNamespace getVariable ["ARTEK_rt_aspect", 1.777];
    private _tex = format ["#(argb,%1,%2,1)r2t(%3,%4)", _w, _h, _renderTarget, _a];
    private _sig = format ["%1x%2@%3", _w, _h, _a];
    if (!((missionNamespace getVariable ["ARTEK_lastTexSig", ""]) isEqualTo _sig)) then {
        missionNamespace setVariable ["ARTEK_lastTexSig", _sig];
        diag_log format ["[QG_ArTeK_Camera_Feeds] render target %1 | PiP abilitato %2", _tex, isPipEnabled];
    };
    _tex
};

ARTEK_fnc_makeFeedCam = {
    params ["_renderTarget"];
    private _cam = "camera" camCreate [0,0,0];
    _cam cameraEffect ["Internal", "Back", _renderTarget];
    if (missionNamespace getVariable ["ARTEK_disable_dof", true]) then {
        _cam camSetFocus [-1, -1];
    };
    _cam camCommit 0;
    _cam
};

ARTEK_fnc_applyVision = {
    params ["_monitor"];
    if (isNull _monitor) exitWith {};
    private _rt = _monitor getVariable ["operatorRenderTarget", "rendertarget0"];
    private _modes = missionNamespace getVariable ["ARTEK_vision_modes", [["Normal", [0]]]];
    private _i = _monitor getVariable ["visionMode", 0];
    if (_i < 0 || {_i >= count _modes}) then { _i = 0; };
    _rt setPiPEffect ((_modes select _i) select 1);
};

ARTEK_fnc_syncVisionMode = {
    params ["_monitorNetId", "_index"];
    private _monitor = objectFromNetId _monitorNetId;
    if (isNull _monitor) exitWith {};
    _monitor setVariable ["visionMode", _index, false];
    [_monitor] call ARTEK_fnc_applyVision;
};

ARTEK_fnc_changeVisionMode = {
    params ["_monitor"];
    if (isNull _monitor) exitWith {};
    private _modes = missionNamespace getVariable ["ARTEK_vision_modes", [["Normal", [0]]]];
    if (count _modes == 0) exitWith {};
    private _new = ((_monitor getVariable ["visionMode", 0]) + 1) mod (count _modes);
    [[netId _monitor, _new], "ARTEK_fnc_syncVisionMode", true, false] call BIS_fnc_MP;
    hintSilent format ["Vision: %1", (_modes select _new) select 0];
};

ARTEK_fnc_zoomFactor = {
    params ["_monitor"];
    private _steps = missionNamespace getVariable ["ARTEK_turret_zoom_steps", [0.25, 0.05, 0.0167]];
    if (count _steps == 0) exitWith { 1 };
    private _i = _monitor getVariable ["zoomIndex", 0];
    if (_i < 0 || {_i >= count _steps}) then { _i = 0; };
    private _first = _steps select 0;
    if (_first <= 0) exitWith { 1 };
    (_steps select _i) / _first
};

ARTEK_fnc_applyZoom = {
    params ["_monitor"];
    if (isNull _monitor) exitWith {};
    if (_monitor getVariable ["fovMirrored", false]) exitWith {};
    private _cam = _monitor getVariable ["vehicleCam", objNull];
    if (isNull _cam) exitWith {};
    private _steps = missionNamespace getVariable ["ARTEK_turret_zoom_steps", [0.25, 0.05, 0.0167]];
    if (count _steps == 0) exitWith {};
    private _i = _monitor getVariable ["zoomIndex", 0];
    if (_i < 0 || {_i >= count _steps}) then { _i = 0; };
    _cam camSetFov (_steps select _i);
    _cam camCommit 0;
};

ARTEK_fnc_syncZoom = {
    params ["_monitorNetId", "_index"];
    private _monitor = objectFromNetId _monitorNetId;
    if (isNull _monitor) exitWith {};
    _monitor setVariable ["zoomIndex", _index, false];
    [_monitor] call ARTEK_fnc_applyZoom;
};

ARTEK_fnc_changeZoom = {
    params ["_monitor", "_dir"];
    if (isNull _monitor) exitWith {};
    private _steps = missionNamespace getVariable ["ARTEK_turret_zoom_steps", [0.25, 0.05, 0.0167]];
    private _names = missionNamespace getVariable ["ARTEK_turret_zoom_names", ["Wide", "Medium", "Narrow"]];
    if (count _steps == 0) exitWith {};
    private _cur = _monitor getVariable ["zoomIndex", 0];
    private _new = ((_cur + _dir) max 0) min ((count _steps) - 1);
    if (_new == _cur) exitWith {};
    [[netId _monitor, _new], "ARTEK_fnc_syncZoom", true, false] call BIS_fnc_MP;
    private _label = if (_new < count _names) then { _names select _new } else { str (_steps select _new) };
    hintSilent format ["Zoom: %1", _label];
};

ARTEK_fnc_zoomAtLimit = {
    params ["_monitor", "_dir"];
    private _steps = missionNamespace getVariable ["ARTEK_turret_zoom_steps", [0.25, 0.05, 0.0167]];
    private _cur = _monitor getVariable ["zoomIndex", 0];
    private _new = ((_cur + _dir) max 0) min ((count _steps) - 1);
    _new == _cur
};

ARTEK_fnc_fovKey = {
    params ["_turretPath"];
    format ["ARTEK_fov_%1", _turretPath]
};

ARTEK_fnc_measureFov = {
    private _f = 0;
    private _src = "none";
    if (!isNil "CBA_fnc_getFov") then {
        private _r = call CBA_fnc_getFov;
        if (_r isEqualType []) then {
            _r = if (count _r > 0) then { _r select 0 } else { 0 };
        };
        if (_r isEqualType 0 && {_r > 0.005} && {_r < 1.6}) then {
            _f = _r;
            _src = "cba";
        };
    };
    if (_f <= 0.001) then {
        private _g = getObjectFOV player;
        if (_g isEqualType []) then {
            _g = if (count _g > 0) then { _g select 0 } else { 0 };
        };
        if (_g isEqualType 0 && {_g > 0.005} && {_g < 1.6}) then {
            _f = _g;
            _src = "obj";
        };
    };
    [_f, _src]
};

ARTEK_fnc_uavGunnerPath = {
    params ["_veh"];
    private _turrets = allTurrets [_veh, false];
    private _out = [];
    {
        private _tc = [_veh, _x] call BIS_fnc_turretConfig;
        if ((getNumber (_tc >> "isCopilot")) != 1) exitWith { _out = _x; };
    } forEach _turrets;
    if (_out isEqualTo [] && {count _turrets > 0}) then { _out = _turrets select 0; };
    _out
};

ARTEK_fnc_playerTurretPath = {
    params ["_veh"];
    private _role = assignedVehicleRole player;
    if (count _role > 1 && {(_role select 0) == "Turret"}) exitWith { _role select 1 };
    if ((driver _veh) == player) exitWith { [-1] };
    private _out = [];
    {
        if ((_veh turretUnit _x) == player) exitWith { _out = _x; };
    } forEach (allTurrets [_veh, true]);
    _out
};

ARTEK_fnc_fovTick = {
    private _now = diag_tickTime;
    if (_now < (missionNamespace getVariable ["ARTEK_fov_nextTick", 0])) exitWith {};
    missionNamespace setVariable ["ARTEK_fov_nextTick", _now + (missionNamespace getVariable ["ARTEK_operator_fov_interval", 0.15])];
    if (isNull player) exitWith {};

    private _debug = missionNamespace getVariable ["ARTEK_operator_fov_debug", false];

    if (isNil "ARTEK_fov_hello") then {
        ARTEK_fov_hello = true;
        diag_log format ["[QG_ArTeK_Camera_Feeds] publisher FOV attivo, versione %1", ARTEK_OperatorCam_Version];
        if (_debug) then { systemChat format ["[ArTeK] Camera Feeds %1 attivo", ARTEK_OperatorCam_Version]; };
    };

    private _veh = objNull;
    private _path = [];
    private _how = "";

    private _c = cameraOn;
    if (!isNull _c && {_c != player} && {!(_c isKindOf "CAManBase")} && {_c isKindOf "AllVehicles"}) then {
        _veh = _c;
        private _uav = getConnectedUAV player;
        if (!isNull _uav && {_uav isEqualTo _veh}) then {
            private _ctrl = UAVControl _uav;
            _path = if (count _ctrl > 1 && {(_ctrl select 1) == "DRIVER"}) then { [-1] } else { [_uav] call ARTEK_fnc_uavGunnerPath };
            _how = "terminale";
        } else {
            _path = [_veh] call ARTEK_fnc_playerTurretPath;
            _how = "posto";
        };
        if (_path isEqualTo []) then { _path = [_veh] call ARTEK_fnc_uavGunnerPath; };
    };

    private _lastVeh = missionNamespace getVariable ["ARTEK_fov_lastVeh", objNull];
    private _lastKey = missionNamespace getVariable ["ARTEK_fov_lastKey", ""];
    private _lastVal = missionNamespace getVariable ["ARTEK_fov_lastVal", -1];

    if (isNull _veh) then {
        if (_debug && {_lastKey != ""}) then { systemChat "[ArTeK] operatore: nessuna postazione"; };
        missionNamespace setVariable ["ARTEK_fov_lastVeh", objNull];
        missionNamespace setVariable ["ARTEK_fov_lastKey", ""];
        missionNamespace setVariable ["ARTEK_fov_lastVal", -1];
    } else {
        private _key = [_path] call ARTEK_fnc_fovKey;
        private _fresh = (!(_lastVeh isEqualTo _veh)) || {_key != _lastKey};
        if (_fresh) then { _lastVal = -1; };
        (call ARTEK_fnc_measureFov) params ["_fov", "_src"];
        if (_fov > 0.001 && {abs (_fov - _lastVal) > (missionNamespace getVariable ["ARTEK_operator_fov_step", 0.004])}) then {
            _veh setVariable [_key, _fov, true];
            _veh setVariable ["ARTEK_fov_last", _fov, true];
            _lastVal = _fov;
            if (_debug) then {
                systemChat format ["[ArTeK] %1 %2 %3 FOV %4 [%5]", typeOf _veh, _how, _key, (_fov toFixed 4), _src];
            };
        } else {
            if (_debug && {_fresh}) then {
                systemChat format ["[ArTeK] %1 %2 %3 misura %4 [%5]", typeOf _veh, _how, _key, (_fov toFixed 4), _src];
            };
        };
        missionNamespace setVariable ["ARTEK_fov_lastVeh", _veh];
        missionNamespace setVariable ["ARTEK_fov_lastKey", _key];
        missionNamespace setVariable ["ARTEK_fov_lastVal", _lastVal];
    };
};

ARTEK_fnc_followOperatorFov = {
    params ["_monitor", "_cam", "_vehicle"];
    if (isNull _cam || {isNull _vehicle} || {isNull _monitor}) exitWith {};
    if (!(_monitor getVariable ["operatorFeedActive", false])) exitWith {};
    if (!(missionNamespace getVariable ["ARTEK_follow_operator_zoom", true])) exitWith {};

    private _base = _vehicle getVariable [[_monitor getVariable ["turretPath", []]] call ARTEK_fnc_fovKey, -1];
    if (!(_base isEqualType 0) || {_base <= 0.001}) then {
        _base = _vehicle getVariable ["ARTEK_fov_last", -1];
    };
    if (!(_base isEqualType 0)) then { _base = -1; };

    if (_base > 0.001) then {
        private _fov = _base * ([_monitor] call ARTEK_fnc_zoomFactor) * (missionNamespace getVariable ["ARTEK_operator_fov_scale", 1]);
        if (_fov < 0.005) then { _fov = 0.005; };
        if (_fov > 1.5) then { _fov = 1.5; };
        _monitor setVariable ["fovMirrored", true, false];
        if (abs (_fov - (_monitor getVariable ["fovApplied", -1])) > 0.0005) then {
            _monitor setVariable ["fovApplied", _fov, false];
            _cam camSetFov _fov;
            _cam camCommit 0;
        };
    } else {
        if (_monitor getVariable ["fovMirrored", false]) then {
            _monitor setVariable ["fovMirrored", false, false];
            _monitor setVariable ["fovApplied", -1, false];
            [_monitor] call ARTEK_fnc_applyZoom;
        };
    };
};

ARTEK_fnc_upFromDir = {
    params ["_dir"];
    _dir params ["_dx", "_dy", "_dz"];
    private _up = [0,0,1];
    if ((abs _dx) + (abs _dy) < 0.002) then {
        _up = if (_dz < 0) then { [0,1,0] } else { [0,-1,0] };
    } else {
        _up = vectorNormalized (_dir vectorCrossProduct [-_dy, _dx, 0]);
    };
    _up
};

ARTEK_fnc_getTurretDirModel = {
    params ["_vehicle", "_monitor"];
    private _dir = [0,0,0];

    private _posPoint = _monitor getVariable ["camPosPoint", ""];
    private _dirPoint = _monitor getVariable ["camDirPoint", ""];
    if (_posPoint != "" && {_dirPoint != ""}) then {
        private _start = _vehicle selectionPosition _posPoint;
        private _end   = _vehicle selectionPosition _dirPoint;
        if (!(_start isEqualTo [0,0,0]) && {!(_end isEqualTo [0,0,0])}) then {
            _dir = vectorNormalized (_start vectorFromTo _end);
        };
    };

    if (_dir isEqualTo [0,0,0]) then {
        private _turretPath = _monitor getVariable ["turretPath", []];
        private _wpn = "";
        if (_turretPath isEqualType [] && {count _turretPath > 0}) then {
            _wpn = _vehicle currentWeaponTurret _turretPath;
        };
        if (_wpn == "") then { _wpn = currentWeapon _vehicle; };
        if (_wpn != "") then {
            _dir = vectorNormalized (_vehicle vectorWorldToModel (_vehicle weaponDirection _wpn));
        };
    };

    if (_dir isEqualTo [0,0,0]) then { _dir = [0,1,0]; };
    _dir
};

ARTEK_fnc_updateOperatorFeed = {
    params ["_monitor"];
    private _cam = _monitor getVariable ["operatorCam", objNull];
    if (isNull _cam) exitWith { [_monitor] call ARTEK_fnc_stopOperatorFeed; };

    private _operator = _monitor getVariable ["connectedOperator", objNull];
    if (isNull _operator || {!alive _operator} ||
        {!([_operator, ["ItemcTabHCam"]] call cTab_fnc_checkGear || "ItemcTabHCam" in (items _operator))}) exitWith {
        [_monitor] call ARTEK_fnc_stopOperatorFeed;
    };

    private _offset = missionNamespace getVariable ["ARTEK_helmet_cam_offset", [0.2, 0, 0.175]];
    private _pitch  = missionNamespace getVariable ["ARTEK_helmet_cam_pitch", 0];
    private _yaw    = missionNamespace getVariable ["ARTEK_helmet_cam_yaw", 0];
    private _roll   = missionNamespace getVariable ["ARTEK_helmet_cam_roll", 0];
    private _fov    = missionNamespace getVariable ["ARTEK_helmet_cam_fov", 0.87];

    private _headPos = _operator selectionPosition "head";
    private _modelPos = _operator modelToWorldVisual _headPos;
    private _dirVec = vectorDir _operator;
    private _upVec = vectorUp _operator;
    private _rightVec = _dirVec vectorCrossProduct _upVec;
    private _offsetVec = (_rightVec vectorMultiply (_offset select 0)) vectorAdd (_dirVec vectorMultiply (_offset select 1)) vectorAdd (_upVec vectorMultiply (_offset select 2));
    private _camPos = _modelPos vectorAdd _offsetVec;
    _cam setPosASL (AGLToASL _camPos);

    private _modelDir = vectorDir _operator;
    private _modelDirYaw = (_modelDir select 0) atan2 (_modelDir select 1);
    private _finalYaw = _modelDirYaw + _yaw;
    private _pitchRad = _pitch * (pi / 180);
    private _dirX = sin(_finalYaw) * cos(_pitchRad);
    private _dirY = cos(_finalYaw) * cos(_pitchRad);
    private _dirZ = sin(_pitchRad);
    private _finalDir = [_dirX, _dirY, _dirZ];
    private _rollRad = _roll * (pi / 180);
    private _camUpVec = [-sin(_finalYaw) * sin(_rollRad), -cos(_finalYaw) * sin(_rollRad), cos(_rollRad)];
    _cam setVectorDirAndUp [_finalDir, _camUpVec];
    _cam camSetFov _fov;
    _cam camCommit 0;
};

ARTEK_fnc_updateVehicleFeed = {
    params ["_monitor"];
    private _cam = _monitor getVariable ["vehicleCam", objNull];
    if (isNull _cam) exitWith { [_monitor] call ARTEK_fnc_stopOperatorFeed; };

    private _vehicle = _monitor getVariable ["connectedVehicle", objNull];
    if (isNull _vehicle || {!alive _vehicle}) exitWith { [_monitor] call ARTEK_fnc_stopOperatorFeed; };

    if ((_monitor getVariable ["camMode", "point"]) == "unit") then {
        private _unit = _vehicle turretUnit (_monitor getVariable ["turretPath", []]);
        if (isNull _unit || {!alive _unit}) then {
            [_monitor] call ARTEK_fnc_stopOperatorFeed;
        } else {
            private _dir = eyeDirection _unit;
            _cam setPosASL (eyePos _unit);
            _cam setVectorDirAndUp [_dir, [_dir] call ARTEK_fnc_upFromDir];
            _cam camCommit 0;
        };
    } else {
        private _dirModel = [_vehicle, _monitor] call ARTEK_fnc_getTurretDirModel;
        _cam setVectorDirAndUp [_dirModel, [_dirModel] call ARTEK_fnc_upFromDir];
    };

    [_monitor, _monitor getVariable ["vehicleCam", objNull], _vehicle] call ARTEK_fnc_followOperatorFov;
};

ARTEK_fnc_updateSpotterFeed = {
    params ["_monitor"];
    private _cam = _monitor getVariable ["spotterCam", objNull];
    if (isNull _cam) exitWith { [_monitor] call ARTEK_fnc_stopOperatorFeed; };

    private _spotter = _monitor getVariable ["connectedSpotter", objNull];
    private _weapon = currentWeapon _spotter;
    if (isNull _spotter || {!alive _spotter} || {!([_weapon] call ARTEK_fnc_isSpotterOptic)}) exitWith {
        [_monitor] call ARTEK_fnc_stopOperatorFeed;
    };

    private _camDir = eyeDirection _spotter;
    if (_camDir isEqualTo [0,0,0]) then { _camDir = vectorDir _spotter; };
    _camDir = vectorNormalized _camDir;

    private _live = getObjectFOV _spotter;
    if (_live isEqualType []) then {
        _live = if (count _live > 0) then { _live select 0 } else { 0 };
    };
    if (!(_live isEqualType 0)) then { _live = 0; };

    private _fov = 0.75;
    private _src = "config";
    if (_spotter == player) then {
        if (_live > 0.001) then {
            _fov = _live;
            _src = "live";
        };
    } else {
        if (_live > 0.001 && {_live < 0.7}) then {
            _fov = _live;
            _src = "live";
        };
    };
    if (_src == "config") then {
        private _cfg = configFile >> "CfgWeapons" >> _weapon;
        if (isClass _cfg) then {
            private _z = getNumber (_cfg >> "opticsZoomInit");
            if (_z <= 0) then { _z = getNumber (_cfg >> "opticsZoomMin"); };
            if (_z > 0) then { _fov = (_z max 0.001) min 0.75; };
        };
    };

    if (missionNamespace getVariable ["ARTEK_spotter_fov_debug", false]) then {
        private _last = _monitor getVariable ["dbgFov", -1];
        if (abs (_fov - _last) > 0.005) then {
            _monitor setVariable ["dbgFov", _fov, false];
            diag_log format ["[QG_ArTeK_Camera_Feeds] spotter %1 arma %2 getObjectFOV %3 usato %4 (%5)", name _spotter, _weapon, _live, _fov, _src];
        };
    };

    private _camPos = (eyePos _spotter) vectorAdd (_camDir vectorMultiply (missionNamespace getVariable ["ARTEK_spotter_cam_forward", 0.35]));
    _cam setPosASL _camPos;
    _cam setVectorDirAndUp [_camDir, [_camDir] call ARTEK_fnc_upFromDir];
    _cam camSetFov _fov;
    _cam camCommit 0;
};

ARTEK_fnc_updateAllFeeds = {
    if (ARTEK_activeMonitors isEqualTo []) exitWith {};

    {
        private _monitor = _x;
        if (isNull _monitor) then {
            ARTEK_activeMonitors = ARTEK_activeMonitors - [_monitor];
        } else {
            if (!(_monitor getVariable ["operatorFeedActive", false])) then {
                [_monitor] call ARTEK_fnc_unregisterFeed;
            } else {
                switch (_monitor getVariable ["feedType", "none"]) do {
                    case "operator": { [_monitor] call ARTEK_fnc_updateOperatorFeed; };
                    case "vehicle":  { [_monitor] call ARTEK_fnc_updateVehicleFeed; };
                    case "spotter":  { [_monitor] call ARTEK_fnc_updateSpotterFeed; };
                    default { [_monitor] call ARTEK_fnc_unregisterFeed; };
                };
            };
        };
    } forEach (+ARTEK_activeMonitors);
};

ARTEK_fnc_registerFeed = {
    params ["_monitor"];
    if (isNil "ARTEK_activeMonitors") then { ARTEK_activeMonitors = []; };
    if (!(_monitor in ARTEK_activeMonitors)) then { ARTEK_activeMonitors pushBack _monitor; };
    if (isNil "ARTEK_frameHandler") then {
        ARTEK_frameHandler = addMissionEventHandler ["EachFrame", { call ARTEK_fnc_updateAllFeeds }];
    };
};

ARTEK_fnc_unregisterFeed = {
    params ["_monitor"];
    if (isNil "ARTEK_activeMonitors") exitWith {};
    ARTEK_activeMonitors = ARTEK_activeMonitors - [_monitor];
};

ARTEK_fnc_startOperatorFeed = {
    params ["_monitor", "_operator"];
    private _textureIndex = [_monitor] call ARTEK_fnc_getOperatorTextureIndex;
    private _renderTarget = _monitor getVariable ["operatorRenderTarget", "rendertarget0"];

    _monitor setObjectTextureGlobal [_textureIndex, [_renderTarget] call ARTEK_fnc_feedTexture];
    _monitor setVariable ["connectedOperator", _operator, true];
    _monitor setVariable ["operatorFeedActive", true, true];
    _monitor setVariable ["feedType", "operator", true];
    _monitor setVariable ["visionMode", 0, false];

    if (!hasInterface) exitWith {};

    private _cam = [_renderTarget] call ARTEK_fnc_makeFeedCam;
    _monitor setVariable ["operatorCam", _cam, false];
    [_monitor] call ARTEK_fnc_applyVision;
    [_monitor] call ARTEK_fnc_registerFeed;
    [_monitor] call ARTEK_fnc_updateOperatorFeed;
};

ARTEK_fnc_startVehicleFeed = {
    params ["_monitor", "_vehicle", "_turretPath"];
    private _textureIndex = [_monitor] call ARTEK_fnc_getOperatorTextureIndex;
    private _renderTarget = _monitor getVariable ["operatorRenderTarget", "rendertarget0"];

    _monitor setObjectTextureGlobal [_textureIndex, [_renderTarget] call ARTEK_fnc_feedTexture];
    _monitor setVariable ["connectedVehicle", _vehicle, true];
    _monitor setVariable ["turretPath", _turretPath, true];
    _monitor setVariable ["operatorFeedActive", true, true];
    _monitor setVariable ["feedType", "vehicle", true];
    _monitor setVariable ["visionMode", 0, false];
    _monitor setVariable ["zoomIndex", missionNamespace getVariable ["ARTEK_turret_zoom_default", 0], false];
    _monitor setVariable ["fovMirrored", false, false];
    _monitor setVariable ["fovApplied", -1, false];

    private _cameraPoints = [_vehicle, _turretPath] call ARTEK_fnc_getTurretCamPoints;
    private _posPoint = _cameraPoints select 0;
    private _camMode = "point";
    if (_posPoint == "" && {!isNull (_vehicle turretUnit _turretPath)}) then { _camMode = "unit"; };
    _monitor setVariable ["camPosPoint", _posPoint, false];
    _monitor setVariable ["camDirPoint", _cameraPoints select 1, false];
    _monitor setVariable ["camMode", _camMode, false];

    if (!hasInterface) exitWith {};

    private _cam = [_renderTarget] call ARTEK_fnc_makeFeedCam;
    _monitor setVariable ["vehicleCam", _cam, false];

    if (_camMode == "point") then {
        if (_posPoint != "") then {
            _cam attachTo [_vehicle, [0,0,0], _posPoint];
        } else {
            _cam attachTo [_vehicle, [0, 0, 0]];
        };
    };

    [_monitor] call ARTEK_fnc_applyZoom;
    [_monitor] call ARTEK_fnc_applyVision;
    [_monitor] call ARTEK_fnc_registerFeed;
    [_monitor] call ARTEK_fnc_updateVehicleFeed;
};

ARTEK_fnc_startSpotterFeed = {
    params ["_monitor", "_spotter"];
    private _textureIndex = [_monitor] call ARTEK_fnc_getOperatorTextureIndex;
    private _renderTarget = _monitor getVariable ["operatorRenderTarget", "rendertarget0"];

    _monitor setObjectTextureGlobal [_textureIndex, [_renderTarget] call ARTEK_fnc_feedTexture];
    _monitor setVariable ["connectedSpotter", _spotter, true];
    _monitor setVariable ["operatorFeedActive", true, true];
    _monitor setVariable ["feedType", "spotter", true];
    _monitor setVariable ["visionMode", 0, false];

    if (!hasInterface) exitWith {};

    private _cam = [_renderTarget] call ARTEK_fnc_makeFeedCam;
    _monitor setVariable ["spotterCam", _cam, false];
    [_monitor] call ARTEK_fnc_applyVision;
    [_monitor] call ARTEK_fnc_registerFeed;
    [_monitor] call ARTEK_fnc_updateSpotterFeed;
};

ARTEK_fnc_stopOperatorFeed = {
    params ["_monitor"];
    if (isNull _monitor) exitWith {};
    _monitor setVariable ["operatorFeedActive", false, true];
    [_monitor] call ARTEK_fnc_unregisterFeed;

    {
        private _cam = _monitor getVariable [_x, objNull];
        if (!isNull _cam) then {
            _cam cameraEffect ["terminate", "back"];
            camDestroy _cam;
            _monitor setVariable [_x, objNull, false];
        };
    } forEach ["operatorCam", "vehicleCam", "spotterCam"];

    private _rt = _monitor getVariable ["operatorRenderTarget", "rendertarget0"];
    _rt setPiPEffect [0];

    private _textureIndex = [_monitor] call ARTEK_fnc_getOperatorTextureIndex;
    _monitor setObjectTextureGlobal [_textureIndex, "a3\data_f\black_sum.paa"];
    _monitor setVariable ["connectedOperator", objNull, true];
    _monitor setVariable ["connectedVehicle", objNull, true];
    _monitor setVariable ["connectedSpotter", objNull, true];
    _monitor setVariable ["feedType", "none", true];
    _monitor setVariable ["visionMode", 0, false];
    _monitor setVariable ["zoomIndex", missionNamespace getVariable ["ARTEK_turret_zoom_default", 0], false];
    _monitor setVariable ["fovMirrored", false, false];
    _monitor setVariable ["fovApplied", -1, false];
};

ARTEK_fnc_startFeedRemote = {
    params ["_monitor", "_type", "_source", "_turretPath"];
    switch (_type) do {
        case "operator": {
            [[netId _monitor, netId _source, true], "ARTEK_fnc_syncOperatorMonitorState", true, false] call BIS_fnc_MP;
        };
        case "spotter": {
            [[netId _monitor, netId _source, true], "ARTEK_fnc_syncSpotterMonitorState", true, false] call BIS_fnc_MP;
        };
        case "vehicle": {
            [[netId _monitor, netId _source, _turretPath, true], "ARTEK_fnc_syncVehicleMonitorState", true, false] call BIS_fnc_MP;
        };
    };
};

ARTEK_fnc_switchFeed = {
    params ["_monitor", "_type", "_source", ["_turretPath", []]];
    if (isNull _monitor || {isNull _source}) exitWith {};
    if (!(_monitor getVariable ["operatorFeedActive", false])) exitWith {
        [_monitor, _type, _source, _turretPath] call ARTEK_fnc_startFeedRemote;
    };
    [_monitor, _type, _source, _turretPath] spawn {
        params ["_monitor", "_type", "_source", "_turretPath"];
        [[netId _monitor], "ARTEK_fnc_disconnectSingleMonitor", true, false] call BIS_fnc_MP;
        sleep 0.1;
        [_monitor, _type, _source, _turretPath] call ARTEK_fnc_startFeedRemote;
    };
};

ARTEK_fnc_disconnectSingleMonitor = {
    params ["_monitorNetId"];
    private _monitor = objectFromNetId _monitorNetId;
    if (!isNull _monitor) then {
        [_monitor] call ARTEK_fnc_stopOperatorFeed;
    };
};

ARTEK_fnc_syncOperatorMonitorState = {
    params ["_monitorNetId", "_operatorNetId", "_start"];
    private _monitor = objectFromNetId _monitorNetId;
    private _operator = objectFromNetId _operatorNetId;
    if (isNull _monitor) exitWith {};
    if (_start) then {
        if (!isNull _operator) then {
            [_monitor, _operator] call ARTEK_fnc_startOperatorFeed;
        };
    } else {
        [_monitor] call ARTEK_fnc_stopOperatorFeed;
    };
};

ARTEK_fnc_syncVehicleMonitorState = {
    params ["_monitorNetId", "_vehicleNetId", "_turretPath", "_start"];
    private _monitor = objectFromNetId _monitorNetId;
    private _vehicle = objectFromNetId _vehicleNetId;
    if (isNull _monitor) exitWith {};
    if (_start) then {
        if (!isNull _vehicle) then {
            [_monitor, _vehicle, _turretPath] call ARTEK_fnc_startVehicleFeed;
        };
    } else {
        [_monitor] call ARTEK_fnc_stopOperatorFeed;
    };
};

ARTEK_fnc_syncSpotterMonitorState = {
    params ["_monitorNetId", "_spotterNetId", "_start"];
    private _monitor = objectFromNetId _monitorNetId;
    private _spotter = objectFromNetId _spotterNetId;
    if (isNull _monitor) exitWith {};
    if (_start) then {
        if (!isNull _spotter) then {
            [_monitor, _spotter] call ARTEK_fnc_startSpotterFeed;
        };
    } else {
        [_monitor] call ARTEK_fnc_stopOperatorFeed;
    };
};

ARTEK_fnc_buildOperatorList = {
    params ["_operators", "_caller"];
    private _operatorList = [];
    {
        private _group = "";
        private _number = "";
        private _dist = "";
        if (missionNamespace getVariable ["ARTEK_allow_groupID", false]) then {
            _group = groupId (group _x);
            _group = format ["[%1] ", _group];
        };
        if (missionNamespace getVariable ["ARTEK_allow_groupNumber", false]) then {
            _number = ((units (group _x)) find _x) + 1;
            _number = format ["[%1] ", _number];
        };
        if (missionNamespace getVariable ["ARTEK_allow_distance", false]) then {
            _dist = round (_caller distance _x);
            _dist = format [" (%1m)", _dist];
        };
        private _color = [_x] call ARTEK_fnc_sideColor;
        _operatorList pushBack [format["%1%2%3%4", _group, _number, name _x, _dist], _color, _x];
    } forEach _operators;
    _operatorList
};

ARTEK_fnc_buildSpotterList = {
    params ["_spotters", "_caller"];
    private _spotterList = [];
    {
        private _group = "";
        private _number = "";
        private _dist = "";
        if (missionNamespace getVariable ["ARTEK_allow_groupID", false]) then {
            _group = groupId (group _x);
            _group = format ["[%1] ", _group];
        };
        if (missionNamespace getVariable ["ARTEK_allow_groupNumber", false]) then {
            _number = ((units (group _x)) find _x) + 1;
            _number = format ["[%1] ", _number];
        };
        if (missionNamespace getVariable ["ARTEK_allow_distance", false]) then {
            _dist = round (_caller distance _x);
            _dist = format [" (%1m)", _dist];
        };
        private _opticName = getText (configFile >> "CfgWeapons" >> (currentWeapon _x) >> "displayName");
        private _color = [_x] call ARTEK_fnc_sideColor;
        _spotterList pushBack [format["%1%2%3 [%4]%5", _group, _number, name _x, _opticName, _dist], _color, _x];
    } forEach _spotters;
    _spotterList
};

ARTEK_fnc_activeSides = {
    params ["_caller"];
    (call ARTEK_fnc_getAllowedSides) params ["_blufor", "_opfor", "_independent", "_civilian"];
    private _mine = [_caller] call ARTEK_fnc_objectSide;
    private _colors = missionNamespace getVariable ["ARTEK_side_colors", []];
    private _out = [];
    {
        _x params ["_sd", "_key", "_on", "_label"];
        if (_on || {_sd == _mine}) then {
            private _i = _colors findIf { (_x select 0) == _key };
            private _col = if (_i < 0) then { [0.8,0.8,0.8,1] } else { (_colors select _i) select 1 };
            _out pushBack [_sd, _label, _col];
        };
    } forEach [
        [west, "west", _blufor, missionNamespace getVariable ["ARTEK_string_side_west", "BLUFOR"]],
        [east, "east", _opfor, missionNamespace getVariable ["ARTEK_string_side_east", "OPFOR"]],
        [independent, "guer", _independent, missionNamespace getVariable ["ARTEK_string_side_guer", "INDIP"]],
        [civilian, "civ", _civilian, missionNamespace getVariable ["ARTEK_string_side_civ", "CIVILI"]]
    ];
    _out
};

ARTEK_fnc_turretSeatName = {
    params ["_veh", "_turretPath"];
    if (_turretPath isEqualTo [-1]) exitWith {
        if (_veh isKindOf "Air") then {
            missionNamespace getVariable ["ARTEK_string_pilot_seat", "Pilot"]
        } else {
            missionNamespace getVariable ["ARTEK_string_driver_seat", "Driver"]
        }
    };
    private _tc = [_veh, _turretPath] call BIS_fnc_turretConfig;
    private _tn = getText (_tc >> "gunnerName");
    if (_tn == "") then { _tn = "Turret"; };
    _tn
};

ARTEK_fnc_buildTurretTabs = {
    params ["_vehicles", "_caller"];
    private _rules = missionNamespace getVariable ["ARTEK_veh_rules", []];
    private _tabs = [];
    {
        _x params ["_sd", "_label", "_tabColor"];
        private _mine = _vehicles select { ([_x] call ARTEK_fnc_objectSide) == _sd };
        private _groups = [];
        {
            private _type = _x select 0;
            private _enabled = ([_type, _sd] call ARTEK_fnc_vehicleRuleForSide) != "hide";
            if (_enabled) then {
                private _raw = [];
                {
                    private _veh = _x;
                    if (([_veh] call ARTEK_fnc_vehicleType) == _type) then {
                        private _dist = round (_caller distance _veh);
                        private _vehName = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
                        private _color = [_veh] call ARTEK_fnc_sideColor;
                        {
                            private _tp = _x;
                            private _seat = [_veh, _tp] call ARTEK_fnc_turretSeatName;
                            _raw pushBack [_dist, format ["%1 - %2 (%3m)", _vehName, _seat, _dist], _veh, _tp, _color];
                        } forEach ([_veh] call ARTEK_fnc_vehicleTurrets);
                    };
                } forEach _mine;
                if (count _raw > 0) then {
                    private _keys = [];
                    {
                        _keys pushBack [_x select 0, _forEachIndex];
                    } forEach _raw;
                    _keys sort true;
                    private _rows = [];
                    {
                        private _r = _raw select (_x select 1);
                        _rows pushBack [_r select 1, _r select 4, _r select 2, _r select 3];
                    } forEach _keys;
                    _groups pushBack [[_type] call ARTEK_fnc_vehicleTypeLabel, _rows];
                };
            };
        } forEach _rules;
        _tabs pushBack [_label, _tabColor, _groups];
    } forEach ([_caller] call ARTEK_fnc_activeSides);
    _tabs
};

ARTEK_fnc_buildUnitTabs = {
    params ["_units", "_caller", "_builder"];
    private _tabs = [];
    {
        _x params ["_sd", "_label", "_tabColor"];
        private _mine = _units select { ([_x] call ARTEK_fnc_objectSide) == _sd };
        private _groups = [];
        if (count _mine > 0) then {
            private _rows = [_mine, _caller] call _builder;
            private _fixed = [];
            {
                _fixed pushBack [_x select 0, _x select 1, _x select 2, []];
            } forEach _rows;
            _groups pushBack ["", _fixed];
        };
        _tabs pushBack [_label, _tabColor, _groups];
    } forEach ([_caller] call ARTEK_fnc_activeSides);
    _tabs
};

ARTEK_fnc_showTab = {
    params ["_display", "_index"];
    private _tabCtrls = _display getVariable ["tabCtrls", []];
    {
        private _idcs = _x;
        private _ti = _forEachIndex;
        private _vis = (_ti == _index);
        {
            (_display displayCtrl _x) ctrlShow _vis;
        } forEach _idcs;
        private _btn = _display displayCtrl (1700 + _ti);
        if (!isNull _btn) then {
            _btn ctrlSetBackgroundColor (if (_vis) then { [0.22, 0.22, 0.22, 0.95] } else { [0.08, 0.08, 0.08, 0.9] });
        };
    } forEach _tabCtrls;
    _display setVariable ["activeTab", _index];
    _display setVariable ["activeColumn", -1];
    {
        (_display displayCtrl _x) lbSetCurSel -1;
    } forEach (_display getVariable ["allListIdcs", []]);
    private _first = -1;
    {
        if (_first < 0 && {(lbSize (_display displayCtrl _x)) > 0} && {(floor (_x / 10)) - 150 == _index}) then { _first = _x; };
    } forEach (_display getVariable ["allListIdcs", []]);
    if (_first >= 0) then {
        (_display displayCtrl _first) lbSetCurSel 0;
    };
};

ARTEK_fnc_selectTabbedDialog = {
    params ["_title", "_tabs", "_onConfirm", "_params", ["_wide", true]];
    if (!hasInterface) exitWith {};
    if (count _tabs == 0) exitWith {};

    private _display = findDisplay 46 createDisplay "RscDisplayEmpty";
    private _panelW = if (_wide) then { 0.9 } else { 0.4 };
    private _panelX = (1 - _panelW) / 2;
    private _panelY = 0.18;
    private _panelH = 0.64;

    private _bg = _display ctrlCreate ["RscText", -1];
    _bg ctrlSetPosition [_panelX, _panelY, _panelW, _panelH];
    _bg ctrlSetBackgroundColor [0, 0, 0, 0.85];
    _bg ctrlCommit 0;

    private _titleCtrl = _display ctrlCreate ["RscStructuredText", -1];
    _titleCtrl ctrlSetPosition [_panelX, _panelY + 0.012, _panelW, 0.05];
    _titleCtrl ctrlSetStructuredText parseText format ["<t align='center' size='1.2' color='%1'>%2</t>", missionNamespace getVariable ["ARTEK_ui_color_header", "#006BC4"], _title];
    _titleCtrl ctrlCommit 0;

    private _innerX = _panelX + 0.01;
    private _innerW = _panelW - 0.02;
    private _tabY = _panelY + 0.068;
    private _tabH = 0.035;
    private _headY = _panelY + 0.112;
    private _listTop = _panelY + 0.15;
    private _groupColor = missionNamespace getVariable ["ARTEK_ui_color_group", [1, 0.75, 0.2, 1]];
    private _nTabs = count _tabs;
    private _tabGap = 0.004;
    private _tabW = (_innerW - (_tabGap * (_nTabs - 1))) / _nTabs;

    private _tabCtrls = [];
    private _allLists = [];

    {
        _x params ["_tabLabel", "_tabColor", "_groups"];
        private _ti = _forEachIndex;

        private _btn = _display ctrlCreate ["RscButton", 1700 + _ti];
        _btn ctrlSetPosition [_innerX + (_ti * (_tabW + _tabGap)), _tabY, _tabW, _tabH];
        _btn ctrlSetText _tabLabel;
        _btn ctrlSetTextColor _tabColor;
        _btn ctrlSetBackgroundColor [0.08, 0.08, 0.08, 0.9];
        _btn ctrlCommit 0;
        _btn ctrlAddEventHandler ["ButtonClick", {
            params ["_c"];
            [ctrlParent _c, (ctrlIDC _c) - 1700] call ARTEK_fnc_showTab;
        }];

        private _idcs = [];
        if (count _groups == 0) then {
            private _eidc = 1900 + _ti;
            private _empty = _display ctrlCreate ["RscText", _eidc];
            _empty ctrlSetPosition [_innerX, _listTop + 0.05, _innerW, 0.05];
            _empty ctrlSetText (missionNamespace getVariable ["ARTEK_string_tab_empty", "Nothing available"]);
            _empty ctrlSetTextColor [0.55, 0.55, 0.55, 1];
            _empty ctrlCommit 0;
            _idcs pushBack _eidc;
        } else {
            private _useHead = (_groups findIf { (_x select 0) != "" }) > -1;
            private _listY = if (_useHead) then { _listTop } else { _headY };
            private _listH = (_panelY + _panelH - 0.075) - _listY;
            private _nc = count _groups;
            private _gap = 0.005;
            private _colW = (_innerW - (_gap * (_nc - 1))) / _nc;
            {
                _x params ["_colLabel", "_rows"];
                private _ci = _forEachIndex;
                private _cx = _innerX + (_ci * (_colW + _gap));
                if (_colLabel != "") then {
                    private _hidc = 1600 + (_ti * 10) + _ci;
                    private _head = _display ctrlCreate ["RscText", _hidc];
                    _head ctrlSetPosition [_cx, _headY, _colW, 0.03];
                    _head ctrlSetText _colLabel;
                    _head ctrlSetTextColor _groupColor;
                    _head ctrlCommit 0;
                    _idcs pushBack _hidc;
                };
                private _lidc = 1500 + (_ti * 10) + _ci;
                private _list = _display ctrlCreate ["RscListBox", _lidc];
                _list ctrlSetPosition [_cx, _listY, _colW, _listH];
                _list ctrlSetBackgroundColor [0.1, 0.1, 0.1, 0.9];
                _list ctrlCommit 0;
                {
                    private _k = _list lbAdd (_x select 0);
                    _list lbSetColor [_k, _x select 1];
                } forEach _rows;
                _list lbSetCurSel -1;
                _display setVariable [format ["rows%1", _lidc], _rows];
                _list ctrlAddEventHandler ["LBSelChanged", {
                    params ["_ctrl", "_sel"];
                    if (_sel < 0) exitWith {};
                    private _d = ctrlParent _ctrl;
                    private _me = ctrlIDC _ctrl;
                    _d setVariable ["activeColumn", _me];
                    {
                        if (_x != _me) then { (_d displayCtrl _x) lbSetCurSel -1; };
                    } forEach (_d getVariable ["allListIdcs", []]);
                }];
                _idcs pushBack _lidc;
                _allLists pushBack _lidc;
            } forEach _groups;
        };
        _tabCtrls pushBack _idcs;
    } forEach _tabs;

    _display setVariable ["tabCtrls", _tabCtrls];
    _display setVariable ["allListIdcs", _allLists];
    _display setVariable ["onConfirm", _onConfirm];
    _display setVariable ["params", _params];
    _display setVariable ["activeColumn", -1];

    private _btnY = _panelY + _panelH - 0.062;
    private _confirmBtn = _display ctrlCreate ["RscButton", 1800];
    _confirmBtn ctrlSetPosition [_panelX + (_panelW / 2) - 0.18, _btnY, 0.17, 0.045];
    _confirmBtn ctrlSetText (missionNamespace getVariable ["ARTEK_string_ui_confirm", "Confirm"]);
    _confirmBtn ctrlSetBackgroundColor (missionNamespace getVariable ["ARTEK_ui_color_confirm", [0, 0.42, 1, 0.8]]);
    _confirmBtn ctrlSetTextColor [1, 1, 1, 1];
    _confirmBtn ctrlCommit 0;

    private _cancelBtn = _display ctrlCreate ["RscButton", 1801];
    _cancelBtn ctrlSetPosition [_panelX + (_panelW / 2) + 0.01, _btnY, 0.17, 0.045];
    _cancelBtn ctrlSetText (missionNamespace getVariable ["ARTEK_string_ui_cancel", "Cancel"]);
    _cancelBtn ctrlSetBackgroundColor (missionNamespace getVariable ["ARTEK_ui_color_cancel", [0.1, 0.1, 0.3, 0.8]]);
    _cancelBtn ctrlSetTextColor [1, 1, 1, 1];
    _cancelBtn ctrlCommit 0;

    _confirmBtn ctrlAddEventHandler ["ButtonClick", {
        params ["_ctrl"];
        private _d = ctrlParent _ctrl;
        private _idc = _d getVariable ["activeColumn", -1];
        if (_idc < 0) exitWith { _d closeDisplay 2; };
        private _list = _d displayCtrl _idc;
        private _sel = lbCurSel _list;
        if (_sel < 0) exitWith { _d closeDisplay 2; };
        private _rows = _d getVariable [format ["rows%1", _idc], []];
        if (_sel >= count _rows) exitWith { _d closeDisplay 2; };
        private _onConfirm = _d getVariable ["onConfirm", {}];
        ([_rows select _sel] + (_d getVariable ["params", []])) call _onConfirm;
        _d closeDisplay 1;
    }];

    _cancelBtn ctrlAddEventHandler ["ButtonClick", {
        params ["_ctrl"];
        (ctrlParent _ctrl) closeDisplay 2;
    }];

    [_display, 0] call ARTEK_fnc_showTab;
};

ARTEK_fnc_initOperatorCam = {
    params ["_monitor"];
    removeAllActions _monitor;
    private _assigned = _monitor getVariable ["operatorRenderTarget", ""];
    if (_assigned isEqualTo "") then {
        private _slots = missionNamespace getVariable ["ARTEK_rt_slots", 4];
        if (_slots < 1) then { _slots = 1; };
        private _base = missionNamespace getVariable ["ARTEK_rt_base", 0];
        private _renderIndex = _base + (ARTEK_OperatorCam_Index mod _slots);
        ARTEK_OperatorCam_Index = ARTEK_OperatorCam_Index + 1;
        _assigned = format ["rendertarget%1", _renderIndex];
        _monitor setVariable ["operatorRenderTarget", _assigned, true];
    };
    diag_log format ["[QG_ArTeK_Camera_Feeds] init monitor %1 su %2", vehicleVarName _monitor, _assigned];
    _monitor setVariable ["operatorFeedActive", false, true];
    _monitor setVariable ["feedType", "none", true];

    if (!hasInterface) exitWith {};

    private _statement_selectOperator = {
        params ["_target", "_caller"];
        private _operators = [_caller] call ARTEK_fnc_getOperatorsWithCamera;
        if (count _operators == 0) exitWith { hintSilent (missionNamespace getVariable ["ARTEK_string_nocams_hint", "No operators with cameras available"]); };
        private _tabs = [_operators, _caller, ARTEK_fnc_buildOperatorList] call ARTEK_fnc_buildUnitTabs;
        [
            missionNamespace getVariable ["ARTEK_string_interactionMenu_select", "Select Operator"],
            _tabs,
            {
                params ["_row", "_target"];
                private _unit = _row select 2;
                if (isNull _unit) exitWith {};
                [_target, "operator", _unit] call ARTEK_fnc_switchFeed;
            },
            [_target],
            false
        ] call ARTEK_fnc_selectTabbedDialog;
    };

    private _statement_selectVehicle = {
        params ["_target", "_caller"];
        private _vehicles = [_caller] call ARTEK_fnc_getVehiclesWithTurrets;
        if (count _vehicles == 0) exitWith {hintSilent "No vehicles with turrets available.";};
        private _tabs = [_vehicles, _caller] call ARTEK_fnc_buildTurretTabs;
        if (count _tabs == 0) exitWith {hintSilent "No turrets available.";};
        [
            "Select Turret",
            _tabs,
            {
                params ["_row", "_target"];
                private _veh = _row select 2;
                if (isNull _veh) exitWith {};
                [_target, "vehicle", _veh, _row select 3] call ARTEK_fnc_switchFeed;
            },
            [_target],
            true
        ] call ARTEK_fnc_selectTabbedDialog;
    };

    private _statement_selectSpotter = {
        params ["_target", "_caller"];
        private _spotters = [_caller] call ARTEK_fnc_getSpottersWithOptics;
        if (count _spotters == 0) exitWith {hintSilent "No spotters with optics available";};
        private _tabs = [_spotters, _caller, ARTEK_fnc_buildSpotterList] call ARTEK_fnc_buildUnitTabs;
        [
            "Select Spotter",
            _tabs,
            {
                params ["_row", "_target"];
                private _unit = _row select 2;
                if (isNull _unit) exitWith {};
                [_target, "spotter", _unit] call ARTEK_fnc_switchFeed;
            },
            [_target],
            false
        ] call ARTEK_fnc_selectTabbedDialog;
    };

    private _condition_operator = { missionNamespace getVariable ["ARTEK_feed_operator", true] };
    private _condition_turret = { missionNamespace getVariable ["ARTEK_feed_turret", true] };
    private _condition_spotter = { missionNamespace getVariable ["ARTEK_feed_spotter", true] };

    private _statement_changeVision = {
        [_this select 0] call ARTEK_fnc_changeVisionMode;
    };

    private _condition_changeVision = {
        _target getVariable ["operatorFeedActive", false] &&
        ((_target getVariable ["feedType", "none"]) == "vehicle" ||
         (_target getVariable ["feedType", "none"]) == "operator" ||
         (_target getVariable ["feedType", "none"]) == "spotter")
    };

    private _statement_zoomIn = {
        [_this select 0, 1] call ARTEK_fnc_changeZoom;
    };

    private _statement_zoomOut = {
        [_this select 0, -1] call ARTEK_fnc_changeZoom;
    };

    private _condition_zoomIn = {
        _target getVariable ["operatorFeedActive", false] &&
        (_target getVariable ["feedType", "none"]) == "vehicle" &&
        !([_target, 1] call ARTEK_fnc_zoomAtLimit)
    };

    private _condition_zoomOut = {
        _target getVariable ["operatorFeedActive", false] &&
        (_target getVariable ["feedType", "none"]) == "vehicle" &&
        !([_target, -1] call ARTEK_fnc_zoomAtLimit)
    };

    private _statement_disconnect_cams = {
        params ["_target"];
        [[netId _target], "ARTEK_fnc_disconnectSingleMonitor", true, false] call BIS_fnc_MP;
    };

    private _condition_disconnect_cams = { _target getVariable ["operatorFeedActive", false] };

    private _labelVision = missionNamespace getVariable ["ARTEK_string_change_vision", "Change Vision"];
    private _labelZoomIn = missionNamespace getVariable ["ARTEK_string_zoom_in", "Zoom In"];
    private _labelZoomOut = missionNamespace getVariable ["ARTEK_string_zoom_out", "Zoom Out"];

    if (missionNamespace getVariable ["ARTEK_use_ace_interaction", false]) then {
        private _selectOperator = ["Select Operator", missionNamespace getVariable ["ARTEK_string_interactionMenu_select", "Select Operator"], "", _statement_selectOperator, _condition_operator, {}, [], [0, 0, 0], 3] call ace_interact_menu_fnc_createAction;
        private _selectVehicle = ["Select Turret", "Select Turret", "", _statement_selectVehicle, _condition_turret, {}, [], [0, 0, 0], 3] call ace_interact_menu_fnc_createAction;
        private _selectSpotter = ["Select Spotter", "Select Spotter", "", _statement_selectSpotter, _condition_spotter, {}, [], [0, 0, 0], 3] call ace_interact_menu_fnc_createAction;
        private _changeVision = ["Change Vision", _labelVision, "", _statement_changeVision, _condition_changeVision, {}, [], [0, 0, 0], 3] call ace_interact_menu_fnc_createAction;
        private _zoomIn = ["Zoom In", _labelZoomIn, "", _statement_zoomIn, _condition_zoomIn, {}, [], [0, 0, 0], 3] call ace_interact_menu_fnc_createAction;
        private _zoomOut = ["Zoom Out", _labelZoomOut, "", _statement_zoomOut, _condition_zoomOut, {}, [], [0, 0, 0], 3] call ace_interact_menu_fnc_createAction;
        private _disconnectCams = ["Disconnect Camera", missionNamespace getVariable ["ARTEK_string_interactionMenu_disconnect", "Disconnect Camera"], "", _statement_disconnect_cams, _condition_disconnect_cams, {}, [], [0, 0, 0], 3] call ace_interact_menu_fnc_createAction;
        [_monitor, 0, ["ACE_MainActions"], _selectOperator] call ace_interact_menu_fnc_addActionToObject;
        [_monitor, 0, ["ACE_MainActions"], _selectVehicle] call ace_interact_menu_fnc_addActionToObject;
        [_monitor, 0, ["ACE_MainActions"], _selectSpotter] call ace_interact_menu_fnc_addActionToObject;
        [_monitor, 0, ["ACE_MainActions"], _changeVision] call ace_interact_menu_fnc_addActionToObject;
        [_monitor, 0, ["ACE_MainActions"], _zoomIn] call ace_interact_menu_fnc_addActionToObject;
        [_monitor, 0, ["ACE_MainActions"], _zoomOut] call ace_interact_menu_fnc_addActionToObject;
        [_monitor, 0, ["ACE_MainActions"], _disconnectCams] call ace_interact_menu_fnc_addActionToObject;
    } else {
        _monitor addAction [missionNamespace getVariable ["ARTEK_string_interactionMenu_select", "Select Operator"], _statement_selectOperator, nil, 1.5, true, true, "", str _condition_operator];
        _monitor addAction ["Select Turret", _statement_selectVehicle, nil, 1.4, true, true, "", str _condition_turret];
        _monitor addAction ["Select Spotter", _statement_selectSpotter, nil, 1.3, true, true, "", str _condition_spotter];
        _monitor addAction [_labelVision, _statement_changeVision, nil, 1.1, true, true, "", str _condition_changeVision];
        _monitor addAction [_labelZoomIn, _statement_zoomIn, nil, 1.06, true, true, "", str _condition_zoomIn];
        _monitor addAction [_labelZoomOut, _statement_zoomOut, nil, 1.05, true, true, "", str _condition_zoomOut];
        _monitor addAction [missionNamespace getVariable ["ARTEK_string_interactionMenu_disconnect", "Disconnect Camera"], _statement_disconnect_cams, nil, 1.0, true, true, "", str _condition_disconnect_cams];
    };
};

if (isServer) then {
    ARTEK_OperatorCam_Initialized = true;
    publicVariable "ARTEK_OperatorCam_Initialized";
};

if (hasInterface && {isNil "ARTEK_fovHandler"}) then {
    ARTEK_fovHandler = addMissionEventHandler ["EachFrame", { call ARTEK_fnc_fovTick }];
};

{
    if (!isNull _x) then {
        [_x] call ARTEK_fnc_initOperatorCam;
    };
} forEach ARTEK_OperatorCam_SyncConfig;
