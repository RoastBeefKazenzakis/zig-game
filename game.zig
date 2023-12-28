const std = @import("std");

pub const Monster = struct {
    hp: u16, //health value
    str: u16, //strength value
};

pub const Location = struct {
    x: u16,
    y: u16,
    unit_index: ?u64,
};

pub fn attack(attacker_str: u32, defender_hp: u32) u32 {
    const leftover_hp: i32 = defender_hp - attacker_str;
    if (leftover_hp < 0) leftover_hp = 0;
    return leftover_hp;
    // subtract attacker's strength from defender's health.
    // meant to be called on struct members
    // ex: monster_management.attack(ArrayList(1).)

}
