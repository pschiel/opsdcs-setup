---------------------------------------------------------------------------
--- STATE "mission"
---
--- available in _G:
---  - mission, warehouses, db
---  - all functions below
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--- MISC (undocumented)
---------------------------------------------------------------------------

function add_dynamic_group() end
function add_group() end
function add_player() end
function append_commanders() end
function del_player() end
function doZipFile() end
function getAlliesString() end
function getThreatsAllies() end
function getValueDictByKey() end
function getValueResourceByKey() end
function get_param_handle() end
function get_server_info() end
function get_unit_possible_player_roles() end
function get_welcome_info() end
function list_cockpit_params() end
function list_indication() end
function make_briefing() end
function register_unit() end
function release_player_slot() end
function remove_dynamic_group() end
function reset_players() end
function reset_slots() end
function set_human() end
function set_player_name() end
function set_welcome_info() end
function unset_human() end
function update_briefing() end

---------------------------------------------------------------------------
--- CONDITIONS
---------------------------------------------------------------------------

function c_all_of_coalition_in_zone(coalition, zone, type) end
function c_all_of_coalition_out_zone(coalition, zone, type) end
function c_all_of_group_in_zone(group, zone) end
function c_all_of_group_out_zone(group, zone) end
function c_argument_in_range(argument,  min, max, plugin) end
function c_bomb_in_zone(type, quantity, zone) end
function c_cargo_unhooked_in_zone(cargo, zone) end
function c_coalition_has_airdrome(coalition, airdrome) end
function c_coalition_has_helipad(coalition, farp) end
function c_cockpit_highlight_visible(id) end
function c_cockpit_param_equal_to(param, value) end
function c_cockpit_param_in_range(param, min, max) end
function c_cockpit_param_is_equal_to_another(param1, param2) end
function c_dead_zone(zone) end
function c_flag_equals(flag, value) end
function c_flag_equals_flag(flag1, flag2) end
function c_flag_is_false(flag) end
function c_flag_is_true(flag) end
function c_flag_less(flag, value) end
function c_flag_less_flag(flag1, flag2) end
function c_flag_more(flag1, flag2) end
function c_group_alive(group) end
function c_group_dead(group) end
function c_group_life_less(group, percent) end
function c_group_member_fuel_higher(group, percent, members) end
function c_group_member_fuel_less(group, percent, members) end
function c_indication_txt_equal_to(id, name, value) end
function c_missile_in_zone(type, value, zone) end
function c_mission_score_higher(coalition, score) end
function c_mission_score_lower(coalition, score) end
function c_mlrs_in_zone(type, value, zone) end
function c_part_of_coalition_in_zone(coalition, zone, type) end
function c_part_of_coalition_out_zone(coalition, zone, type) end
function c_part_of_group_in_zone(group, zone) end
function c_part_of_group_out_zone(group, zone) end
function c_player_score_less(scores) end
function c_player_score_more(scores) end
function c_player_unit_argument_in_range(argument, min, max) end
function c_predicate(text) end
function c_random_less(percent) end
function c_signal_flare_in_zone(color, value, zone) end
function c_time_after(seconds) end
function c_time_before(seconds) end
function c_time_since_flag(flag, seconds) end
function c_unit_alive(unit) end
function c_unit_altitude_higher(unit, altitude) end
function c_unit_altitude_higher_AGL(unit, altitude) end
function c_unit_altitude_lower(unit, altitude) end
function c_unit_altitude_lower_AGL(unit, altitude) end
function c_unit_argument_in_range(unit, argument, min, max) end
function c_unit_bank(unit,  min, max) end
function c_unit_damaged(unit) end
function c_unit_dead(unit) end
function c_unit_fuel_higher(unit, percent) end
function c_unit_fuel_less(unit, percent) end
function c_unit_heading(unit, min, max) end
function c_unit_hit(unit, hits) end
function c_unit_in_zone(unit, zone) end
function c_unit_in_zone_unit(unit, zone, zoneUnit) end
function c_unit_life_less(unit, percent) end
function c_unit_out_zone(unit, zone) end
function c_unit_out_zone_unit(unit, zone, zoneUnit) end
function c_unit_pitch(unit, min, max) end
function c_unit_speed_higher(unit, speed) end
function c_unit_speed_lower(unit, speed) end
function c_unit_vertical_speed(unit, min, max) end

---------------------------------------------------------------------------
--- ACTIONS
---------------------------------------------------------------------------

