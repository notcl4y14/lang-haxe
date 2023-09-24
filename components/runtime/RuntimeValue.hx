package components.runtime;

class RuntimeValue {
	public var type: String;
	public var value: Dynamic;

	public function new(type: String, value: Dynamic) {
		this.type = type;
		this.value = value;
	}
}