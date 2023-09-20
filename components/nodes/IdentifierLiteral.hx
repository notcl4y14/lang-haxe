package components.nodes;

class IdentifierLiteral extends components.Node {
	public var name: String;

	public function new(name: String) {
		this.type = "IdentifierLiteral";
		this.name = name;
	}
}
