package components.runtime;

class RuntimeValue {
	public var type: String;
	public var value: Any;

	public function new(type: String, value: Any) {
		this.type = type;
		this.value = value;
	}
}