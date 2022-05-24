import ansi.colors.Color.*;
import ansi.colors.Style.*;

class Test {
	public static function main() {
		ansi.Command.clearScreen();
		ansi.Command.moveCursorHome();

		Sys.println("      here");
		Sys.println("delete save");
		Sys.println("save delete");
		Sys.println("delete this line");

		ansi.Command.moveCursor(1,1);
		ansi.Command.saveCursor();
		ansi.Command.moveCursor(1,19);
		ansi.Command.restoreCursor();
		Sys.print("Print");

		ansi.Command.moveCursor(2,7);
		ansi.Command.clearLeft();

		ansi.Command.moveCursor(3,5);
		ansi.Command.clearRight();

		ansi.Command.moveCursor(4,4);
		ansi.Command.clearLine();

		ansi.Command.moveCursor(5,1);
		

		// ANSI NORMAL COLOR CODES /////////////////////////////////////////

		Sys.print("\nANSI 16 CODES\n\n");

		for (c in [Black, Red, Green, Yellow, Blue, Magenta, Cyan, White]) {
			Sys.println(

				ansi.Paint.paint("Dim", c, null, Dim) + " " +
				ansi.Paint.paint(" Dim ", null, c, Dim) + " " +

				ansi.Paint.paint("Normal", c, null) + " " +
				ansi.Paint.paint(" Normal ", null, c) + " " +

				ansi.Paint.paint("Strong", c, null, Bold) + " " +
				ansi.Paint.paint(" Strong ", null, c, Bold) + " " +

				ansi.Paint.color(c, true) +
				"Bright" + ansi.Paint.color() + " " +
				ansi.Paint.background(c, true) +
				" Bright " + ansi.Paint.background()

				);
		}

		// 256 Colors /////////////////////////////////////////////////////////////

		Sys.print("\n256 CODES\n\n");

		var w = 0;
		var windowWidth = ansi.Command.getSize().c;
		for (i in 0 ... 256) {
			var n = '$i';
			while (n.length < 3) n = " " + n;

			Sys.print(ansi.Paint.color256(i) + n + ansi.Paint.color());

			w += 4;

			if(w >= windowWidth) {
				Sys.println("");
				w = 0;
			} else {
				Sys.print(" ");
			}

		}

		Sys.println("\n");

		var w = 0;
		var windowWidth = ansi.Command.getSize().c;
		for (i in 0 ... 256) {
			var n = '$i';
			while (n.length < 3) n = " " + n;

			Sys.print(ansi.Paint.background256(i) + n + ansi.Paint.color());

			w += 4;

			if(w >= windowWidth) {
				Sys.println("");
				w = 0;
			} else {
				Sys.print(" ");
			}

		}
	}
}
