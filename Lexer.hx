class Lexer {
	var filename: String;
	var code: String;
	var pos: Position;

	static var strings = {
		WHITESPACE: " \t\r\n",
		BINOP: "+-*/%",
		SYMBOLS: "()[]{}=.,:;&",
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
			} else if (StringTools.contains(Lexer.strings.SYMBOLS, char)) {
				// tokens.push( new Token("symbol", char) );

				if (char == "(") {
					tokens.push( new Token("lparen") );
				} else if (char == ")") {
					tokens.push( new Token("rparen") );

				} else if (char == "[") {
					tokens.push( new Token("lbracket") );
				} else if (char == "]") {
					tokens.push( new Token("rbracket") );

				} else if (char == "{") {
					tokens.push( new Token("lbrace") );
				} else if (char == "}") {
					tokens.push( new Token("rbrace") );

				} else if (char == "=") {
					tokens.push( new Token("equals") );
				} else if (char == ".") {
					tokens.push( new Token("dot") );
				} else if (char == ",") {
					tokens.push( new Token("comma") );
				} else if (char == ":") {
					tokens.push( new Token("colon") );
				} else if (char == ";") {
					tokens.push( new Token("semicolon") );
				} else if (char == "&") {
					tokens.push( new Token("ampersand") );
				}

			} else if (StringTools.contains(Lexer.strings.DIGITS, char)) {
				tokens.push( this.makeNumber() );

			} else if (StringTools.contains(Lexer.strings.QUOTES, char)) {
				tokens.push( this.makeString() );
			}

			this.advance();
		}

		return tokens;
	}

	public function makeNumber() {
		var numStr = "";
		var float = false;

		while (this.notEof() && StringTools.contains(Lexer.strings.DIGITS, this.at()) || this.at() == ".") {
			var char = this.at();

			if (char == ".") {
				if(float) break;
				numStr += ".";
				float = true;
			} else {
				numStr += char;
			}

			this.advance();
		}

		// advance back to the previous character so lexer won't skip it
		this.advance(-1);

		if (float)
			return new Token("number", Std.parseFloat(numStr));

		return new Token("number", Std.parseInt(numStr));
	}

	public function makeString() {
		var str = "";
		var quote = this.at();

		// advance past the first quote
		this.advance();

		// TODO: add escape characters support
		while (this.notEof() && this.at() != quote) {
			str += this.at();
			this.advance();
		}

		return new Token("string", str);
	}
}
