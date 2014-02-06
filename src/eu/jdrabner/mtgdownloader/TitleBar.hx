
package eu.jdrabner.mtgDownloader;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.Font;
import flash.events.Event;
import openfl.Assets;

/**
 * The title bar!
 */
class TitleBar extends Sprite
{
    private var _title       :TextField;
    private var _textFormat  :TextFormat;
    private var _bgColor     :Int;
    private var _fontColor   :Int;
    private var _relSize     :Float;
    private var _relSizeFont :Float;
    private var _yOffset     :Float;

    /**
     * Constructor
     * @param  p_bgColor      The background color of the title.
     * @param  p_fontColor    The font color of the title.
     * @param  p_titleSizeRel The size of the title, relative to the height of the stage (0 .. 1).
     * @param  p_fontSizeRel  The size of the font, relative to the height of the title bar itself (0 .. 1).
     * @param  p_yOffset      The offset of the title. use this to adjust the title text's y position. In % of stage height (0 .. 1).
     * @param  p_font         The path to the font to use.
     */
    public function new(p_bgColor :Int, p_fontColor :Int, p_titleSizeRel :Float, p_fontSizeRel :Float, p_yOffset :Float, p_font :String)
    {
        super();

        // Remember settings
        _bgColor = p_bgColor;
        _fontColor = p_fontColor;
        _relSize = p_titleSizeRel;
        _relSizeFont = p_fontSizeRel;
        _yOffset = p_yOffset;

        // Create text format and text field
        var font :Font = Assets.getFont(p_font);
        _textFormat = new TextFormat();
        _textFormat.bold = true;
        _textFormat.size = 12;
        _textFormat.font = font.fontName;
        _textFormat.color = _fontColor;

        _title = new TextField();
        _title.embedFonts = true;
        _title.selectable = false;
        _title.mouseEnabled = false;
        addChild(_title);

        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /**
     * Initialize the title bar.
     */
    private function init(p_event :Event) :Void
    {
        // Create the background
        graphics.clear();
        graphics.beginFill(_bgColor);
        graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight * _relSize);
        graphics.endFill();

        // Initialize text field
        _textFormat.size = stage.stageHeight * _relSize * _relSizeFont;
        _title.defaultTextFormat = _textFormat;
        _title.text = _title.text;
        _title.height = _title.textHeight;
        _title.width = _title.textWidth;

        // Center title
        _title.x = stage.stageWidth / 2.0 - _title.textWidth / 2.0;
        _title.y = stage.stageHeight * _relSize * ((1.0 - _relSize) / 2.0);
        _title.y += _yOffset * stage.stageHeight;
    }

    /**
     * @param p_text  The new text of the title bar.
     */
    public function setTitleText(p_text :String) :Void 
    {
        _title.text = p_text;

        if (stage != null)
        {
            // Center title
            _title.x = stage.stageWidth / 2.0 - _title.textWidth / 2.0;
            _title.y = stage.stageHeight * _relSize * ((1.0 - _relSize) / 2.0);
            _title.y += _yOffset * stage.stageHeight;
        }
    }
}