class Lexer {
	var filename: String;
	var code: String;
	var pos: Position;

	static var strings = {
		WHITESPACE: " \t\r\n",
		BINOP: "+-*/%",
		SYMBOLS: ".,:;=&",
		DIGITS: "1234567890",
		QUOTES: "\"'`",
		IDENT: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
	}

	public function new(filename: String, code: String) {
		this.filename = filename;
		this.code = code;
		this.pos = new Position(-1, 0, -1);

		this.advance();
	}

	// returns character the lexer is at
	private function at() {
		return this.code.substr(this.pos.index, 1);
	}

	// advances to the next character
	private function advance(delta: Int = 1) {
		this.pos.advance(this.at(), delta);
	}

	// checks if lexer hasn't reached end of file
	private function notEof() {
		return this.pos.index < this.code.length;
	}

	// ------------------------------------------------------------------------------

	// makes a token array from the code
	public function tokenize() {
		var tokens: Array<Token> = [];

		while(this.notEof()) {
			var char = this.at();

			if (StringTools.contains(Lexer.strings.WHITESPACE, char)) {}
			else if (StringTools.contains(Lexer.strings.BINOP, char)) {
				tokens.push( new Token("binop", char) );
			}

			this.advance();
		}

		return tokens;
	}
}
