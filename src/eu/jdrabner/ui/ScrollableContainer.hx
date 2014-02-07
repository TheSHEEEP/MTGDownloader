
package eu.jdrabner.ui;

import flash.display.Sprite;
import format.SVG;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Shape;
import flash.display.DisplayObject;

/**
 * This container will automatically position elements that are given to it.
 * When a row is full, the new element will be put into the next row.
 * @IMPORTANT: This container assumes that all elements are as big as the first one!
 *             If this is not the case, the results will probably be wrong.
 */
class ScrollableContainer extends Sprite
{
    private var _background         :Sprite;
    private var _scrollBar          :Sprite;
    private var _childContainer     :Sprite;

    private var _scrollBarColor          :Int;
    private var _scrollBarColorHover     :Int;

    private var _margin :Float = 0.0;

    private var _children     :Array<DisplayObject>;
    private var _dragging     :Bool = false;

    /**
     * Constructor.
     * @param  p_width                  The width of the cintainer. In pixels.
     * @param  p_height                 The height of the cintainer. In pixels.
     * @param  p_margin                 The margin of empty space the children will have to the border of the container. (0 .. 1)
     * @param  p_scrollBarColor         The color of the scroll bar.
     * @param  p_scrollBarColorHover    The color of the scroll bar when hovered over.
     */
    public function new(p_width :Float, p_height :Float, p_margin :Float, p_scrollBarColor :Int, p_scrollBarColorHover :Int)
    {
        super();

        _margin = p_margin;
        _scrollBarColor = p_scrollBarColor;
        _scrollBarColorHover = p_scrollBarColorHover;


        // Create background
        _background = new Sprite();
        _background.graphics.beginFill(0xFFFFFF, 0.0);
        _background.graphics.drawRect(0.0, 0.0, p_width, p_height);
        _background.graphics.endFill();
        addChild(_background);

        // Create scroll bar
        _scrollBar = new Sprite();
        _scrollBar.graphics.beginFill(p_scrollBarColor, 1.0);
        _scrollBar.graphics.drawRoundRect(0, 0, 0.03 * p_width, p_height, 0.025 * p_width, 0.035 * p_height);
        _scrollBar.graphics.endFill();
        _scrollBar.x = 0.95 * p_width;
        addChild(_scrollBar);

        // Create child container
        _childContainer = new Sprite();
        addChild(_childContainer);
        _children = new Array<DisplayObject>();

        // Add scrolling listeners
        _scrollBar.addEventListener(MouseEvent.MOUSE_DOWN, handleDragStart);
        _scrollBar.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
        _scrollBar.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);

        // Add added listener
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /**
     * Will add a mouse listeners to the stage.
     */
    private function init(p_event :Event) :Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        stage.addEventListener(MouseEvent.MOUSE_UP, handleDragStop);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
    }

    /**
     * Will start the dragging.
     */
    private function handleDragStart(p_event :MouseEvent) :Void 
    {

    }

    /**
     * Will stop the dragging.
     */
    private function handleDragStop(p_event :MouseEvent) :Void 
    {

    }

    /**
     * Will update the dragging and the childrens' positions.
     */
    private function handleMouseMove(p_event :MouseEvent) :Void 
    {

    }

    /**
     * @return the perfect height for the scroll bar.
     */
    private function calculateScrollBarHeight() :Float 
    {
        if (_childContainer.height > _background.height)
        {
            return _background.height / (_childContainer.height / _background.height);
        }
        return _background.height;
    }

    /**
     * Will update the dragging and the childrens' positions.
     */
    private function handleMouseOver(p_event :MouseEvent) :Void 
    {
        _scrollBar.graphics.clear();
        _scrollBar.graphics.beginFill(_scrollBarColorHover, 1.0);
        _scrollBar.graphics.drawRoundRect(0, 0, 
                                            0.03 * _background.width, calculateScrollBarHeight(), 
                                            0.03 * _background.width, 0.03 * _background.width);
        _scrollBar.graphics.endFill();
    }

    /**
     * Will update the dragging and the childrens' positions.
     */
    private function handleMouseOut(p_event :MouseEvent) :Void 
    {
        _scrollBar.graphics.clear();
        _scrollBar.graphics.beginFill(_scrollBarColor, 1.0);
        _scrollBar.graphics.drawRoundRect(0, 0, 
                                            0.03 * _background.width, calculateScrollBarHeight(), 
                                            0.03 * _background.width, 0.03 * _background.width);
        _scrollBar.graphics.endFill();
    }

    /**
     * Will add the passed child to the container.
     * @param p_child The DisplayObject to add.
     */
    public function addObject(p_child :DisplayObject) :Void 
    {
        _children.push(p_child);

        // If this is the first child, just add it
        if (_childContainer.numChildren == 0)
        {
            _childContainer.addChild(p_child);
            p_child.x = _margin * _background.width;
            p_child.y = _margin * _background.height;
            return;
        }

        // Get the last child
        var lastChild :DisplayObject = _childContainer.getChildAt(_childContainer.numChildren - 1);

        // Position the new one right of the last child
        _childContainer.addChild(p_child);
        p_child.x = lastChild.x + lastChild.width + 0.03 * _background.width;
        p_child.y = lastChild.y;

        // If the child hits the bounds, move it to the next row
        if (p_child.x + p_child.width > (1.0 - _margin) * _background.width)
        {
            p_child.x = _margin * _background.width;
            p_child.y = lastChild.y + lastChild.height + 0.03 * _background.height;
        }

        // Adjust the height of the scroll bar
        if (_childContainer.height > _background.height)
        {
            _scrollBar.graphics.clear();
            _scrollBar.graphics.beginFill(_scrollBarColor, 1.0);
            _scrollBar.graphics.drawRoundRect(0, 0, 
                                                0.03 * _background.width, calculateScrollBarHeight(), 
                                                0.03 * _background.width, 0.03 * _background.width);
            _scrollBar.graphics.endFill();
        }
    }
}