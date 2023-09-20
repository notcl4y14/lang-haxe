package components.nodes;

class Program extends components.Node {
	public var body: Array<Node>;

	public function new() {
		this.type = "Program";
		this.body = [];
	}
}
