class Lexer {
	public var filename: String;
	var code: String;
	var pos: Position;
	public var errors: Array<Error>;

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
		this.errors = [];

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
				tokens.push( new Token("binop", char, this.pos) );
			} else if (StringTools.contains(Lexer.strings.SYMBOLS, char)) {
				// tokens.push( new Token("symbol", char) );

				if (char == "(") {
					tokens.push( new Token("lparen", null, this.pos) );
				} else if (char == ")") {
					tokens.push( new Token("rparen", null, this.pos) );

				} else if (char == "[") {
					tokens.push( new Token("lbracket", null, this.pos) );
				} else if (char == "]") {
					tokens.push( new Token("rbracket", null, this.pos) );

				} else if (char == "{") {
					tokens.push( new Token("lbrace", null, this.pos) );
				} else if (char == "}") {
					tokens.push( new Token("rbrace", null, this.pos) );

				} else if (char == "=") {
					tokens.push( new Token("equals", null, this.pos) );
				} else if (char == ".") {
					tokens.push( new Token("dot", null, this.pos) );
				} else if (char == ",") {
					tokens.push( new Token("comma", null, this.pos) );
				} else if (char == ":") {
					tokens.push( new Token("colon", null, this.pos) );
				} else if (char == ";") {
					tokens.push( new Token("semicolon", null, this.pos) );
				} else if (char == "&") {
					tokens.push( new Token("ampersand", null, this.pos) );
				}

			} else if (StringTools.contains(Lexer.strings.DIGITS, char)) {
				tokens.push( this.makeNumber() );

			} else if (StringTools.contains(Lexer.strings.QUOTES, char)) {
				tokens.push( this.makeString() );

			} else if (StringTools.contains(Lexer.strings.IDENT, char)) {
				tokens.push( this.makeIdent() );
			} else {
				var pos = this.pos;
				this.errors.push( new Error(this.filename, pos, "Undefined character '" + char + "'"));
			}

			this.advance();
		}

		tokens.push( new Token("eof", null, this.pos) );

		return tokens;
	}

	public function makeNumber() {
		var numStr = "";
		var float = false;
		var pos = this.pos;

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
			return new Token("number", Std.parseFloat(numStr), pos);

		return new Token("number", Std.parseInt(numStr), pos);
	}

	public function makeString() {
		var str = "";
		var quote = this.at();
		var pos = this.pos;

		// advance past the first quote
		this.advance();

		// TODO: add escape characters support
		while (this.notEof() && this.at() != quote) {
			str += this.at();
			this.advance();
		}

		return new Token("string", str, pos);
	}

	public function makeIdent() {
		var ident = "";
		var pos = this.pos;

		while (this.notEof() && StringTools.contains(Lexer.strings.IDENT, this.at())
				 || StringTools.contains(Lexer.strings.DIGITS, this.at())) {
			ident += this.at();
			this.advance();
		}

		return new Token("ident", ident, pos);
	}
}
