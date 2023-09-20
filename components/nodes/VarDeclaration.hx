package components.nodes;

class VarDeclaration extends components.Node {
	public var assigne: String;
	public var value: Any;

	public function new(assigne: String, value: Any) {
		this.type = "VarDeclaration";
		this.assigne = assigne;
		this.value = value;
	}
}
