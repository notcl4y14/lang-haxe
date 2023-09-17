class Main {

	public function new() {
		var lexer = new Lexer("<stdin>", "+-*/%");
		var tokens = lexer.tokenize();

		for( token in tokens ) {
			Sys.println(token.asString());
		}

	}

	static function main() {
		new Main();
	}
}
