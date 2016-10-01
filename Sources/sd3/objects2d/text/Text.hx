package sd3.objects2d.text;

import kha.graphics2.Graphics;
import kha.math.FastVector2;
import kha.Font;
import kha.math.Vector2i;

enum TextAlign
{
	Left;
	Center;
	Right;
}

typedef TextOptions = {	
	@:optional var align:TextAlign;
	@:optional var lineSpacing:Int;
}

typedef Line = {
	var text:String;
	var width:Int;
}

class Text extends Object2d
{
	/**
	 * Text that will be rendered. The text is divided
	 * in lines according to the box width
	 */
	public var text(default, set):String;
	/**
	 * Changing the text or the box width will put
	 * textProcessed to false, this variable
	 * is used in update to check if the text needs to be
	 * divided in lines again
	 */
	var textProcessed:Bool;

	public var font(default, null):Font;

	public var fontSize(default, set):Int;
	
	var fontHeight:Int;

	public var align:TextAlign;
	public var lineSpacing:Int;

	/** 
	 * The width of the box that contain the text
	 */
	public var boxWidth(default, set):Int;		
	/** 
	 * The height of the box that contain the text. This is calculated 
	 *  automatically based on the number of lines. 
	 */	
	public var boxHeight(default, null):Int;
	/** 
	 * Trims trailing space characters 
	 */
	public var trimEnds:Bool; 
	/** 
	 * Trims ALL space characters (including mid-sentence) 
	 */
	public var trimAll:Bool;
	
	var cursor:FastVector2;
	
	var lines:Array<Line>;

	public function new(x:Float, y:Float, text:String, font:Font, fontSize:Int, boxWidth:Int = 0, ?option:TextOptions):Void
	{
		super(x, y);

		cursor = new FastVector2();
		this.text = text;

		// this will automatically put
		// textProcessed as false
		this.boxWidth = boxWidth;

		trimEnds = true;
		trimAll = true;

		// As update is called before render
		// the value for boxHeight will be available in render
		boxHeight = 0;

		this.font = font;				

		this.fontSize = fontSize;

		if (option != null)
		{
			if (option.align != null)
				align = option.align;
			else
				align = TextAlign.Left;

			if (option.lineSpacing != null)
				lineSpacing = option.lineSpacing;
			else
				lineSpacing = 3;
		}
		else
		{
			align = TextAlign.Left;
			lineSpacing = 3;
		}
		
		// process the text immediately to get the boxHeight
		update();
	}

