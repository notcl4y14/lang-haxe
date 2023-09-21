package components.runtime;

import components.*;
import components.runtime.*;

class Interpreter {
	var filename: String;
	public var error: Error;

	public function new(filename: String) {
		this.filename = filename;
	}

	static function evaluate(node: Node, env: Environment) {
		if (node.type == "NumericLiteral") {
			return new RuntimeValue("number", node.value);
		} else if (node.type == "Program") {
			return Interpreter.evaluateProgram(node, env);
		} else if (node.type == "BinaryExpr") {
			return Interpreter.evaluateBinaryExpr(node, env);
		}

		return new RuntimeValue("undeclared", null);
	}

	static function evaluateProgram(node: Node, env: Environment) {
		var lastEvaluated: RuntimeValue;

		for (i in 0 ... node.body) {
			lastEvaluated = Interpreter.evaluate(node.body[i]);
		}

		return lastEvaluated;
	}

	static function evaluateBinaryExpr(node: Node, env: Environment) {
		var left = Interpreter.evaluate(node.left);
		var op = node.op;
		var right = Interpreter.evaluate(node.right);

		if (left.type == "number" && right.type == "number") {
			return Interpreter.evaluateNumericBinaryExpr(left, op, right);
		}

		return new RuntimeValue("null", null);
	}

	static function evaluateNumericBinaryExpr(left: Node, op: String, right: Node) {
		var result = 0;

		if (op == "+") {
			result = left.value + right.value;
		} else if (op == "-") {
			result = left.value - right.value;
		} else if (op == "*") {
			result = left.value * right.value;
		} else if (op == "/") {
			result = left.value / right.value;
		} else if (op == "%") {
			result = left.value % right.value;
		}

		return new RuntimeValue("number", result);
	}
}