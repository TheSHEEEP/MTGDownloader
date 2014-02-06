
package eu.jdrabner.ui;

import com.rogueassembly.terraingen.ui.SVGButton;
import com.rogueassembly.terraingen.ui.InputTextField;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.DisplayObject;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.geom.Point;
import flash.text.Font;
import openfl.Assets;
import format.SVG;
import flash.events.Event;
import flash.events.MouseEvent;

/**
 * Class that loads several SVG files to display a slider and a TextField. 
 */
class SVGSlider extends Sprite
{
    public static inline var    SLIDER_TYPE_INT       :Int = 0;
    public static inline var    SLIDER_TYPE_FLOAT     :Int = 1;
    
    public var id :Int = -1;

    private var _sliderLayer    :Bitmap;
    private var _button         :SVGButton;
    private var _textField      :InputTextField;

    private var _type   :Int;
    private var _min    :Float;
    private var _max    :Float;
    private var _val    :Float;

    private var _dragging   :Bool = false;

    /**
     * Constructor. Renders the passed SVG images and builds the final button graphics. 
     * @param p_width           The target width of the slider + text. 
     * @param p_height          The target height of the slider + text. 
     * @param p_percentage      The percentage of the width the slider will occupy (0.0 - 1.0). The rest will be the text.
     * @param p_type            The type of the slider (int or float). 
     * @param p_valMin          The minimal value of the slider. 
     * @param p_valMax          The maximal value of the slider.
     * @param p_val             The current value of the slider.
     * @param p_svgSliderName   The name of the SVG image (WITHOUT ".svg") for the slider background.
     * @param p_svgNormalName   The name of the SVG image (WITHOUT ".svg") for the button normal state. 
     * @param p_svgClickName    The name of the SVG image (WITHOUT ".svg") for the button clicked state. 
     * @param p_svgHoverName    The name of the SVG image (WITHOUT ".svg") for the button hover state. 
     * */
    public function new(p_width :Int, p_height :Int, p_percentage :Float, 
                        p_type :Int, p_valMin :Dynamic, p_valMax :Dynamic, p_val :Dynamic,
                        p_svgSliderName :String,
                        p_svgNormalName :String, p_svgClickName :String, p_svgHoverName :String = "")
    {
        super();

        // Setup value
        _type = p_type;
        _min = p_valMin;
        _max = p_valMax;
        _val = p_val;

        // Slider dimensions
        var sliderWidth :Float = p_width * p_percentage;
        var sliderHeight :Float = p_height * 0.8;

        // Slider
        var tempSVG :SVG = new SVG(openfl.Assets.getText("svg/" + p_svgSliderName + ".svg"));
        var tempData :BitmapData = new BitmapData(Std.int(sliderWidth), Std.int(sliderHeight), true, 0x00000000);
        var tempSprite :Sprite = new Sprite();
        tempSVG.render(tempSprite.graphics, 0, 0, Std.int(sliderWidth), Std.int(sliderHeight));
        tempData.draw(tempSprite);
        _sliderLayer = new Bitmap(tempData, PixelSnapping.NEVER, true);
        _sliderLayer.y = p_height / 2 - sliderHeight / 2;
        addChild(_sliderLayer);

        // Button dimensions
        var buttonHeight :Float = sliderHeight;
        var buttonWidth :Float = buttonHeight;

        // Button
        _button = new SVGButton(Std.int(buttonWidth), Std.int(buttonHeight), p_svgNormalName, p_svgClickName, p_svgHoverName);
        _button.x = ((_val - _min) / (_max - _min)) * sliderWidth - 0.5 * buttonWidth;
        _button.y = p_height / 2 - buttonHeight / 2;
        addChild(_button);
        
        // TextField dimensions
        var tfWidth :Float = p_width - sliderWidth - p_width * 0.05;
        var tfHeight :Float = sliderHeight;

        // TextField
        var font :flash.text.Font = Assets.getFont("fonts/OxygenMono-Regular.ttf");
        _textField = new InputTextField(Std.int(tfWidth), Std.int(tfHeight), 0x44444444, 0x00000000, _type, 
                                        0xFFFFFFFF, font.fontName);
        _textField.setText(_type == SLIDER_TYPE_INT? "" + Std.int(_val + 0.5) : "" + _val);
        _textField.x = _sliderLayer.x + _sliderLayer.width + p_width * 0.05;
        _textField.y = p_height / 2 - tfHeight / 2;
        addChild(_textField);

        // Listeners
        addEventListener(MouseEvent.CLICK, handleSliderClick);
        _button.addEventListener(MouseEvent.MOUSE_DOWN, handleBtnMouseDown);
        _button.addEventListener(MouseEvent.MOUSE_UP, handleBtnMouseUp);
        addEventListener(MouseEvent.MOUSE_MOVE, handleBtnMouseMove);
        _textField.addEventListener(Event.CHANGE, handleTextChange);
    }

