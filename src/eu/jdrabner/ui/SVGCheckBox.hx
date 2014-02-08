
package eu.jdrabner.ui;

import flash.display.Sprite;
import format.SVG;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.display.Shape;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.Font;
import openfl.Assets;

/**
 * SVG based checkbox with a label right to it.
 * */
class SVGCheckBox extends Sprite
{
    public var id :Int = -1;

    private var _fontColor         :Int;
    private var _fontHoverColor    :Int;
    private var _checked           :Bool = false;

    private var _caption :TextField;

    private var _mouseArea      :Sprite;
    private var _unNormalLayer  :Bitmap;
    private var _unHoverLayer   :Bitmap;
    private var _normalLayer    :Bitmap;
    private var _hoverLayer     :Bitmap;

    /**
     * Constructor. Renders the passed SVG images and builds the final checkbox graphics. 
     * @NOTE    The clickable area assumes a rectangular image format.
     * @param p_width           The target width of the whole checkbox (with label). 
     * @param p_height          The target height of the whole checkbox (with label). 
     * @param p_buttonSpace     The percentage of the width the checkbox button shall have. (0 .. 1)
     * @param p_caption         The caption of the checkbox. Can be in HTML format.
     * @param p_fontColor       The color of the font.
     * @param p_font            The path to the font file.
     * @param p_svgUnNormalName The name of the SVG image (WITHOUT ".svg") for the unchecked normal state. 
     * @param p_svgUnHoverName  The name of the SVG image (WITHOUT ".svg") for the unchecked hover state. 
     * @param p_svgNormalName   The name of the SVG image (WITHOUT ".svg") for the checked normal state. 
     * @param p_svgHoverName    The name of the SVG image (WITHOUT ".svg") for the checked hover state. 
     * */
    public function new(p_width :Int, p_height :Int, p_buttonSpace :Float, p_caption :String, 
        p_fontColor :Int, p_fontHoverColor :Int, p_font :String,
        p_svgUnNormalName :String, p_svgUnHoverName :String, p_svgNormalName :String, p_svgHoverName :String)
    {
        super();

        _fontColor = p_fontColor;
        _fontHoverColor = p_fontHoverColor;

        // Mouse area
        _mouseArea = new Sprite();
        _mouseArea.graphics.beginFill(0xFFFFFF, 0.0);
        _mouseArea.graphics.drawRect(0, 0, p_width, p_height);
        _mouseArea.graphics.endFill();
        addChild(_mouseArea);

        // Listeners
        _mouseArea.addEventListener(MouseEvent.CLICK, handleMouseClick);
        _mouseArea.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
        _mouseArea.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);

        // Unchecked Normal layer
        var buttonWidth :Int = Std.int(p_width * p_buttonSpace);
        var tempSVG :SVG = new SVG(openfl.Assets.getText(p_svgUnNormalName + ".svg"));
        var tempData :BitmapData = new BitmapData(buttonWidth, p_height, true, 0x00000000);
        var tempSprite :Sprite = new Sprite();
        tempSVG.render(tempSprite.graphics, 0, 0, buttonWidth, p_height);
        tempData.draw(tempSprite);
        _unNormalLayer = new Bitmap(tempData, flash.display.PixelSnapping.NEVER, false);
        addChild(_unNormalLayer);

        // Unchecked Hover layer
        tempSVG = new SVG(openfl.Assets.getText( p_svgUnHoverName + ".svg"));
        tempData = new BitmapData(buttonWidth, p_height, true, 0x00000000);
        tempSprite.graphics.clear();
        tempSVG.render(tempSprite.graphics, 0, 0, buttonWidth, p_height);
        tempData.draw(tempSprite);
        _unHoverLayer = new Bitmap(tempData, flash.display.PixelSnapping.NEVER, false);
        addChild(_unHoverLayer);
        _unHoverLayer.visible = false;

