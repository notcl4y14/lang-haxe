package nodes;

class Program extends Node {
	public var body: Array<Node>;

	public function new() {
		this.type = "Program";
		this.body = [];
	}
}
