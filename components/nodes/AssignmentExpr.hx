package components.nodes;

class AssignmentExpr extends components.Node {
	public var assigne: components.Node;
	public var value: Any;

	public function new(assigne: components.Node, value: Any) {
		this.type = "AssignmentExpr";
		this.assigne = assigne;
		this.value = value;
	}
}
