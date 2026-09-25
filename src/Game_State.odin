package metaphor

Game_State :: struct {
    coffees_drank: int,
    cup_full: bool,
    coffee_pot: int,
    coffee_pot_maximum : int
}

game_state_init :: proc(game_state: ^Game_State) {
    game_state.coffees_drank = 0
    game_state.cup_full = false
    game_state.coffee_pot = 12
    game_state.coffee_pot_maximum = 12
}

game_state_drink_coffee :: proc(game_state: ^Game_State) {
    game_state.coffees_drank += 1
    game_state.cup_full = false
}

game_state_fill_cup :: proc(game_state: ^Game_State) {
    game_state.cup_full = true
    game_state.coffee_pot -= 1
}

game_state_make_pot :: proc(game_state: ^Game_State) {
    game_state.coffee_pot = 12
}