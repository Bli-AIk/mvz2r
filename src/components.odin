package main

Position :: struct {
	x, y: f32,
}

Velocity :: struct {
	vx, vy: f32,
}

Size :: struct {
	w, h: f32,
}

Solid :: struct {}  

Color :: distinct [4]f32


Sprite :: struct {
	texture: Texture,
	src:     Rect,
}
