const std = @import("std");
const root = @import("root.zig");
const game = @import("game.zig");

// Data-Oriented Design Experimentation!
// DOD is about moving memory-management into distinct areas of code
// Primitive types should all live adjacent to one another in purpose-built arrays
// These arrays are handled by dedicated central systems
// Data in these arrays is accessed through "index-handles:"
// index-handles are just integer indices that work on multiple arrays.
// related index-handles are member data of structs that represent a whole thing.
// Ex: Monster struct and data:
// const Monster = struct {
//    health: u32,           // in C-style code this would be a pointer to something
//    strength: u32,         // index-handles can't be invalidated by array realloc
// };
//
// var [_]u32 Monster_Healths = .{100, 100, 100, 99, 1};
// var [_]u32 Monster_Strengths = .{5, 5, 5, 5, 10};
//
// A new Monster would be created by allocating 2 new index-handles:
// const index_val1 = 2;
// const index_val2 = 4;
// var Bryan = Monster{ .health=index-val1, .strength=index-val2 };
// and any access to the underlying comes from hitting the arrays at that index:
// const lets_see_bryans_health = Monster_Healths[Bryan.health];
// std.debug.print("Bryan's Health is: {} \n", .{lets_see_bryans_health});
// Bryan's Health is: 100

// A more real-world, heavyweight setup would define an additional layer:
// A system dedicated to Monsters.
// Heap-allocate 100 monsters:
// create_Monster() called 100 times:
// Set underlying arrays to 100 index places, preferably not requiring 100 calls
// (power of 2 realloc, this functionality is built into std lib structures)
// Index-handle-carrying structs are made, also 100
// Each struct gets index-handles.

pub fn main() !void {
    const board_size = 10;

    std.debug.print("Initialize Monster Management\n", .{});

    //init units
    const game_units = try init_units();
    errdefer game_units.deinit();

    const num_units = game_units.items.len;
    _ = num_units;
    std.debug.print("Created {} game units of {}\n", .{ game_units.items.len, @TypeOf(game_units.items[0]) });
    //init board
    const game_board = try init_board(board_size);
    std.debug.print("Current Board size: {any}\n", .{game_board.items.len});
    errdefer game_board.deinit();

    std.debug.print("Created the game board.\n", .{});
    //place units on board
    try init_placement_units_on_board(game_board, game_units);
    std.debug.print("Current State of Game Board:\n", .{});
    std.debug.print("Monsters and their Locations:\n", .{});
    var placed_mon_count: u16 = 0;
    for (game_board.items) |place| {
        if (place.unit_index == null) {
            std.debug.print("Board Place: {any} \n", .{place});
        } else {
            placed_mon_count += 1;
            std.debug.print("Board Place: X: {any}, Y: {any}, UNIT: {any} \n", .{ place.x, place.y, game_units.items[place.unit_index.?] });
        }
    }
    std.debug.print("Total number of monsters with good board locations: {} \n", .{placed_mon_count});
    //start game loop

}

pub fn init_units() !std.ArrayList(game.Monster) {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var monsters = std.ArrayList(game.Monster).init(alloc);
    for (0..10) |m| {
        _ = m;
        try monsters.append(game.Monster{ .hp = 100, .str = 10 });
    }
    return monsters;
}

pub fn init_board(board_size: u16) !std.ArrayList(game.Location) {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    var board = std.ArrayList(game.Location).init(alloc);
    var x: u16 = 0;
    while (x < board_size) : (x += 1) {
        var y: u16 = 0;
        while (y < board_size) : (y += 1) {
            try board.append(game.Location{ .x = x, .y = y, .unit_index = null });
        }
    }
    return board;
}

pub fn init_placement_units_on_board(board: std.ArrayList(game.Location), monsters: std.ArrayList(game.Monster)) !void {
    // associate monsters with board somehow.
    // Location has unit_index that will be an index into monsters.items[]
    // Yes, let's try that.

    for (0..monsters.items.len) |idx| {
        //randomly allocate our Monsters to Locations
        var rand = std.crypto.random.intRangeAtMost(u16, 0, 99);
        while (board.items[rand].unit_index != null) {
            //remake our random number and go again
            rand = std.crypto.random.intRangeAtMost(u16, 0, 99);
        }
        if (board.items[rand].unit_index == null) {
            board.items[rand].unit_index = idx;
        }
    }
}