function a_activate_group(group) end
function a_activate_static(group) end
function a_add_radio_item(name, flag, value) end
function a_add_radio_item_for_coalition(coalition, name, flag, value) end
function a_add_radio_item_for_group(group, name, flag, value) end
function a_ai_task(aiAction) end
function a_aircraft_ctf_color_tag(unit, color) end
function a_clear_flag(flag) end
function a_cockpit_highlight(id, name, size, plugin) end
function a_cockpit_highlight_indication(id, indicator, name, size, plugin) end
function a_cockpit_highlight_position(id, x, y, z, dimX, dimY, dimZ) end
function a_cockpit_lock_player_seat(number) end
function a_cockpit_param_save_as(source, destination) end
function a_cockpit_perform_clickable_action(device, command, value, plugin) end
function a_cockpit_pop_actor() end
function a_cockpit_push_actor(number) end
function a_cockpit_remove_highlight(id) end
function a_cockpit_unlock_player_seat() end
function a_deactivate_group(group) end
function a_dec_flag(flag, value) end
function a_do_script(text) end
function a_do_script_file(file) end
function a_effect_smoke(zone, preset, density, name) end
function a_effect_smoke_stop(bane) end
function a_end_mission(winner, text, delay) end
function a_explosion(zone, altitude, volume) end
function a_explosion_marker(zone, altitude, color) end
function a_explosion_marker_unit(unit, color) end
function a_explosion_unit(unit, volume) end
function a_fall_in_template(group, template) end
function a_group_controllable_off(group) end
function a_group_controllable_on(group) end
function a_group_off(group) end
function a_group_on(group) end
function a_group_resume(group) end
function a_group_stop(group) end
function a_illumination_bomb(zone, altitude) end
function a_inc_flag(flag, value) end
function a_load_mission(file) end
function a_mark_to_all(value, text, zone, readonly, comment) end
function a_mark_to_coalition(value, text, zone, coalition, readonly, comment) end
function a_mark_to_group(value, text, zone, group, readonly, comment) end
function a_out_picture(file, seconds, clearview, delay, horz, vert, size, units) end
function a_out_picture_c(coalition, file, seconds, clearview, delay, horz, vert, size, units) end
function a_out_picture_g(group, file, seconds, clearview, delay, horz, vert, size, units) end
function a_out_picture_s(country, file, seconds, clearview, delay, horz, vert, size, units) end
function a_out_picture_stop() end
function a_out_picture_u(unit, file, seconds, clearview, delay, horz, vert, size, units) end
function a_out_sound(file, delay) end
function a_out_sound_c(coalition, file, delay) end
function a_out_sound_g(group, file, delay) end
function a_out_sound_s(country, file, delay) end
function a_out_sound_stop() end
function a_out_sound_u(unit, file, delay) end
function a_out_text_delay(text, seconds, clearview, delay) end
function a_out_text_delay_c(coalition, text, seconds, clearview, delay) end
function a_out_text_delay_g(group, text, seconds, clearview, delay) end
function a_out_text_delay_s(country, text, seconds, clearview, delay) end
function a_out_text_delay_u(unit, text, seconds, clearview, delay) end
function a_play_argument(unit, argument, start, stop, speed) end
function a_prevent_controls_synchronization(value) end
function a_radio_transmission(file, zone, modulation, loop, freq, power, name, delay) end
function a_remove_mark(value) end
function a_remove_radio_item(name) end
function a_remove_radio_item_for_coalition(coalition, name) end
function a_remove_radio_item_for_group(group, name) end
function a_remove_scene_objects(zone, mask) end
function a_route_gates_set_current_point() end
function a_scenery_destruction_zone(zone, level) end
function a_set_ATC_silent_mode(unit, silent) end
function a_set_ai_task(aiAction) end
function a_set_briefing(coalition, file, text) end
function a_set_carrier_illumination_mode(unit, mode) end
function a_set_command(command) end
function a_set_command_with_value(command, value) end
function a_set_failure(failure, probability, within) end
function a_set_flag(flag) end
function a_set_flag_random(flag, min, max) end
function a_set_flag_value(flag, value) end
function a_set_internal_cargo(mass) end
function a_set_internal_cargo_unit(unit, mass) end
function a_shelling_zone(zone, tnt, count) end
function a_show_helper_gate(x, z, y, course) end
function a_show_route_gates_for_unit(unit, flag) end
function a_signal_flare(zone, altitude, color, bearing) end
function a_signal_flare_unit(unit, color, bearing) end
function a_sound_from_unit() end
function a_sound_from_zone() end
function a_sound_stop_by_name() end
function a_start_listen_command(command, flag, count, min, max, device) end
function a_start_listen_event(event, flag) end
function a_stop_radio_transmission(name) end
function a_unit_emission_off(unit) end
function a_unit_emission_on(unit) end
function a_unit_off(unit) end
function a_unit_on(unit) end
function a_unit_set_life_percentage(unit, percent) end
function a_user_draw_hide(coalition, role) end
function a_user_draw_show(coalition, role) end
function a_zone_increment_resize(zone, inc) end
function c_start_wait_for_user(flagCont, flagBack) end
function c_stop_wait_for_user() end
