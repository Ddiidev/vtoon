module vtoon

pub fn decode[T](input string) T {
	mut default := T{}
	mut tokens := tokenize(input)
	ast := build_ast(tokens)
	dump(ast)

	for curr_ast in ast {
		$for field in T.fields {
			if field.name == curr_ast.key {
				$if field.typ is int {
					default.$(field.name) = curr_ast.value.value.int()
				} $else $if field.typ is bool {
					default.$(field.name) = curr_ast.value.value.bool()
				} $else $if field.typ is string {
					default.$(field.name) = curr_ast.value.value
				}
			}
		}
	}
	
	return default
}
