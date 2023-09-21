package components.runtime;

import components.*;
import components.nodes.*;
import components.runtime.*;

class Interpreter {
	public static function evaluate(node: Node, env: Environment) {
		if (node.type == "NumericLiteral") {
			return new RuntimeValue("number", node.value);
		} else if (node.type == "Program") {
			return Interpreter.evaluateProgram(node, env);
		} else if (node.type == "BinaryExpr") {
			return Interpreter.evaluateBinaryExpr(node, env);
		}

		return new RuntimeValue("undeclared", null);
	}

	static function evaluateProgram(node: Program, env: Environment) {
		var lastEvaluated: RuntimeValue = null;

		for (i in 0 ... node.body.length) {
			lastEvaluated = Interpreter.evaluate(node.body[i], env);
		}

		return lastEvaluated;
	}

	static function evaluateBinaryExpr(node: BinaryExpr, env: Environment) {
		var left = Interpreter.evaluate(node.left, env);
		var op = node.op;
		var right = Interpreter.evaluate(node.right, env);

		if (left.type == "number" && right.type == "number") {
			return Interpreter.evaluateNumericBinaryExpr(left, op, right);
		}

		return new RuntimeValue("null", null);
	}

	static function evaluateNumericBinaryExpr(left: RuntimeValue, op: String, right: RuntimeValue) {
		var result:Dynamic = 0;

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