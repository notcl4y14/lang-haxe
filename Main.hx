class Main {

	public function new() {
		var filename = Sys.args()[0];

		if (filename == null) {
			Sys.println("The filename to run should be specified!");
			return;
		}

		if (!sys.FileSystem.exists(filename)) {
			Sys.println('File ${filename} doesn\'t exist!');
			return;
		}

		var content = sys.io.File.getContent(filename);

		var lexer = new Lexer(filename, content);
		var tokens = lexer.tokenize();

		if (lexer.errors.length > 0) {
			for( error in lexer.errors ) {
				Sys.println(error.asString());
			}

			return;
		}

		if (Sys.args().contains("--lexer")) {
			for( token in tokens ) {
				Sys.println(token.asString());
			}
		}

	}

	static function main() {
		new Main();
	}
}
