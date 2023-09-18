package nodes;

class NumericLiteral extends Node {
	public var value: Dynamic;

	// TODO: limit dynamic value to Int and Float
	public function new(value: Dynamic) {
		this.type = "NumericLiteral";
		this.value = value;
	}
}
