
package eu.jdrabner.ui;

import com.rogueassembly.terraingen.ui.SVGButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.Font;
import flash.text.TextFormatAlign;
import flash.Vector;
import format.SVG;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Shape;
import flash.utils.Timer;
import flash.events.TimerEvent;
import openfl.Assets;

/**
 * This class uses up to three (normal, click, hover) SVG images to define a left and a right button.
 * When created, the user has to pass a size and the SVG images are rendered once in that size as BitmapData. 
 * This prevents performance problems when using SVG. 
 *
 * Between the two buttons, there is a textfield displaying the current selection.
 * */
class SVGSelector extends Sprite
{
    public var id :Int = -1;

    private var _values             :Vector<String>;
    private var _currentSelection   :Int;

    private var _leftBtn     :SVGButton;
    private var _caption     :TextField;
    private var _rightBtn    :SVGButton;

    /**
     * Constructor. Renders the passed SVG images and builds the final button graphics. 
     * @NOTE    The clickable area assumes a rectangular image format.
     * @param p_width   The target width of the button. 
     * @param p_height  The target height of the button. 
     * */
    public function new(p_width :Int, p_height :Int, p_values :Vector<String>, p_initialSelection :Int)
    {
        super();

        _values = p_values;
        _currentSelection = p_initialSelection;

        // Left button
        _leftBtn = new SVGButton(cast p_width * 0.15, p_height, "left_normal", "left_click", "left_hover");
        _leftBtn.addEventListener(MouseEvent.CLICK, handleLeftClick);
        addChild(_leftBtn);

        // Caption
        _caption = new TextField();
        var font :Font = Assets.getFont("fonts/OxygenMono-Regular.ttf"); 
        var format :TextFormat = new TextFormat(font.fontName, _leftBtn.height * 0.5, 0xFFFFFF, true, false);
        format.align = TextFormatAlign.CENTER;
        _caption.embedFonts = true;
        _caption.defaultTextFormat = format;
        _caption.setTextFormat(format);
        _caption.text = _values[_currentSelection];
        _caption.height = _leftBtn.height;
        _caption.width = 0.64 * p_width;
        _caption.x = _leftBtn.x + _leftBtn.width + 0.03 * p_width;
        _caption.y = _leftBtn.y + p_height * 0.1;
        addChild(_caption);

        // Right button
        _rightBtn = new SVGButton(cast p_width * 0.15, p_height, "right_normal", "right_click", "right_hover");
        _rightBtn.addEventListener(MouseEvent.CLICK, handleRightClick);
        _rightBtn.x = _caption.x + _caption.width + 0.03 * p_width;
        addChild(_rightBtn);
    }

    /**
     * @param p_index     The new selection index.
     * @NOTE     Does NOT perform boundary checks.
     */
    public function setCurrentSelectionIndex(p_index :Int) :Void
    {
        _currentSelection = p_index;
        _caption.htmlText = _values[_currentSelection];
    }

    /**
     * @return The (0-based) index of the current selection.
     */
    public function getCurrentSelectionIndex() :Int
    {
        return _currentSelection;
    }

    /**
     * @param p_cap The new caption for the current index.
     */
    public function setCaption(p_cap :String) :Void
    {
        _caption.htmlText = p_cap;

        _values[_currentSelection] = p_cap;
    }

    /**
     * @return The current caption.
     */
    public function getCaption() :String
    {
        return _caption.text;
    }

    /**
     * @param p_values The new Vector of possible values.
     */
    public function setValues(p_values :Vector<String>)
    {
        // Change current selection if the new Vector is smaller
        if (_currentSelection >= p_values.length)
        {
            _currentSelection = p_values.length - 1;
        }
        _caption.htmlText = p_values[_currentSelection];
        _values = p_values;
    }

    /**
     * Shows hover layer.svg
     * */
    private function handleLeftClick(p_mouseEvent :MouseEvent) :Void
    {
        // Change selection
        _currentSelection--;
        if (_currentSelection < 0) _currentSelection = _values.length - 1;
        _caption.htmlText = _values[_currentSelection];

        // Dispatch change event
        dispatchEvent(new Event(Event.CHANGE));
    }

    /**
     * Shows hover layer.svg
     * */
    private function handleRightClick(p_mouseEvent :MouseEvent) :Void
    {
        // Change selection
        _currentSelection++;
        if (_currentSelection >= _values.length) _currentSelection = 0;
        _caption.htmlText = _values[_currentSelection];

        // Dispatch change event
        dispatchEvent(new Event(Event.CHANGE));
    }

}