package metaphor

Game_State :: struct {
    coffees_drank: int,
    cup_full: bool
}

game_state_init :: proc(game_state: ^Game_State) {
    game_state.coffees_drank = 0
    game_state.cup_full = false
}