package components;

import components.Position;

class Token {
	public var type: String;
	public var value: Any;
	public var pos: Position;

	public function new(type: String, value: Any = null, pos: Position) {
		this.type = type;
		this.value = value;
		this.pos = pos;
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
