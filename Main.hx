import components.frontend.Lexer;
import components.frontend.Parser;

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

		var parser = new Parser(filename, tokens);
		var ast = parser.makeAst();

		/*if (parser.errors.length > 0) {
			for( error in parser.errors ) {
				Sys.println(error.asString());
			}

			return;
		}*/

		if (parser.error != null) {
			Sys.println(parser.error.asString());
			return;
		}

		if (Sys.args().contains("--parser")) {
			for( node in ast.body ) {
				Sys.println(node.type);
			}
		}

	}

	static function main() {
		new Main();
	}
}
