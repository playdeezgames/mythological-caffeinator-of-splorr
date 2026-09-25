package metaphor

import "core:fmt"

//Yes, I know that this is global state
game_state : Game_State

DRINK_COFFEE_COMMAND :: "DRINK_COFFEE_COMMAND"
FILL_CUP_COMMAND :: "FILL_CUP_COMMAND"

@(export)
step :: proc(dt: f32) -> bool {
    if js_can_read() {
        buf: [256]byte
        name := read_input(buf[:])
        if name == DRINK_COFFEE_COMMAND {
            game_state.coffees_drank += 1
            game_state.cup_full = false
        } else if name == FILL_CUP_COMMAND {
            game_state.cup_full = true
        }
        update()
    }
    return true
}

read_input :: proc(buf: []byte) -> string {
    n := int(js_read(raw_data(buf), i32(len(buf))))
    n = min(n, len(buf))
    return string(buf[:n])
}

foreign import "my_env"

@(default_calling_convention="contextless")
foreign my_env {
    js_clear :: proc() ---
    js_write :: proc(text: string) ---
    js_can_read :: proc() -> bool ---
    js_read :: proc(buf: [^]byte, cap: i32) -> i32 ---
    js_add_button :: proc(text: string, command:string) ---
}

update :: proc() {
    js_clear()
    js_write(fmt.tprintf("Coffees Drank: %d\n", game_state.coffees_drank))
    js_write("Cup: ")
    if game_state.cup_full {
        js_write("Full\n")
        js_add_button("Drink Coffee!", DRINK_COFFEE_COMMAND)
    } else {
        js_write("Empty\n")
        js_add_button("Fill Cup!", FILL_CUP_COMMAND)
    }
    
}

main :: proc() {
    game_state_init(&game_state)
    update()
}