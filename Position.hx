class Position {
	var index: Int;
	var line: Int;
	var column: Int;

	public function new(index: Int, line: Int, column: Int) {
		this.index = index;
		this.line = line;
		this.column = column;
	}

	public function advance(char: String, delta: Int = 1) {
		this.index += delta;
		this.column += delta;

		if (char == "\n") {
			this.column = 0;
			this.line += 1;
		}

		return this;
	}
}