    /**
     * Sets the current value. 
     * @NOTE: Does NOT perform boundary check. 
     */
    public function setValue(p_val :Dynamic) :Void
    {
        _val = p_val;

        // Update text
        _textField.setText(_type == SLIDER_TYPE_INT? "" + Std.int(_val + 0.5) : "" + _val);
        
        // Position the button
        _button.x = ((_val - _min) / (_max - _min)) * _sliderLayer.width - 0.5 * _button.width;
    }

    /**
     * @return The current value.
     */
    public function getValue() :Dynamic
    {
        return _type == SLIDER_TYPE_INT ? Std.int(_val + 0.5) : _val;
    }

    /**
     * Will put the slider button onto the correct position.
     */
    private function handleSliderClick(p_mouseEvent :MouseEvent) :Void
    {
        if (_dragging ||
            p_mouseEvent.target != this) return;

        var compX :Float = p_mouseEvent.localX;
        if (compX > _sliderLayer.width) compX = _sliderLayer.width;

        _button.x = compX - _button.width / 2;
        _val = _min + (_max - _min) * (compX / _sliderLayer.width);

        // Update text
        _textField.setText(_type == SLIDER_TYPE_INT? "" + Std.int(_val + 0.5) : "" + _val);

        // Dispatch change event
        dispatchEvent(new Event(Event.CHANGE));
    }

    /**
     * Will start the button dragging.
     */
    private function handleBtnMouseDown(p_mouseEvent :MouseEvent) :Void
    {
        _dragging = true;
    }

    /**
     * Will stop the button dragging.
     */
    private function handleBtnMouseUp(p_mouseEvent :MouseEvent) :Void
    {
        _dragging = false;
    }

    /**
     * Will do the button dragging. 
     */
    private function handleBtnMouseMove(p_mouseEvent :MouseEvent) :Void
    {
        if (_dragging)
        {
            var compX :Float = p_mouseEvent.localX;
            if (p_mouseEvent.target != this)
            {
                var obj :DisplayObject = p_mouseEvent.target;
                var glob :Point = obj.localToGlobal(new Point(p_mouseEvent.localX, p_mouseEvent.localY));
                var local :Point = this.globalToLocal(new Point(glob.x, glob.y));
                compX = local.x;
            }

            // Stop when dragging too far
            if (compX > _sliderLayer.width)
            {
                _button.x = _sliderLayer.width - _button.width / 2;
                _val = _max;
            }
            else if (compX < _sliderLayer.x)
            {
                _button.x = _sliderLayer.x - _button.width / 2;
                _val = _min;
            }
            else
            {
                _button.x = compX - _button.width / 2;
                _val = _min + (_max - _min) * (compX / _sliderLayer.width);
            }

            // Update text
            _textField.setText(_type == SLIDER_TYPE_INT? "" + Std.int(_val + 0.5) : "" + _val);
        
            // Dispatch change event
            dispatchEvent(new Event(Event.CHANGE));
        }
    }

    /**
     * Sets the value to the text of the text input field.
     */
    private function handleTextChange(p_event :Event) :Void
    {
        // Get the value with the correct format
        switch(_type)
        {
            case SLIDER_TYPE_INT:
                _val = Std.parseInt(_textField.getText());

            case SLIDER_TYPE_FLOAT:
                _val = Std.parseFloat(_textField.getText());
        }

        // Make sure boundaries are checked
        if (_val > _max) 
        {
            _val = _max;
        }
        if (_val < _min)
        {
            _val = _min;
        }

        // Position the button
        _button.x = ((_val - _min) / (_max - _min)) * _sliderLayer.width - 0.5 * _button.width;
        
        // Dispatch change event
        dispatchEvent(new Event(Event.CHANGE));
    }
}