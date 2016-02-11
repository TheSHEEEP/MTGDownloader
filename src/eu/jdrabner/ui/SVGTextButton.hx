
package eu.jdrabner.ui;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.Font;
import openfl.Assets;

/**
 * SVG based button with a text layer.
 * */
class SVGTextButton extends SVGButton
{
    private var _caption :TextField;

    /**
     * Constructor. Renders the passed SVG images and builds the final button graphics.
     * @NOTE    The clickable area assumes a rectangular image format.
     * @param p_width   The target width of the button.
     * @param p_height  The target height of the button.
     * @param p_caption The caption of the button. Can be in HTML format.
     * @param p_fontColor     The color of the font.
     * @param p_font          The path to the font file.
     * @param p_svgNormalName   The name of the SVG image (WITHOUT ".svg") for the normal state.
     * @param p_svgClickName    The name of the SVG image (WITHOUT ".svg") for the clicked state.
     * @param p_svgHoverName    The name of the SVG image (WITHOUT ".svg") for the hover state.
     * @param p_svgDisabledName The name of the SVG image (WITHOUT ".svg") for the disabled state.
     * */
    public function new(p_width :Int, p_height :Int, p_caption :String, p_fontColor :Int, p_font :String,
        p_svgNormalName :String, p_svgClickName :String, p_svgHoverName :String = "", p_svgDisabledName :String = "")
    {
        super(p_width, p_height, p_svgNormalName, p_svgClickName, p_svgHoverName, p_svgDisabledName);

        // Add caption
        _caption = new TextField();
        _caption.embedFonts = true;
        _caption.wordWrap = true;
        _caption.multiline = true;
        _caption.selectable = false;
        _caption.mouseEnabled = false;
        _caption.width = p_width * 0.92;
        _caption.x = 0.04 * p_width;
        var font :flash.text.Font = Assets.getFont(p_font);
        var format :TextFormat = new TextFormat(font.fontName, Std.int(p_height * 0.35), p_fontColor, true, false);
        format.align = flash.text.TextFormatAlign.CENTER;
        _caption.setTextFormat(format);
        _caption.defaultTextFormat = format;
        _caption.htmlText = p_caption;
        _caption.height = _caption.textHeight * 1.03;
        #if !flash
            _caption.height = _caption.textHeight * 1.03;
            _caption.y = 0.04 * p_height + (0.92 * p_height) / 2 - _caption.height / 2;
        #else
            // Flash's textHeight is even more off when there are multiple lines...
            _caption.height = _caption.textHeight * _caption.numLines;
            _caption.y = (0.92 * p_height) / 2 - _caption.height / 4 - 0.05 * p_height;
        #end
        addChildAt(_caption, numChildren);
    }

    /**
     * Sets the new caption.
     * */
    public function setCaption(p_caption :String) :Void
    {
        _caption.htmlText = p_caption;
    }

    /**
     * @return  The caption of the button (in HTML format, if it was set as such)
     * */
    public function getCaption() :String
    {
        return _caption.htmlText;
    }
}
