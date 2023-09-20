package components.frontend;

import components.*;
import components.nodes.*;

class Parser {
	public var filename: String;
	var tokens: Array<Token>;
	// public var errors: Array<Error>;
	public var error: Error;

	public function new(filename: String, tokens: Array<Token>) {
		this.filename = filename;
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
		var program = new Program();

		while (this.notEof()) {
			var stmt:Node = this.parseStmt();
			program.body.push(stmt);

			if (this.error != null) {
				break;
			}
		}

		return program;
	}

	private function parseStmt() {
		if (this.at().type == "ident" && (this.at().value == "var" || this.at().value == "let")) {
			return this.parseVarDeclaration();
		}

		return this.parseExpr();
	}

	private function parseVarDeclaration(): Node {
		var keyword = this.yum();
		var ident = this.yumExpectType("ident", "Expected an identifier after the var | let keyword");

		if (ident == null) {
			return new Undeclared();
		}

		if (this.at().type != "equals") {
			return new VarDeclaration(ident.value, NullLiteral);
		}

		this.yum();
		var value = this.parseExpr();

		return new VarDeclaration(ident.value, value);
	}

	private function parseExpr() {
		return this.parseAssignmentExpr();
	}

	private function parseAssignmentExpr(): Node {
		var left = this.parseAdditiveExpr();

		if (this.at().type == "equals") {
			this.yum();
			var value = this.parseAssignmentExpr();
			return new AssignmentExpr(left, value);
		}

		return left;
	}

	private function parseAdditiveExpr(): Node {
		var left:Node = this.parseMultiplicativeExpr();

		while (this.notEof() && this.at().match("binop", "+") || this.at().match("binop", "-")) {
			var op:String = this.yum().value;
			var right:Node = this.parseMultiplicativeExpr();

			return new BinaryExpr(left, op, right);
		}

		return left;
	}

	private function parseMultiplicativeExpr(): Node {
		var left:Node = this.parsePrimaryExpr();

		while (this.notEof() && this.at().match("binop", "*") || this.at().match("binop", "/") || this.at().match("binop", "%")) {
			var op:String = this.yum().value;
			var right:Node = this.parsePrimaryExpr();

			return new BinaryExpr(left, op, right);
		}

		return left;
	}

	private function parsePrimaryExpr(): Node {
		var token = this.yum();

		if (token.type == "ident") {
			return new IdentifierLiteral(token.value);
		} else if (token.type == "number") {
			return new NumericLiteral(token.value);
		}

		/*this.errors.push(
			new Error(
				this.filename, token.pos,
				'This token has not been setup for parsing: ${token.type}, ${token.value}'
		));*/

		this.error = new Error(
			this.filename, token.pos,
			'This token has not been setup for parsing: ${token.type}, ${token.value}');

		return new Undeclared();
	}
}