	override public function update():Void
	{
		if (textProcessed)
			return;

		// Array of lines that will be returned.
		lines = new Array<Line>();
		
		if (boxWidth <= 0)
		{
			lines.push({ text: text, width: 0 });
			return;
		}

		// Test the regex here: https://regex101.com/
		var trim1 = ~/^ +| +$/g; // removes all spaces at beginning and end
		var trim2 = ~/ +/g; // merges all spaces into one space
		var fullText = text;
		
		if (trimAll)
		{
			fullText = trim1.replace(fullText, ''); // remove trailing spaces first
			fullText = trim2.replace(fullText, ' '); // merge all spaces into one
		}
		else if (trimEnds)		
			fullText = trim1.replace(fullText, '');

		// split words by spaces
		// E.g. "This is a sentence"
		// becomes ["this", "is", "a", "sentence"]
		var words = fullText.split(' ');
		var wordsLen = words.length;
		var j = 1;

		// Add a space word in between every word.
		// E.g. ["this", "is", "a", "sentence"]
		// becomes ["this", " ", "is", " ", "a", " ", "sentence"]
		for (i in 0 ... wordsLen)
		{
			if (i != (wordsLen - 1))
			{
				words.insert(i + j, ' ');
				j++;
			}
		}

		// Reusable variables
		//var char:String;
		//var charCode:Int;
		//var letter:Letter;
		var currLineText = '';
		var currLineWidth = 0;
		var currWord = '';
		var currWordWidth = 0;
		var isBreakFirst = false;
		var isBreakLater = false;
		var isLastWord = false;
		var reg = ~/[\n\r]/; // gets first occurence of line breaks
		var i = 0;
		var len = words.length;
		var lastLetterPadding = 0;

		while (i < words.length)
		{
			var thisWord = words[i];
			lastLetterPadding = 0;

			// If newline character exists, split the word for further
			// checking in the subsequent loops.
			if (reg.match(thisWord))
			{
				var splitIndex = reg.matchedPos();
				var splitWords = reg.split(thisWord);
				var firstWord = splitWords[0];
				var remainder = splitWords[1];

				// Replace current word with the splitted word
				words[i] = thisWord = firstWord;

				// Insert the remainder of the word into next index
				// and we'll check it again later.
				words.insert(i + 1, remainder);

				// Flag to break AFTER we process this word.
				isBreakLater = true;
			}
			else if (i == words.length - 1)
			{
				// If the word need not be split, then check if this
				// is the last word. If yes, then we can finalise this
				// line at the end.
				isLastWord = true;
			}

			// If this is a non-space word, let's process it.
			if (thisWord != ' ')
			{
				currWord = thisWord;
				currWordWidth = Std.int(font.width(fontSize, currWord));

				/*for (charIndex in 0 ... thisWord.length)
				{
					char = thisWord.charAt(charIndex);
					charCode = Utf8.charCodeAt(char, 0);

					// Get letter data based on the charCode key
					letter = font.letters.get(charCode);

					// If the letter data exists, append it to the current word.
					// Then add the letter's padding to the overall word width.
					// If the letter data doesn't exist, then just skip without
					// altering the currWord or currWordWidth.
					if (letter != null)
					{
						currWord += char;
						currWordWidth += letter.xadvance;

						// If this is the last letter for the line, remember
						// the padding so that we can add to the currLineWidth later.
						lastLetterPadding = letter.width - letter.xadvance;
					}
				}*/
			}
			else
			{
				// For space characters, usually they have no width,
				// we have to manually add the .spaceWidth value.
				currWord = ' ';
				currWordWidth = Std.int(font.width(fontSize, ' '));
				//currWordWidth = font.spaceWidth;
			}

			// After adding current word to the line, did it pass
			// the text width? If yes, flag to break. Otherwise,
			// just update the current line.
			if ((currLineWidth + currWordWidth) <= boxWidth)
			{
				currLineText += currWord; // Add the word to the full line
				currLineWidth += currWordWidth; // Update the full width of the line
			}
			else
			{
				isBreakFirst = true;
			}

			// If we need to break the line first, add the
			// current line to the array first, then add the
			// current word to the next line.
			if (isBreakFirst || isLastWord)
			{
				// Add padding so the last letter doesn't get chopped off
				//currLineWidth += lastLetterPadding;

				// Add current line (sans current word) to array
				lines.push({
					text: currLineText,
					width: currLineWidth
				});

				// If this isn't the last word, then begin the next
				// line with the current word.
				if (!isLastWord)
				{
					// If current word is a proper word:
					if (currWord != ' ')
					{
						// Next line begins with the current word
						currLineText = currWord;
						currLineWidth = currWordWidth;
					}
					else
					{
						// Ignore spaces; Reset the next line.
						currLineText = '';
						currLineWidth = 0;
					}

					isBreakFirst = false;
				}
				else if (isBreakFirst)
				{
					// If this is the last word, then just push it
					// to the next line and finish up.
					lines.push({
						text: currWord,
						width: currWordWidth
					});
				}

				// trim the text at start and end of the last line
				//if (trimAll) trim1.replace(lines[lines.length-1].text, '');
				if (trimAll) 
				{
					var position = lines.length - 1;
					
					//lines[position].text = StringTools.trim(lines[position].text);
					lines[position].text = trim1.replace(lines[position].text, '');
					lines[position].width = Std.int(font.width(fontSize, lines[position].text));
				}
			}

			// If we need to break the line AFTER adding the current word
			// to the current line, do it here.
			if (isBreakLater)
			{
				// Add padding so the last letter doesn't get chopped off
				//currLineWidth += lastLetterPadding;

				// add current line to array, whether it has already
				// previously been broken to new line or not.

				lines.push({
					text: currLineText,
					width: currLineWidth
				});

				// Start next line afresh.
				currLineText = '';
				currLineWidth = 0;

				isBreakLater = false;
			}

			// move to next word
			currWord = '';
			currWordWidth = 0;

			// Move to next iterator.
			i++;
		}

		textProcessed = true;
		//boxHeight = Std.int(lines.length * ((font.lineHeight * scaleY) + lineSpacing));
		boxHeight = lines.length * (fontHeight + lineSpacing);
	}	

