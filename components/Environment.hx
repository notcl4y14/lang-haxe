package components;

class Environment {
	public var variables: Map<String, Any>;
	public var parentEnv: Environment;

	public function new(parentEnv: Environment = null) {
		this.variables = new Map<String, Any>();
		this.parentEnv = parentEnv;
	}

	public function declareVariable(name: String, value: Any) {
		if (this.variables.exists(name)) {
			return null;
		}

		this.variables[name] = value;
		return this.variables[name];
	}

	public function setVariable(name: String, value: Any) {
		if (!this.variables.exists(name)) {
			return null;
		}

		this.variables[name] = value;
		return this.variables[name];
	}

	public function lookupVar(name: String) {
		if (!this.variables.exists(name)) {
			return null;
		}

		return this.variables[name];
	}
}
