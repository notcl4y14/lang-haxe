class Token {
	public var type: String;
	public var value: Any;

	public function new(type: String, value: Any = null) {
		this.type = type;
		this.value = value;
	}

	// checks if the token matches the given values
	public function match(type: String, value: Any) {
		return this.type == type && this.value == value;
	}

	// returns token as string
	// like: [binop: +]
	public function asString() {
		return '[${this.type}: ${this.value}]';
	}
}
