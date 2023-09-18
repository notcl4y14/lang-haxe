class Parser {
	public var filename: String;
	var tokens: Array<Token>;
	// public var errors: Array<Error>;
	public var error: Error;

	public function new(filename: String, tokens: Array<Token>) {
		this.tokens = tokens;
		// this.errors = [];
		this.error = null;
	}

	// returns the first in the array token
	private function at() {
		return this.tokens[0];
	}

	// yums the first token and returns it :P
	private function yum() {
		var prev = this.tokens.shift();
		return prev;
	}

	// yums, but makes sure that the token matches the given values
	private function yumExpect(type: String, value: Any, error: String) {
		var prev = this.yum();

		if (prev.type != type || prev.value != value) {
			// this.errors.push( new Error(this.filename, prev.pos, error) );
			this.error = new Error(this.filename, prev.pos, error);
			return null;
		}

		return prev;
	}

	// yums, but makes sure that the token type matches the given type
	private function yumExpectType(type: String, error: String) {
		var prev = this.yum();

		if (prev.type != type) {
			// this.errors.push( new Error(this.filename, prev.pos, error) );
			this.error = new Error(this.filename, prev.pos, error);
			return null;
		}

		return prev;
	}

	// check if parser hasn't reached end of file
	private function notEof() {
		return this.at().type != "eof";
	}

	// ------------------------------------------------------------------------------

	public function makeAst() {
		var program = new nodes.Program();

		while (this.notEof()) {
			var stmt:nodes.Node = this.parseStmt();
			program.body.push(stmt);

			if (this.error != null) {
				break;
			}
		}

		return program;
	}

	private function parseStmt() {
		return this.parseExpr();
	}

	private function parseExpr() {
		return this.parseAdditiveExpr();
	}

	private function parseAdditiveExpr(): nodes.Node {
		var left:nodes.Node = this.parseMultiplicativeExpr();

		while (this.notEof() && this.at().match("binop", "+") || this.at().match("binop", "-")) {
			var op:String = this.yum().value;
			var right:nodes.Node = this.parseMultiplicativeExpr();

			return new nodes.BinaryExpr(left, op, right);
		}

		return left;
	}

	private function parseMultiplicativeExpr(): nodes.Node {
		var left:nodes.Node = this.parsePrimaryExpr();

		while (this.notEof() && this.at().match("binop", "*") || this.at().match("binop", "/") || this.at().match("binop", "%")) {
			var op:String = this.yum().value;
			var right:nodes.Node = this.parsePrimaryExpr();

			return new nodes.BinaryExpr(left, op, right);
		}

		return left;
	}

	private function parsePrimaryExpr(): nodes.Node {
		var token = this.yum();

		if (token.type == "number") {
			return new nodes.NumericLiteral(token.value);
		}

		/*this.errors.push(
			new Error(
				this.filename, token.pos,
				'This token has not been setup for parsing: ${token.type}, ${token.value}'
		));*/

		this.error = new Error(
			this.filename, token.pos,
			'This token has not been setup for parsing: ${token.type}, ${token.value}');

		return new nodes.Undeclared();
	}
}
