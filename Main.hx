class Main {

	public function new() {
		var lexer = new Lexer("<stdin>", "12+2 - 5; \"x\" + `'y'z`");
		var tokens = lexer.tokenize();

		for( token in tokens ) {
			Sys.println(token.asString());
		}

	}

	static function main() {
		new Main();
	}
}
