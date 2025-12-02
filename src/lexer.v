module vtoon

pub enum TokenType {
	identifier = 1
	number     = 2
	colon      = 3
	boolean    = 4
	new_line   = 5
}

pub struct Token {
	type  TokenType
	value string
}

pub struct Accmulator {
pub mut:
	accumulator string
}

pub fn (mut acc Accmulator) reset() {
	acc.accumulator = ''
}

pub fn (mut acc Accmulator) add(chr rune) {
	acc.accumulator += chr.str()
}

pub fn (mut acc Accmulator) add_to_tokens(mut tokens []Token) {
	if acc.accumulator == '' {
		return
	}
	if is_only_number(acc.accumulator) {
		tokens << Token{.number, acc.accumulator}
	} else if acc.accumulator == 'true' || acc.accumulator == 'false' {
		tokens << Token{.boolean, acc.accumulator}
	} 
	else {
		tokens << Token{.identifier, acc.accumulator}
	}
}

const break_lines_and_space = [rune(10), rune(13), rune(32)]

pub fn tokenize(input string) []Token {
	mut tokens := []Token{}
	mut accmulator := Accmulator{}

	for chr in input.runes() {
		if chr in break_lines_and_space {
			accmulator.add_to_tokens(mut tokens)
			accmulator.reset()
			continue
		}

		if chr == `:` {
			accmulator.add_to_tokens(mut tokens)
			accmulator.reset()
			tokens << Token{.colon, ':'}
		} else if is_letter(chr) || is_number(chr) {
			accmulator.add(chr)
		}
	}

	return tokens
}

@[inline]
fn is_letter(chr rune) bool {
	return  chr !in [`,`, `[`, `]`, `:`, `\n`]
}

const compatible_numbers = [rune(48), rune(49), rune(50), rune(51), rune(52), rune(53), rune(54), rune(55), rune(56), rune(57), `.`]

@[inline]
fn is_number(chr rune) bool {
	return chr in compatible_numbers
}

fn is_only_number(str string) bool {
	for chr in str.runes() {
		if !is_number(chr) {
			return false
		}
	}
	return true
}