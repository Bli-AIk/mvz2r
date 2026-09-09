// backend.odin —— 后端层
// 全项目唯一允许 import raylib 的文件
//
// 分层（依赖只能向下且不能反向）：
//
//   draw_*_system        游戏逻辑层：查询组件，只说"画什么"，不知道 raylib
//        ↓
//   backend.odin         本文件：把意图翻译成 raylib 调用（兼任窗口/帧/时间）
//        ↓
//   raylib               后端：真正绘制
//
// 规则：
//   1. 只有本文件 import rl
//   2. 系统只调本文件暴露的函数，绝不直接碰 rl
//   3. 换后端 = 重写本文件，系统一行不用改

package main

import "core:c"
import rl "vendor:raylib"

color_to_rl :: #force_inline proc(c: Color) -> rl.Color {
	_u8 :: #force_inline proc(x: f32) -> u8 {
		return u8(clamp(x, 0, 1) * 255 + 0.5)
	}
	return {_u8(c.r), _u8(c.g), _u8(c.b), _u8(c.a)}
}

rect_to_rl :: #force_inline proc(r: Rect) -> rl.Rectangle {
	return {r.x, r.y, r.w, r.h}
}

draw_rect :: proc(x, y, w, h: f32, color: Color) {
	rl.DrawRectangleRec({x, y, w, h}, color_to_rl(color))
}

init_window :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
}

close_window :: proc() {
	rl.CloseWindow()
}

begin_frame :: proc() {
	rl.BeginDrawing()
}

end_frame :: proc() {
	rl.EndDrawing()
}

clear_background :: proc(color: Color) {
	rl.ClearBackground(color_to_rl(color))
}

draw_fps :: proc(x, y: i32) {
	rl.DrawFPS(x, y)
}

set_target_fps :: proc(fps: i32) {
	rl.SetTargetFPS(fps)
}

frame_time :: proc() -> f32 {
	return rl.GetFrameTime()
}

window_should_close :: proc() -> bool {
	return rl.WindowShouldClose()
}

// sprites
load_texture :: proc(path: cstring) -> Texture {
	t := rl.LoadTexture(path)
	return {id = u32(t.id), width = i32(t.width), height = i32(t.height)}
}

unload_texture :: proc(tex: Texture) {
	rl.UnloadTexture({id = c.uint(tex.id), width = c.int(tex.width), height = c.int(tex.height)})
}

draw_sprite :: proc(tex: Texture, src: Rect, dest: Rect, tint: Color) {
	rl.DrawTexturePro(
		rl.Texture2D{id = tex.id, width = tex.width, height = tex.height},
		rect_to_rl(src),
		rect_to_rl(dest),
		{0, 0},
		0,
		color_to_rl(tint),
	)
}
