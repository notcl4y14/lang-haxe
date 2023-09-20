package components.nodes;

class BinaryExpr extends components.Node {
	public var left: Node;
	public var op: String;
	public var right: Node;

	public function new(left: Node, op: String, right: Node) {
		this.type = "BinaryExpr";
		this.left = left;
		this.op = op;
		this.right = right;
	}
}
