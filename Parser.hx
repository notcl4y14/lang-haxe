class Parser {
	public var filename: String;
	var tokens: Array<Token>;
	public var errors: Array<Error>;

	public function new(filename: String, tokens: Array<Token>) {
		this.tokens = tokens;
		this.errors = [];
	}

	// returns the first in the array token
	public function at() {
		return this.tokens[0];
	}

	// yums the first token and returns it :P
	public function yum() {
		var prev = this.tokens.shift();
		return prev;
	}

	// yums, but makes sure that the token matches the given values
	public function yumExpect(type: String, value: Any, error: String) {
		var prev = this.yum();

		if (prev.type != type || prev.value != value) {
			this.errors.push( new Error(this.filename, prev.pos, error) );
			return;
		}

		return prev;
	}

	// yums, but makes sure that the token type matches the given type
	public function yumExpectType(type: String, error: String) {
		var prev = this.yum();

		if (prev.type != type) {
			this.errors.push( new Error(this.filename, prev.pos, error) );
			return;
		}

		return prev;
	}

	// ------------------------------------------------------------------------------

	public function makeAst() {}
}
