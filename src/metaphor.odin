package metaphor

import "core:fmt"

//Yes, I know that this is global state
game_state : Game_State

DRINK_COFFEE_COMMAND :: "DRINK_COFFEE_COMMAND"
FILL_CUP_COMMAND :: "FILL_CUP_COMMAND"
MAKE_POT_COMMAND :: "MAKE_POT_COMMAND"

@(export)
step :: proc(dt: f32) -> bool {
    if js_can_read() {
        buf: [256]byte
        name := read_input(buf[:])
        if name == DRINK_COFFEE_COMMAND {
            game_state_drink_coffee(&game_state)
        } else if name == FILL_CUP_COMMAND {
            game_state_fill_cup(&game_state)
        } else if name == MAKE_POT_COMMAND {
            game_state_make_pot(&game_state)
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
    js_write("Full\n" if game_state.cup_full else "Empty\n")
    if game_state.cup_full {
        js_add_button("Drink Coffee!", DRINK_COFFEE_COMMAND)
    } else {
        if game_state.coffee_pot > 0 {
            js_add_button("Fill Cup!", FILL_CUP_COMMAND)
        }
    }
    js_write(fmt.tprintf("Coffee Pot: %d", game_state.coffee_pot))
    if game_state.coffee_pot <= 0 {
        js_add_button("Make Pot of Coffee!!", MAKE_POT_COMMAND)
    }
}

main :: proc() {
    game_state_init(&game_state)
    update()
}