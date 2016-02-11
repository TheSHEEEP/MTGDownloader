
package eu.jdrabner.ui;

import flash.display.PixelSnapping;
import flash.events.TextEvent;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.text.Font;
import openfl.Assets;

/**
 * A single-line input text field that has a fixed size and and a background.
 */
class InputTextField extends Sprite
{
    public static inline var    INPUT_TYPE_INT      :Int = 0;
    public static inline var    INPUT_TYPE_FLOAT    :Int = 1;
    public static inline var    INPUT_TYPE_TEXT     :Int = 2;

    public var id :Int = -1;

    private var _background :Bitmap;

    private var _label   :TextField;
    private var _text    :TextField;

    private var _type       :Int;
    private var _lastText   :String = "";

    /**
     * Constructor.
     * @param  p_width         The width of the InputTextField (total, label + input).
     * @param  p_height        The height of the InputTextField.
     * @param  p_inputPart     The part of the width that is reserved for the input field. (0 .. 1)
     * @param  p_bgColor       The color of the text field's background.
     * @param  p_bgColorBorder The color of the border of the text field's background.
     * @param  p_type          The type of input. This is used to check the input for wrong characters.
     * @param  p_fontColor     The color of the font.
     * @param  p_fontName      The name of the font to use.
     * @param  p_caption       The label text left of the inout field.
     * @param  p_defaultText   The starting text. Use htmlText at your own risk.
     */
    public function new(p_width :Int, p_height :Int, p_inputPart :Float, p_bgColor :Int, p_bgColorBorder :Int,
                        p_type :Int, p_fontColor :Int, p_fontName :String, p_caption :String, p_defaultText :String = "")
    {
        super();

        _type = p_type;

        // Create the label
        var font :Font = Assets.getFont(p_fontName);
        var textFormat :TextFormat = new TextFormat();
        textFormat.bold = true;
        textFormat.size = Std.int(0.5 * p_height);
        textFormat.font = font.fontName;
        textFormat.color = p_fontColor;

        _label = new TextField();
        _label.embedFonts = true;
        _label.selectable = false;
        _label.mouseEnabled = false;
        _label.defaultTextFormat = textFormat;
        _label.text = p_caption;
        _label.width = (1.0 - p_inputPart - 0.05) * p_width;
        _label.height = _label.textHeight * 1.03;
        _label.y = p_height / 2 - _label.height / 2;
        addChild(_label);

        // Background
        var tempSprite :Sprite = new Sprite();
        tempSprite.graphics.lineStyle(3, p_bgColorBorder, 1.0);
        tempSprite.graphics.beginFill(p_bgColor, 1.0);
        tempSprite.graphics.drawRect(0, 0, p_inputPart * p_width, p_height);
        tempSprite.graphics.endFill();
        var data :BitmapData = new BitmapData(Std.int(p_inputPart * p_width) + 1, p_height + 1, true, 0xFFFFFFFF);
        data.draw(tempSprite);
        _background = new Bitmap(data, PixelSnapping.NEVER, true);
        _background.x = (1.0 - p_inputPart) * p_width;
        addChild(_background);

        // TextField
        var format :TextFormat = new TextFormat(p_fontName, Std.int(p_height * 0.7), p_fontColor, false);
        _text = new TextField();
        _text.multiline = false;
        _text.wordWrap = false;
        _text.embedFonts = true;
        _text.type = TextFieldType.INPUT;
        _text.setTextFormat(format);
        _text.defaultTextFormat = format;
        _text.width = 0.92 * p_width * p_inputPart;
        _text.text = "sdad";
        _text.height = _text.textHeight * 1.05;
        _text.text = p_defaultText;
        _text.x = (1.0 - p_inputPart) * p_width + 0.04 * p_inputPart * p_width;
        _text.y = 0.03 * p_height;
        #if flash
            _text.y -= 0.05 * p_height;
        #end
        addChild(_text);
        _lastText = _text.text;

        // Add listeners
        _text.addEventListener(TextEvent.TEXT_INPUT, handleTextInput);
        _text.addEventListener(Event.CHANGE, handleTextInput2);
    }

    /**
     * Sets the new text.
     * @NOTE: Does NOT perform any type checks.
     */
    public function setText(p_text :String) :Void
    {
        _text.text = p_text;
    }

    /**
     * @return The current text.
     */
    public function getText() :String
    {
        return _text.text;
    }

    /**
     * Will check the input for correct format and dispatch a change event.
     */
    private function handleTextInput2(p_event :Event) :Void
    {
        handleTextInput(null);
    }

    /**
     * Will check the input for correct format and dispatch a change event.
     */
    private function handleTextInput(p_event :TextEvent) :Void
    {
        // Check input for correct format
        switch (_type)
        {
            case INPUT_TYPE_INT:
                var reg :EReg = ~/[^0-9]+/;
                if (reg.match(_text.text))
                {
                    _text.text = _lastText;
                    return;
                }

            case INPUT_TYPE_FLOAT:
                var reg :EReg = ~/^[0-9]+\.?[0-9]*$/;
                if (!reg.match(_text.text))
                {
                    _text.text = _lastText;
                    return;
                }

            case INPUT_TYPE_TEXT:
                // Nothing to do here
        }

        _lastText = _text.text;

        // Dispatch change event
        dispatchEvent(new Event(Event.CHANGE));
    }

}
