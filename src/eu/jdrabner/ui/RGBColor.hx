
package eu.jdrabner.ui;


/**
 * RGB color class.
 */
class RGBColor 
{
    private var _baseColor     :Int = 0x000000;

    private var _r     :Float = 0.0;
    private var _g     :Float = 0.0;
    private var _b     :Float = 0.0;

    /**
     * Constructor
     * @param  p_base The color to base the class on.
     */
    public function new(p_base :Int)
    {
        _baseColor = p_base;

        _r = ((p_base >> 16) & 255) / 255;
        _g = ((p_base >> 8) & 255) / 255;
        _b = (p_base & 255) / 255;
    }

    /**
     * Multiplies this color with another.
     * @param  p_other Can be either an Int value (which will be converted to RGBColor), another RGBColor or 
     *                 a Float value.
     */
    public function multiply(p_other :Dynamic) :Void
    {
        if (Std.is(p_other, RGBColor))
        {
            _r *= p_other._r;
            _g *= p_other._g;
            _b *= p_other._b;
        }
        else if (Std.is(p_other, Int))
        {
            var color :RGBColor = new RGBColor(p_other);
            _r *= color._r;
            _g *= color._g;
            _b *= color._b;
        }
        else if (Std.is(p_other, Float))
        {
            _r *= p_other;
            _g *= p_other;
            _b *= p_other;
        }

        clamp();
    }

    /**
     * Add another color to this color.
     * @param  p_other Can be either an Int value (which will be converted to RGBColor), another RGBColor or 
     *                 a Float value.
     */
    public function add(p_other :Dynamic) :Void
    {
        if (Std.is(p_other, RGBColor))
        {
            _r += p_other._r;
            _g += p_other._g;
            _b += p_other._b;
        }
        else if (Std.is(p_other, Int))
        {
            var color :RGBColor = new RGBColor(p_other);
            _r += color._r;
            _g += color._g;
            _b += color._b;
        }
        else if (Std.is(p_other, Float))
        {
            _r += p_other;
            _g += p_other;
            _b += p_other;
        }

        clamp();
    }

    /**
     * Subtract another color from this color.
     * @param  p_other Can be either an Int value (which will be converted to RGBColor), another RGBColor or 
     *                 a Float value.
     */
    public function subtract(p_other :Dynamic) :Void
    {
        if (Std.is(p_other, RGBColor))
        {
            _r -= p_other._r;
            _g -= p_other._g;
            _b -= p_other._b;
        }
        else if (Std.is(p_other, Int))
        {
            var color :RGBColor = new RGBColor(p_other);
            _r -= color._r;
            _g -= color._g;
            _b -= color._b;
        }
        else if (Std.is(p_other, Float))
        {
            _r -= p_other;
            _g -= p_other;
            _b -= p_other;
        }

        clamp();
    }

    /**
     * Will clamp the color values from 0 to 1.
     */
    private function clamp() :Void 
    {
        if (_r > 1.0) _r = 1.0;
        if (_g > 1.0) _g = 1.0;
        if (_b > 1.0) _b = 1.0;
        if (_r < 0.0) _r = 0.0;
        if (_g < 0.0) _g = 0.0;
        if (_b < 0.0) _b = 0.0;
    }

    /**
     * @return This color as an Int value.
     */
    public function toInt() :Int 
    {
        var result :Int = 0x000000;
        result |= (Std.int(_r * 255) << 16) | (Std.int(_g * 255) << 8) | (Std.int(_b * 255));
        return result;
    }
}