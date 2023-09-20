package components;

import components.Position;

class Error {
	var filename: String;
	var pos: Position;
	var details: String;

	public function new(filename: String, pos: Position, details: String) {
		this.filename = filename;
		this.pos = pos;
		this.details = details;
	}

	public function asString() {
		var filename = this.filename;
		var line = this.pos.line;
		var column = this.pos.column;
		var details = this.details;

		return '${filename}:${line}:${column}: ${details}';
	}
}
