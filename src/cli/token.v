module cli

import rand

pub struct Token {
pub:
	self string
}

pub fn get_token(length i8) Token {
	mut token := []u8{}
    for _ in 0 .. length {
        token << gen_letter_or_digit()
    }
    return Token{token.bytestr()}
}

fn gen_letter_or_digit() u8 {
    mut r := rand.int_in_range(0, 61) or {panic(err)}
    if r < 26 {
        // 0-25: 'a'-'z'
        return u8(`a` + r)
    } else if r < 52 {
        // 26-51: 'A'-'Z'
        return u8(`A` + r - 26)
    } else {
        // 52-61: '0'-'9'
        return u8(`0` + r - 52)
    }
}