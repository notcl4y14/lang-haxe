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

		var lexer = new Lexer("<stdin>", content);
		var tokens = lexer.tokenize();

		for( token in tokens ) {
			Sys.println(token.asString());
		}

	}

	static function main() {
		new Main();
	}
}
