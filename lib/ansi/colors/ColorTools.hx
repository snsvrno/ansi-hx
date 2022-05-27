package ansi.colors;

class ColorTools {

	static public function HEXto256(hex : Int) : Int {
		return RGBto256(
			(hex >> 16) & 0xff,
			(hex >> 8) & 0xff,
			hex & 0xff
		);
	}

	static public function RGBto256(r : Int, g : Int, b : Int) : Int {
		// https://en.wikipedia.org/wiki/ANSI_escape_code in the description of colors section describing 16-231.
		return 16 +
			36 * (Math.floor(r/255*6)) +
			6 * (Math.floor(g/255*6)) +
			Math.floor(b/255*6);
	}

	static public function length(string:String) : Int {
		if (string == null) { return 0; }
		var length = 0;
		var count = true;

		for (i in 0 ... string.length) {
			switch(string.charAt(i)) {
				case ansi.Command.ESC: count = false;
				case ansi.Command.END if (!count):
					length -= 1; // to uncount this character, which will be counted next.
					count = true;
				default:
			}
			
			if (count) length += 1;
		}

		return length;
	}

	static public function splitLength(string:String, len:Int) : Array<String> {
		var split = [ ];

		var length = 0;
		var count = true;
		var working : String = "";

		for (i in 0 ... string.length) {
			var char = string.charAt(i);
			switch(char) {
				case ansi.Command.ESC: count = false;
				case ansi.Command.END if (!count):
					length -= 1; // to uncount this character, which will be counted next.
					count = true;
				default:
			}

			if (count) length += 1;
			working += char;

			if (length == len) {
				length = 0;
				split.push(working);
				working = "";
			}
		}

		if (working.length > 0) split.push(working);

		return split;
	}
}
