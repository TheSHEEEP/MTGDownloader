
package eu.jdrabner.mtgdownloader.screens;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.net.URLRequest;
import flash.Lib;
import openfl.Assets;
import haxe.htmlparser.HtmlDocument;
import haxe.htmlparser.HtmlNodeElement;
import eu.jdrabner.ui.SVGTextButton;
import eu.jdrabner.ui.SVGCheckBox;
import eu.jdrabner.ui.InputTextField;
import eu.jdrabner.ui.RGBColor;
import eu.jdrabner.mtgdownloader.download.FileDownloader;
import eu.jdrabner.mtgdownloader.data.Database;
import eu.jdrabner.mtgdownloader.data.Edition;

class SettingScreen extends Sprite
{
    public static inline var     DONE :String = "Done!";
    
    private var _database     :Database;

    private var _bgColor         :Int;
    private var _fontColor       :Int;
    private var _fontHoverColor  :Int;
    private var _relSize         :Float;
    private var _font            :String;

    private var _numParDownloads   :InputTextField;
    private var _backBtn           :SVGTextButton;
    private var _okBtn             :SVGTextButton;

    /**
     * Constructor.
     * @param  p_database  The database to fill.
     * @param  p_bgColor   The background color.
     * @param  p_fontColor The font color.
     * @param  p_fontHoverColor The font color when hovering.
     * @param  p_relSize   The relative height of the screen, relative to stage height (0 .. 1).
     * @param  p_font      The font to use.
     */
    public function new(p_database :Database, p_bgColor :Int, p_fontColor :Int, p_fontHoverColor :Int, p_relSize :Float, p_font :String)
    {
        super();

        // Remember values
        _database = p_database;
        _bgColor = p_bgColor;
        _fontColor = p_fontColor;
        _fontHoverColor = p_fontHoverColor;
        _relSize = p_relSize;
        _font = p_font;

        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /**
     * [init description]
     * @param  p_event :Event        [description]
     * @return         [description]
     */
    private function init(p_event :Event) :Void 
    {
        // Draw background
        graphics.clear();
        graphics.beginFill(_bgColor);
        graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight * _relSize);
        graphics.endFill();

        // Create UI elements
        if (_okBtn == null)
        {
            // Calculate colors for the input text fields
            var bgColor :RGBColor = new RGBColor(_bgColor);
            bgColor.add(0.2);
            var bgBorderColor :RGBColor = new RGBColor(_bgColor);
            bgBorderColor.add(-0.2);

            // Number of parallel downloads
            _numParDownloads = new InputTextField(Std.int(0.3 * stage.stageWidth), Std.int(0.04 * stage.stageHeight), 0.5, 
                bgColor.toInt(), bgBorderColor.toInt(), InputTextField.INPUT_TYPE_INT, _fontColor, _font, 
                "Parallel Downloads:", "10");
            addChild(_numParDownloads);

            // Back
            _backBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight), 
                "Back", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            _backBtn.addEventListener(MouseEvent.CLICK, handleOkClick);
            addChild(_backBtn);

            // Ok
            _okBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight), 
                "Ok", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            _okBtn.addEventListener(MouseEvent.CLICK, handleOkClick);
            addChild(_okBtn);
        }

        // Position settings
        _numParDownloads.x = 0.03 * stage.stageWidth;
        _numParDownloads.y = 0.03 * stage.stageHeight;

        // Position buttons
        _okBtn.x = 0.85 * stage.stageWidth;
        _backBtn.x = 0.85 * stage.stageWidth;

        _okBtn.y = height - 0.05 * stage.stageHeight - _okBtn.height;
        _backBtn.y = _okBtn.y - 0.05 * stage.stageHeight - _backBtn.height;
    }

    /**
     * Will continue to the next step.
     */
    private function handleOkClick(p_event :MouseEvent) :Void 
    {
        trace("Ok!");
    }
}