        // Checked Normal layer
        var tempSVG :SVG = new SVG(openfl.Assets.getText(p_svgNormalName + ".svg"));
        var tempData :BitmapData = new BitmapData(buttonWidth, p_height, true, 0x00000000);
        var tempSprite :Sprite = new Sprite();
        tempSVG.render(tempSprite.graphics, 0, 0, buttonWidth, p_height);
        tempData.draw(tempSprite);
        _normalLayer = new Bitmap(tempData, flash.display.PixelSnapping.NEVER, false);
        addChild(_normalLayer);
        _normalLayer.visible = false;

        // Checked Hover layer
        tempSVG = new SVG(openfl.Assets.getText( p_svgHoverName + ".svg"));
        tempData = new BitmapData(buttonWidth, p_height, true, 0x00000000);
        tempSprite.graphics.clear();
        tempSVG.render(tempSprite.graphics, 0, 0, buttonWidth, p_height);
        tempData.draw(tempSprite);
        _hoverLayer = new Bitmap(tempData, flash.display.PixelSnapping.NEVER, false);
        addChild(_hoverLayer);
        _hoverLayer.visible = false;

        // Add caption
        _caption = new TextField();
        _caption.embedFonts = true;
        _caption.wordWrap = true;
        _caption.multiline = true;
        _caption.selectable = false;
        _caption.mouseEnabled = false;
        _caption.width = p_width * (1.0 - p_buttonSpace - 0.06);
        _caption.x = p_width * (p_buttonSpace + 0.06);
        var font :flash.text.Font = Assets.getFont(p_font); 
        var format :TextFormat = new TextFormat(font.fontName, p_height * 0.45, p_fontColor, true, false);
        format.align = flash.text.TextFormatAlign.LEFT;
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

    /**
     * @param p_checked If the box should be checked or not.
     */
    public function setChecked(p_checked :Bool) :Void 
    {
        _checked = p_checked;

        var hovered :Bool = _unHoverLayer.visible || _hoverLayer.visible;

        // Show correct state - mind hovering
        if (_checked)
        {
            _unNormalLayer.visible = false;
            _unHoverLayer.visible = false;
            _normalLayer.visible = !hovered;
            _hoverLayer.visible = hovered;
        }
        else
        {
            _unNormalLayer.visible = !hovered;
            _unHoverLayer.visible = hovered;
            _normalLayer.visible = false;
            _hoverLayer.visible = false;
        }
    }

    /**
     * @return True if this checkbox is checked.
     */
    public function getChecked() :Bool
    {
        return _checked;
    }

    /**
     * Shows hover layer.svg
     * */
    private function handleMouseOver(p_mouseEvent :MouseEvent) :Void
    {
        _unNormalLayer.visible = false;
        _unHoverLayer.visible = !_checked;
        _normalLayer.visible = false;
        _hoverLayer.visible = _checked;

        // Change font color
        var text :String = _caption.htmlText;
        _caption.htmlText = "  ";
        var textFormat :TextFormat = _caption.defaultTextFormat;
        textFormat.color = _fontHoverColor;
        _caption.htmlText = text;
        _caption.setTextFormat(textFormat);
    }

    /**
     * Hides hover layer.svg
     * */
    private function handleMouseOut(p_mouseEvent :MouseEvent) :Void
    {
        _unNormalLayer.visible = !_checked;
        _unHoverLayer.visible = false;
        _normalLayer.visible = _checked;
        _hoverLayer.visible = false;

        // Change font color
        var text :String = _caption.htmlText;
        _caption.htmlText = "  ";
        var textFormat :TextFormat = _caption.defaultTextFormat;
        textFormat.color = _fontColor;
        _caption.htmlText = text;
        _caption.setTextFormat(textFormat);
    }


    /**
     * Shows clicked effect for some time. 
     * */
    private function handleMouseClick(p_mouseEvent :MouseEvent) :Void
    {
        setChecked(!getChecked());
    }
}