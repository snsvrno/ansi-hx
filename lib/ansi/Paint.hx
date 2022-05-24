package ansi;

import ansi.colors.Color;
import ansi.colors.Style;

class Paint {

	// INTERNAL HELPER FUNCTIONS ////////////////////////////////////
  /*
	inline private static function foreground(color:Color) : String
		return command(FG + color);

	inline private static function background(color:Color) : String
		return command(BG + color);
	*/

	inline private static function command(com:String) : String 
		return ansi.Command.make(com + "m");

	// PIECEMEAL PAINTING - COLORS //////////////////////////////////

	/*** Sets the foreground color, will set the color to "default" if not set */
	public static function color(?color:Color = Default, ?bright : Bool = false) : String {
		var b = if (bright) ";1" else "";
		return command(FG + color + b);
	}

	/**
	 * Sets the foreground color using a 256 color palette. Valid range is 0 - 255.
	 *
	 * No runtime checks to ensure `index` is within range. Behavior is unspecified outside of
	 * this range and can change depending on the terminal used.
	 */
	public static function color256(index : Int) : String {
		return command('38;5;$index');
	}

	/**
	 * Sets the foreground color using RGBint.
	 * Supported by terminals that support "Truecolor" (24-bit color)
	 */
	public static function colorRGB(r:Int, g:Int, b:Int) : String {
		return command('38;2;$r;$g;$b');
	}

	/*** Sets the background color, will set the color to "default" if not set */
	public static function background(?color:Color = Default, ?bright : Bool = false) : String {
		var b = if (bright) ";1" else "";
		return command(BG + color + b);
	}

	/**
	 * Sets the background color using a 256 color palette. Valid range is 0 - 255.
	 *
	 * No runtime checks to ensure `index` is within range. Behavior is unspecified outside of
	 * this range and can change depending on the terminal used.
	 */
	public static function background256(index : Int) : String {
		return command('48;5;$index');
	}

	/**
	 * Sets the background color using RGBint.
	 * Supported by terminals that support "Truecolor" (24-bit color)
	 */
	public static function backgroundRGB(r:Int, g:Int, b:Int) : String {
		return command('48;2;$r;$g;$b');
	}

	// PIECEMEAL PAINTING - STYLES ////////////////////////////////

	/*** Resets all color and styles */
	public static function reset() : String return command(RESET);

	/*** Sets the bold style */
	public static function bold(?state : Bool = true) : String {
		if (state) return command(BOLD);
		else return command(BOLD_RESET);
	}

	/*** Sets the dim style */
	public static function dim(?state : Bool = true) : String {
		if (state) return command(DIM);
		else return command(DIM_RESET);
	}

	/*** Sets the italic style */
	public static function italic(?state : Bool = true) : String {
		if (state) return command(STANDOUT);
		else return command(STANDOUT_RESET);
	}

	/*** Sets the underline style */
	public static function underline(?state : Bool = true) : String {
		if (state) return command(UNDERSCORE);
		else return command(UNDERSCORE_RESET);
	}

	/*** Sets the blink style */
	public static function blink(?state : Bool = true) : String {
		if (state) return command(BLINK);
		else return command(BLINK_RESET);
	}

	/*** Sets the reverse style */
	public static function reverse(?state : Bool = true) : String {
		if (state) return command(REVERSE);
		else return command(REVERSE_RESET);
	}

	/*** Sets the hidden style */
	public static function hidden(?state : Bool = true) : String {
		if (state) return command(HIDDEN);
		else return command(HIDDEN_RESET);
	}

	/*** Sets the strikethrough style */
	public static function strike(?state : Bool = true) : String {
		if (state) return command(STRIKETHROUGH);
		else return command(STRIKETHROUGH_RESET);
	}

	/*** Sets the double underline style */
	public static function doubleUnderline(?state : Bool = true) : String {
		if (state) return command(DOUBLEUNDERSCORE);
		else return command(DOUBLEUNDERSCORE_RESET);
	}

	// ALL IN ONE PAINTING /////////////////////////////////////////

	public static function paint(text : String, ?fg : Color, ?bg : Color, ?flags : Int = 0) : String {
		var line = "";

		if (bg != null) line += background(bg);
		if (fg != null) line += color(fg);

		if (flags & Style.Bold != 0) line += bold();
		if (flags & Style.Dim != 0) line += dim();
		if (flags & Style.Standout != 0) line += italic();
		if (flags & Style.Underline != 0) line += underline();
		if (flags & Style.Blink != 0) line += blink();
		if (flags & Style.Reverse != 0) line += reverse();
		if (flags & Style.Hidden != 0) line += hidden();
		if (flags & Style.Strike != 0) line += strike();
		if (flags & Style.DoubleUnderline != 0) line += doubleUnderline();

		line += text;

		line += reset();

		return line;
	}

	/**
	 * paints the text while preserving existing ansi color codes. will only paint unpainted
	 * text with the new color.
	 */
	public static function paintPreserve(text : String, ?fg : Color, ?bg : Color, ?flags : Int = 0) : String {
			
		var sets = ansi.CommandTools.splitByCodeSets(text);

		var newtext = "";
		for (pair in sets) {
			if (pair.code == null) newtext += paint(pair.text, fg, bg, flags);
			else newtext += pair.code + pair.text + reset();
		}

		return newtext;
	}
}
