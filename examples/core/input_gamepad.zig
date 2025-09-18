// raylib-zig (c) Nikolas Wipper 2024

const rl = @import("raylib");

const xbox_alias_1 = "xbox";
const xbox_alias_2 = "x-box";
const ps_alias = "playstation";
pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    rl.setConfigFlags(.{ .msaa_4x_hint = true }); // Set MSAA 4X hint before windows creation

    rl.initWindow(screen_width, screen_height, "raylib-zig [core] example - input gamepad");
    defer rl.closeWindow(); // Close window and OpenGL context

    const tex_ps3_pad: rl.Texture2D = try rl.loadTexture("resources/ps3.png");
    const tex_xbox_pad: rl.Texture2D = try rl.loadTexture("resources/xbox.png");

    // Set axis deadzones
    const left_stick_deadzone_x: f32 = 0.1;
    const left_stick_deadzone_y: f32 = 0.1;
    const right_stick_deadzone_x: f32 = 0.1;
    const right_stick_deadzone_y: f32 = 0.1;
    const left_trigger_deadzone: f32 = 0.1;
    const right_trigger_deadzone: f32 = 0.1;

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    var gamepad: i32 = 0; // which gamepad to display

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        // ...
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.ray_white);

        if (rl.isKeyPressed(.left) and gamepad > 0) gamepad -= 1;
        if (rl.isKeyPressed(.right)) gamepad += 1;

        if (rl.isGamepadAvailable(gamepad)) {
            const gamepadName: [*:0]const u8 = rl.getGamepadName(gamepad); // Convert from Zig string to C string to prevent problems in rl.textFormat()
            rl.drawText(rl.textFormat("GP%d: %s", .{ gamepad, gamepadName }), 10, 10, 20, .black);

            // Get axis values
            var left_stick_x: f32 = rl.getGamepadAxisMovement(gamepad, .left_x);
            var left_stick_y: f32 = rl.getGamepadAxisMovement(gamepad, .left_y);
            var right_stick_x: f32 = rl.getGamepadAxisMovement(gamepad, .right_x);
            var right_stick_y: f32 = rl.getGamepadAxisMovement(gamepad, .right_y);
            var left_trigger: f32 = rl.getGamepadAxisMovement(gamepad, .left_trigger);
            var right_trigger: f32 = rl.getGamepadAxisMovement(gamepad, .right_trigger);

            // Calculate deadzones
            if (left_stick_x > -left_stick_deadzone_x and left_stick_x < left_stick_deadzone_x) left_stick_x = 0;
            if (left_stick_y > -left_stick_deadzone_y and left_stick_y < left_stick_deadzone_y) left_stick_y = 0;
            if (right_stick_x > -right_stick_deadzone_x and right_stick_x < right_stick_deadzone_x) right_stick_x = 0;
            if (right_stick_y > -right_stick_deadzone_y and right_stick_y < right_stick_deadzone_y) right_stick_y = 0;
            if (left_trigger > -left_trigger_deadzone and left_trigger < left_trigger_deadzone) left_trigger = -1;
            if (right_trigger > -right_trigger_deadzone and right_trigger < right_trigger_deadzone) right_trigger = -1;

            if ((rl.textFindIndex(rl.textToLower(rl.getGamepadName(gamepad)), xbox_alias_1) != -1) or
                (rl.textFindIndex(rl.textToLower(rl.getGamepadName(gamepad)), xbox_alias_2) != -1))
            {
                rl.drawTexture(tex_xbox_pad, 0, 0, .dark_gray);

                // Draw buttons: xbox home
                if (rl.isGamepadButtonDown(gamepad, .middle)) rl.drawCircle(394, 89, 19, .red);

                // Draw buttons: basic
                if (rl.isGamepadButtonDown(gamepad, .middle_right)) rl.drawCircle(436, 150, 9, .red);
                if (rl.isGamepadButtonDown(gamepad, .middle_left)) rl.drawCircle(352, 150, 9, .red);
                if (rl.isGamepadButtonDown(gamepad, .right_face_left)) rl.drawCircle(501, 151, 15, .blue);
                if (rl.isGamepadButtonDown(gamepad, .right_face_down)) rl.drawCircle(536, 187, 15, .lime);
                if (rl.isGamepadButtonDown(gamepad, .right_face_right)) rl.drawCircle(572, 151, 15, .maroon);
                if (rl.isGamepadButtonDown(gamepad, .right_face_up)) rl.drawCircle(536, 115, 15, .gold);

                // Draw buttons: d-pad
                rl.drawRectangle(317, 202, 19, 71, .black);
                rl.drawRectangle(293, 228, 69, 19, .black);
                if (rl.isGamepadButtonDown(gamepad, .left_face_up)) rl.drawRectangle(317, 202, 19, 26, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_down)) rl.drawRectangle(317, 202 + 45, 19, 26, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_left)) rl.drawRectangle(292, 228, 25, 19, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_right)) rl.drawRectangle(292 + 44, 228, 26, 19, .red);

                // Draw buttons: left-right back
                if (rl.isGamepadButtonDown(gamepad, .left_trigger_1)) rl.drawCircle(259, 61, 20, .red);
                if (rl.isGamepadButtonDown(gamepad, .right_trigger_1)) rl.drawCircle(536, 61, 20, .red);

                // Draw axis: left joystick
                var left_gamepad_color: rl.Color = .black;
                if (rl.isGamepadButtonDown(gamepad, .left_thumb)) left_gamepad_color = .red;
                rl.drawCircle(259, 152, 39, .black);
                rl.drawCircle(259, 152, 34, .light_gray);
                rl.drawCircle(259 + @as(i32, @intFromFloat(left_stick_x * 20)), 152 + @as(i32, @intFromFloat(left_stick_y * 20)), 25, left_gamepad_color);

                // Draw axis: right joystick
                var right_gamepad_color: rl.Color = .black;
                if (rl.isGamepadButtonDown(gamepad, .right_thumb)) right_gamepad_color = .red;
                rl.drawCircle(461, 237, 38, .black);
                rl.drawCircle(461, 237, 33, .light_gray);
                rl.drawCircle(461 + @as(i32, @intFromFloat(right_stick_x * 20)), 237 + @as(i32, @intFromFloat(right_stick_y * 20)), 25, right_gamepad_color);

                // Draw axis: left-right triggers
                rl.drawRectangle(170, 30, 15, 70, .gray);
                rl.drawRectangle(604, 30, 15, 70, .gray);
                rl.drawRectangle(170, 30, 15, @as(i32, @intFromFloat((1 + left_trigger) / 2 * 70)), .red);
                rl.drawRectangle(604, 30, 15, @as(i32, @intFromFloat((1 + right_trigger) / 2 * 70)), .red);
            } else if (rl.textFindIndex(rl.textToLower(rl.getGamepadName(gamepad)), ps_alias) > -1) {
                rl.drawTexture(tex_ps3_pad, 0, 0, .dark_gray);

                // Draw buttons: ps
                if (rl.isGamepadButtonDown(gamepad, .middle)) rl.drawCircle(396, 222, 13, .red);

                // Draw buttons: basic
                if (rl.isGamepadButtonDown(gamepad, .middle_left)) rl.drawRectangle(328, 170, 32, 13, .red);
                if (rl.isGamepadButtonDown(gamepad, .middle_right)) rl.drawTriangle(rl.Vector2{ .x = 436, .y = 168 }, rl.Vector2{ .x = 436, .y = 185 }, rl.Vector2{ .x = 464, .y = 177 }, .red);
                if (rl.isGamepadButtonDown(gamepad, .right_face_up)) rl.drawCircle(557, 144, 13, .lime);
                if (rl.isGamepadButtonDown(gamepad, .right_face_right)) rl.drawCircle(586, 173, 13, .red);
                if (rl.isGamepadButtonDown(gamepad, .right_face_down)) rl.drawCircle(557, 203, 13, .violet);
                if (rl.isGamepadButtonDown(gamepad, .right_face_left)) rl.drawCircle(527, 173, 13, .pink);

                // Draw buttons: d-pad
                rl.drawRectangle(225, 132, 24, 84, .black);
                rl.drawRectangle(195, 161, 84, 25, .black);
                if (rl.isGamepadButtonDown(gamepad, .left_face_up)) rl.drawRectangle(225, 132, 24, 29, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_down)) rl.drawRectangle(225, 132 + 54, 24, 30, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_left)) rl.drawRectangle(195, 161, 30, 25, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_right)) rl.drawRectangle(195 + 54, 161, 30, 25, .red);

                // Draw buttons: left-right back
                if (rl.isGamepadButtonDown(gamepad, .left_trigger_1)) rl.drawCircle(239, 82, 20, .red);
                if (rl.isGamepadButtonDown(gamepad, .right_trigger_1)) rl.drawCircle(557, 82, 20, .red);

                // Draw axis: left joystick
                var left_gamepad_color: rl.Color = .black;
                if (rl.isGamepadButtonDown(gamepad, .left_thumb)) left_gamepad_color = .red;
                rl.drawCircle(319, 255, 35, .black);
                rl.drawCircle(319, 255, 31, .light_gray);
                rl.drawCircle(319 + @as(i32, @intFromFloat(left_stick_x * 20)), 255 + @as(i32, @intFromFloat(left_stick_y * 20)), 25, left_gamepad_color);

                // Draw axis: right joystick
                var right_gamepad_color: rl.Color = .black;
                if (rl.isGamepadButtonDown(gamepad, .right_thumb)) right_gamepad_color = .red;
                rl.drawCircle(475, 255, 35, .black);
                rl.drawCircle(475, 255, 31, .light_gray);
                rl.drawCircle(475 + @as(i32, @intFromFloat(right_stick_x * 20)), 255 + @as(i32, @intFromFloat(right_stick_y * 20)), 25, right_gamepad_color);

                // Draw axis: left-right triggers
                rl.drawRectangle(169, 48, 15, 70, .gray);
                rl.drawRectangle(611, 48, 15, 70, .gray);
                rl.drawRectangle(169, 48, 15, @as(i32, @intFromFloat((1 + left_trigger) / 2 * 70)), .red);
                rl.drawRectangle(611, 48, 15, @as(i32, @intFromFloat((1 + right_trigger) / 2 * 70)), .red);
            } else {
                // Draw background: generic
                rl.drawRectangleRounded(rl.Rectangle{ .x = 175, .y = 110, .width = 460, .height = 220 }, 0.3, 16, .dark_gray);

                // Draw buttons: basic
                rl.drawCircle(365, 170, 12, .ray_white);
                rl.drawCircle(405, 170, 12, .ray_white);
                rl.drawCircle(445, 170, 12, .ray_white);
                rl.drawCircle(516, 191, 17, .ray_white);
                rl.drawCircle(551, 227, 17, .ray_white);
                rl.drawCircle(587, 191, 17, .ray_white);
                rl.drawCircle(551, 155, 17, .ray_white);
                if (rl.isGamepadButtonDown(gamepad, .middle_left)) rl.drawCircle(365, 170, 10, .red);
                if (rl.isGamepadButtonDown(gamepad, .middle)) rl.drawCircle(405, 170, 10, .green);
                if (rl.isGamepadButtonDown(gamepad, .middle_right)) rl.drawCircle(445, 170, 10, .blue);
                if (rl.isGamepadButtonDown(gamepad, .right_face_left)) rl.drawCircle(516, 191, 15, .gold);
                if (rl.isGamepadButtonDown(gamepad, .right_face_down)) rl.drawCircle(551, 227, 15, .blue);
                if (rl.isGamepadButtonDown(gamepad, .right_face_right)) rl.drawCircle(587, 191, 15, .green);
                if (rl.isGamepadButtonDown(gamepad, .right_face_up)) rl.drawCircle(551, 155, 15, .red);

                // Draw buttons: d-pad
                rl.drawRectangle(245, 145, 28, 88, .ray_white);
                rl.drawRectangle(215, 174, 88, 29, .ray_white);
                rl.drawRectangle(247, 147, 24, 84, .black);
                rl.drawRectangle(217, 176, 84, 25, .black);
                if (rl.isGamepadButtonDown(gamepad, .left_face_up)) rl.drawRectangle(247, 147, 24, 29, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_down)) rl.drawRectangle(247, 147 + 54, 24, 30, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_left)) rl.drawRectangle(217, 176, 30, 25, .red);
                if (rl.isGamepadButtonDown(gamepad, .left_face_right)) rl.drawRectangle(217 + 54, 176, 30, 25, .red);

                // Draw buttons: left-right back
                rl.drawRectangleRounded(rl.Rectangle{ .x = 215, .y = 98, .width = 100, .height = 10 }, 0.5, 16, .dark_gray);
                rl.drawRectangleRounded(rl.Rectangle{ .x = 495, .y = 98, .width = 100, .height = 10 }, 0.5, 16, .dark_gray);
                if (rl.isGamepadButtonDown(gamepad, .left_trigger_1)) rl.drawRectangleRounded(rl.Rectangle{ .x = 215, .y = 98, .width = 100, .height = 10 }, 0.5, 16, .red);
                if (rl.isGamepadButtonDown(gamepad, .right_trigger_1)) rl.drawRectangleRounded(rl.Rectangle{ .x = 495, .y = 98, .width = 100, .height = 10 }, 0.5, 16, .red);

                // Draw axis: left joystick
                var leftGamepadColor: rl.Color = .black;
                if (rl.isGamepadButtonDown(gamepad, .left_thumb)) leftGamepadColor = .red;
                rl.drawCircle(345, 260, 40, .black);
                rl.drawCircle(345, 260, 35, .light_gray);
                rl.drawCircle(345 + @as(i32, @intFromFloat(left_stick_x * 20)), 260 + @as(i32, @intFromFloat(left_stick_y * 20)), 25, leftGamepadColor);

                // Draw axis: right joystick
                var rightGamepadColor: rl.Color = .black;
                if (rl.isGamepadButtonDown(gamepad, .right_thumb)) rightGamepadColor = .red;
                rl.drawCircle(465, 260, 40, .black);
                rl.drawCircle(465, 260, 35, .light_gray);
                rl.drawCircle(465 + @as(i32, @intFromFloat(right_stick_x * 20)), 260 + @as(i32, @intFromFloat(right_stick_y * 20)), 25, rightGamepadColor);

                // Draw axis: left-right triggers
                rl.drawRectangle(151, 110, 15, 70, .gray);
                rl.drawRectangle(644, 110, 15, 70, .gray);
                rl.drawRectangle(151, 110, 15, @as(i32, @intFromFloat(((1 + left_trigger) / 2) * 70)), .red);
                rl.drawRectangle(644, 110, 15, @as(i32, @intFromFloat(((1 + right_trigger) / 2) * 70)), .red);
            }
        }
    }
    //----------------------------------------------------------------------------------
}
