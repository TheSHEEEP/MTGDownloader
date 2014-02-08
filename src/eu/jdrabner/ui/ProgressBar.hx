
package eu.jdrabner.ui;

import flash.display.Sprite;

/**
 * A progress bar!
 */
class ProgressBar extends Sprite
{
    private var _border     :Sprite;
    private var _filling    :Sprite;

    private var _fullWidth :Float = 0.0;
    
    /**
     * Constructor.
     * @param  p_width       The width of the progress bar.
     * @param  p_height      The height of the progress bar.
     * @param  p_borderColor The color of the border.
     * @param  p_fillColor   The color of the filling.
     */
    public function new(p_width :Float, p_height :Float, p_borderColor :Int, p_fillColor :Int)
    {
        super();

        var borderWidth :Float = 0.03 * p_width;

        // Border
        _border = new Sprite();
        _border.graphics.lineStyle(borderWidth, p_borderColor);
        _border.graphics.drawRect(0.0, 0.0, p_width, p_height);
        addChild(_border);

        // Filling
        _filling = new Sprite();
        _filling.graphics.beginFill(p_fillColor);
        _filling.graphics.drawRect(borderWidth / 2, borderWidth / 2, 
                                   p_width - borderWidth, p_height - borderWidth);
        _filling.graphics.endFill();
        addChild(_filling);
        _fullWidth = _filling.width;

        update(0.0);
    }

    /**
     * Will update the display of the progress bar.
     * @param  p_percentage How much of the bar should be filled. (0 .. 1)
     */
    public function update(p_percentage :Float) :Void 
    {
        // Make sure 1% is always filled
        if (p_percentage < 0.01)
        {
            p_percentage = 0.01;
        }
        _filling.width = _fullWidth * 0.01 + _fullWidth * (p_percentage - 0.01);
    }
}