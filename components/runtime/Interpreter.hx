package components.runtime;

import components.*;
import components.nodes.*;
import components.runtime.*;

class Interpreter {
	public static function evaluate(node: Node, env: Environment): RuntimeValue {
		if (node.type == "NumericLiteral") {
			var node = cast(node, NumericLiteral);
			return new RuntimeValue("number", node.value);
		} else if (node.type == "Program") {
			var node = cast(node, Program);
			return Interpreter.evaluateProgram(node, env);
		} else if (node.type == "BinaryExpr") {
			var node = cast(node, BinaryExpr);
			return Interpreter.evaluateBinaryExpr(node, env);
		} else if (node.type == "VarDeclaration") {
			var node = cast(node, VarDeclaration);
			return Interpreter.evaluateVarDeclaration(node, env);
		}

		return new RuntimeValue("undeclared", null);
	}

	static function evaluateProgram(node: Program, env: Environment): RuntimeValue {
		var lastEvaluated: RuntimeValue = null;

		for (i in 0 ... node.body.length) {
			lastEvaluated = Interpreter.evaluate(node.body[i], env);
		}

		return lastEvaluated;
	}

	static function evaluateBinaryExpr(node: BinaryExpr, env: Environment): RuntimeValue {
		var left = Interpreter.evaluate(node.left, env);
		var op = node.op;
		var right = Interpreter.evaluate(node.right, env);

		if (left.type == "number" && right.type == "number") {
			return Interpreter.evaluateNumericBinaryExpr(left, op, right);
		}

		return new RuntimeValue("null", null);
	}

	static function evaluateNumericBinaryExpr(left: RuntimeValue, op: String, right: RuntimeValue): RuntimeValue {
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

	static function evaluateVarDeclaration(node: VarDeclaration, env: Environment) {
		env.declareVariable(node.assigne, Interpreter.evaluate(node.value, env));
		return env.lookupVar(node.assigne);
	}
}