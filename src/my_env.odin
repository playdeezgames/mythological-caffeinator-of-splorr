package metaphor

foreign import "my_env"

@(default_calling_convention="contextless")
foreign my_env {
    js_clear :: proc() ---
    js_write :: proc(text: string) ---
    js_can_read :: proc() -> bool ---
    js_read :: proc(buf: [^]byte, cap: i32) -> i32 ---
    js_add_button :: proc(text: string, command:string) ---
}
