package metaphor

@(export)
step :: proc(dt: f32) -> bool {
    if js_can_read() {
        buf: [256]byte
        name := read_input(buf[:])
        command_dispatch(name)
        update()
    }
    return true
}

read_input :: proc(buf: []byte) -> string {
    n := int(js_read(raw_data(buf), i32(len(buf))))
    n = min(n, len(buf))
    return string(buf[:n])
}

main :: proc() {
    command_init()
    game_state_init(&game_state)
    update()
}