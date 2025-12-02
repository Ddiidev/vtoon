module vtoon

pub struct AST {
	key   string
	value ASTValueType
}

pub struct ASTValueType {
	value string
	type  ASTTokenType
}

pub enum ASTTokenType {
	string
	number
	boolean
}

pub struct ASTValueToken {
	value string
	type  ASTValueTokenType
}

const ast_value_token_none = ASTValueToken{
	type: .none
}

pub enum ASTValueTokenType {
	none       = -1
	identifier = 1
	number     = 2
	colon      = 3
	boolean    = 4
	new_line   = 5
}

pub fn (avtt ASTValueTokenType) get_token_type() ASTTokenType {
	return match avtt {
		.identifier { ASTTokenType.string }
		.number { ASTTokenType.number }
		.boolean { ASTTokenType.boolean }
		else { ASTTokenType.string }
	}
}

pub fn (mut avt []ASTValueToken) expected_value() bool {
	return avt[0] or { ast_value_token_none }.type == .identifier && avt[1] or {
		ast_value_token_none
	}.type == .colon
}

pub fn build_ast(tokens []Token) []AST {
	mut ast := []AST{}
	mut accumulator := []ASTValueToken{}

	for token in tokens {
		if accumulator.expected_value() {
			accumulator << ASTValueToken{token.value, ASTValueTokenType(token.type)}
			ast << AST{accumulator[0].value, ASTValueType{accumulator[2].value, accumulator[2].type.get_token_type()}}
			accumulator.clear()
		} else if token.type in [.identifier, .number, .boolean] {
			accumulator << ASTValueToken{token.value, ASTValueTokenType(token.type)}
		} else if token.type == .colon {
			accumulator << ASTValueToken{token.value, .colon}
		}
	}
	return ast
}
