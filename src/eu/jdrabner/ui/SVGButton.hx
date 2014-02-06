
package eu.jdrabner.ui;

import flash.display.Sprite;
import format.SVG;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.display.Shape;
import flash.utils.Timer;
import flash.events.TimerEvent;

/**
 * This class uses up to four (normal, click, hover, disabled) SVG images to define a button.
 * When created, the user has to pass a size and the SVG images are rendered once in that size as BitmapData. 
 * This prevents performance problems when using SVG. 
 * */
class SVGButton extends Sprite
{
    private var _id     :Int = -1;

    private var _mouseArea      :Sprite;
    private var _normalLayer    :Bitmap;
    private var _clickLayer     :Bitmap;
    private var _hoverLayer     :Bitmap;
    private var _disabledLayer  :Bitmap;

    /**
     * Constructor. Renders the passed SVG images and builds the final button graphics. 
     * @NOTE    The clickable area assumes a rectangular image format.
     * @param p_width   The target width of the button. 
     * @param p_height  The target height of the button. 
     * @param p_svgNormalName   The name of the SVG image (WITHOUT ".svg") for the normal state. 
     * @param p_svgClickName    The name of the SVG image (WITHOUT ".svg") for the clicked state. 
     * @param p_svgHoverName    The name of the SVG image (WITHOUT ".svg") for the hover state. 
     * @param p_svgDisabledName The name of the SVG image (WITHOUT ".svg") for the disabled state. 
     * */
    public function new(p_width :Int, p_height :Int, p_svgNormalName :String, p_svgClickName :String,
                        p_svgHoverName :String = "", p_svgDisabledName :String = "")
    {
        super();

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

        // Normal layer
        var tempSVG :SVG = new SVG(openfl.Assets.getText(p_svgNormalName + ".svg"));
        var tempData :BitmapData = new BitmapData(p_width, p_height, true, 0x00000000);
        var tempSprite :Sprite = new Sprite();
        tempSVG.render(tempSprite.graphics, 0, 0, p_width, p_height);
        tempData.draw(tempSprite);
        _normalLayer = new Bitmap(tempData, flash.display.PixelSnapping.NEVER, false);
        addChild(_normalLayer);

        // Hover layer
        if (p_svgHoverName != "")
        {
            tempSVG = new SVG(openfl.Assets.getText( p_svgHoverName + ".svg"));
            tempData = new BitmapData(p_width, p_height, true, 0x00000000);
            tempSprite.graphics.clear();
            tempSVG.render(tempSprite.graphics, 0, 0, p_width, p_height);
            tempData.draw(tempSprite);
            _hoverLayer = new Bitmap(tempData, flash.display.PixelSnapping.NEVER, false);
            addChild(_hoverLayer);
            _hoverLayer.visible = false;
        }

        // Clicked layer
        tempSVG = new SVG(openfl.Assets.getText(p_svgClickName + ".svg"));
        tempData = new BitmapData(p_width, p_height, true, 0x00000000);
        tempSprite.graphics.clear();
        tempSVG.render(tempSprite.graphics, 0, 0, p_width, p_height);
        tempData.draw(tempSprite);
        _clickLayer = new Bitmap(tempData, flash.display.PixelSnapping.NEVER, false);
        addChild(_clickLayer);
        _clickLayer.visible = false;

        // Disabled layer
        if (p_svgDisabledName != "")
        {
            tempSVG = new SVG(openfl.Assets.getText(p_svgDisabledName + ".svg"));
            tempData = new BitmapData(p_width, p_height, true, 0x00000000);
            tempSprite.graphics.clear();
            tempSVG.render(tempSprite.graphics, 0, 0, p_width, p_height);
            tempData.draw(tempSprite);
            _disabledLayer = new Bitmap(tempData, flash.display.PixelSnapping.NEVER, false);
            addChild(_disabledLayer);
            _disabledLayer.visible = false;
        }
    }

    /**
     * Sets the new ID of the button. 
     * */
    public function setId(p_id :Int) :Void
    {
        _id = p_id;
    }

    /**
     * @return  The ID of this button. 
     * */
    public function getId() :Int
    {
        return _id;
    }

    /**
     * Shows hover layer.svg
     * */
    private function handleMouseOver(p_mouseEvent :MouseEvent) :Void
    {
        if (_hoverLayer != null)
        {
            _hoverLayer.visible = true;
        }
        _normalLayer.visible = false;
    }

    /**
     * Hides hover layer.svg
     * */
    private function handleMouseOut(p_mouseEvent :MouseEvent) :Void
    {
        if (_hoverLayer != null)
        {
            _hoverLayer.visible = false;
        }
        _normalLayer.visible = true;
    }


    /**
     * Shows clicked effect for some time. 
     * */
    private function handleMouseClick(p_mouseEvent :MouseEvent) :Void
    {
        if (_hoverLayer != null)
        {
            _hoverLayer.visible = false;
        }

        _clickLayer.visible = true;
        _normalLayer.visible = false;

        // Timer to hide
        var timer:Timer = new Timer(333, 1);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, hideClickLayer);
        timer.start();
    }
    
    /**
     * Hides clicked effect.
     * */
    private function hideClickLayer(p_timerEvent :TimerEvent) :Void
    {
        p_timerEvent.target.removeEventListener(TimerEvent.TIMER_COMPLETE, hideClickLayer);

        _clickLayer.visible = false;
        _normalLayer.visible = true;
    }

}