	override function innerRender(g:Graphics):Void 
	{
		// For every letter in the text, render directly on buffer.
		// In best case scenario where text doesn't change, it may be better to
		// Robert says Kha can handle it.

		// Reset cursor position
		cursor.x = 0;
		cursor.y = 0;		

		for (line in lines)
		{
			// NOTE:
			// Based on width and each line.width, we just
			// offset the starting cursor.x to make it look like
			// it's aligned to the correct side.
			if (boxWidth > 0)
			{
				switch (align)
				{
					case TextAlign.Left: cursor.x = 0;
					case TextAlign.Right: cursor.x = boxWidth - line.width;
					case TextAlign.Center: cursor.x = (boxWidth / 2) - (line.width / 2);
				}
			}						
			
			g.font = font;
			g.fontSize = fontSize;
			g.drawString(line.text, x + cursor.x, y + cursor.y);  

			/*var lineText:String = line.text;
			var lineTextLen:Int = lineText.length;

			for (i in 0 ... lineTextLen)
			{
				var char = lineText.charAt(i); // get letter
				var charCode = Utf8.charCodeAt(char, 0); // get letter id
				var letter = font.letters.get(charCode); // get letter data

				// If the letter data exists, then we will render it.
				if (letter != null)
				{
					// If the letter is NOT a space, then render it.
					if (letter.id != spaceCharCode)
					{
						letterWidthScaled = letter.width * scaleX;
						letterHeightScaled = letter.height * scaleY;
						
						g.drawScaledSubImage(
							font.image,
							letter.x,
							letter.y,
							letter.width,
							letter.height,
							x + cursor.x + letter.xoffset * scaleX + (flip.x ? letterWidthScaled : 0) - cx,
							y + cursor.y + letter.yoffset * scaleX + (flip.y ? letterHeightScaled : 0) - cy,
							flip.x ? -letterWidthScaled : letterWidthScaled,
							flip.y ? -letterHeightScaled : letterHeightScaled);

						// Add kerning if it exists. Also, we don't have to
						// do this if we're already at the last character.
						if (i != lineTextLen)
						{
							// Get next char's code
							var charNext = lineText.charAt(i + 1);
							var charCodeNext = Utf8.charCodeAt(charNext, 0);

							// If kerning data exists, adjust the cursor position.
							if (letter.kernings.exists(charCodeNext))							
								cursor.x += letter.kernings.get(charCodeNext) * scaleX;							
						}

						// Move cursor to next position, with padding.
						cursor.x += (letter.xadvance + font.outline) * scaleX;
					}
					else
					{
						// If this is a space character, move cursor
						// without rendering anything.
						cursor.x += font.spaceWidth * scaleX;
					}
				}
				else
					// Don't render anything if the letter data doesn't exist.
					trace('letter data doesn\'t exist: $char');
			}*/

			// After we finish rendering this line,
			// move on to the next line.
			//cursor.y += (font.lineHeight * scaleY) + lineSpacing;
			cursor.y += fontHeight + lineSpacing;
		}		
	}    	
	
	public function set_text(value:String):String
	{
		textProcessed = false;
		
		return text = value;
	}
	
	public function set_boxWidth(value:Int):Int
	{
		textProcessed = false;
		
		return boxWidth = value;
	}
	
	public function set_fontSize(value:Int):Int
	{
		fontHeight = Std.int(font.height(value));
		textProcessed = false;
		
		return fontSize = value;
	}
}