const rl = @cImport(@cInclude("raylib.h"));

pub const Rectangle = struct {
    height: u32,
    width: u32,
};

pub const ScreenLocation = struct {
    screen_x: u32,
    screen_y: u32,
};

//Creates a Button type to draw to screen in raylib
pub fn Button(loc: ScreenLocation, text: []u8) !void {
    const h_offset = 50;
    const w_offset = 100;
    const button_text = text;
    _ = button_text;
    //Button is 100 x 50 Rectangle
    const b_frame: Rectangle = Rectangle{ .height = loc.screen_x + h_offset, .width = loc.screen_y + w_offset };
    _ = b_frame;
}
