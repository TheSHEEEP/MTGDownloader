
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
import htmlparser.HtmlDocument;
import htmlparser.HtmlNodeElement;
import eu.jdrabner.ui.SVGTextButton;
import eu.jdrabner.ui.SVGCheckBox;
import eu.jdrabner.ui.InputTextField;
import eu.jdrabner.ui.RGBColor;
import eu.jdrabner.mtgdownloader.download.DownloadSettings;
import eu.jdrabner.mtgdownloader.data.Database;
import eu.jdrabner.mtgdownloader.data.Edition;

class SettingScreen extends Sprite
{
    public static inline var     DONE :String = "Done!";
    public static inline var     BACK :String = "Back!";

    private var _database     :Database;

    private var _bgColor         :Int;
    private var _fontColor       :Int;
    private var _fontHoverColor  :Int;
    private var _relSize         :Float;
    private var _font            :String;

    private var _numParDownloads   :InputTextField;
    private var _prefix            :InputTextField;
    private var _postfix           :InputTextField;
    private var _toLower           :SVGCheckBox;
    private var _toUpper           :SVGCheckBox;
    private var _targetFolder      :InputTextField;
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
            _numParDownloads = new InputTextField(Std.int(0.22 * stage.stageWidth), Std.int(0.04 * stage.stageHeight), 0.4,
                bgColor.toInt(), bgBorderColor.toInt(), InputTextField.INPUT_TYPE_INT, _fontColor, _font,
                "Parallel Downloads:", "10");
            addChild(_numParDownloads);

            // Prefix
            _prefix = new InputTextField(Std.int(0.22 * stage.stageWidth), Std.int(0.04 * stage.stageHeight), 0.5,
                bgColor.toInt(), bgBorderColor.toInt(), InputTextField.INPUT_TYPE_TEXT, _fontColor, _font,
                "Prefix:", "");
            addChild(_prefix);

            // Postfix
            _postfix = new InputTextField(Std.int(0.22 * stage.stageWidth), Std.int(0.04 * stage.stageHeight), 0.5,
                bgColor.toInt(), bgBorderColor.toInt(), InputTextField.INPUT_TYPE_TEXT, _fontColor, _font,
                "Postfix:", ".full");
            addChild(_postfix);

            // To lower
            _toLower = new SVGCheckBox(Std.int(stage.stageWidth * 0.22), Std.int(stage.stageHeight * 0.04), 0.18,
                "(Filename) to lower", _fontColor, _fontHoverColor, _font,
                "svg/cb_white_un_normal", "svg/cb_white_un_hover", "svg/cb_white_normal", "svg/cb_white_hover");
            addChild(_toLower);

            // To upper
            _toUpper = new SVGCheckBox(Std.int(stage.stageWidth * 0.22), Std.int(stage.stageHeight * 0.04), 0.18,
                "(Filename) to UPPER", _fontColor, _fontHoverColor, _font,
                "svg/cb_white_un_normal", "svg/cb_white_un_hover", "svg/cb_white_normal", "svg/cb_white_hover");
            addChild(_toUpper);

            // Target folder
            _targetFolder = new InputTextField(Std.int(0.5 * stage.stageWidth), Std.int(0.04 * stage.stageHeight), 0.7,
                bgColor.toInt(), bgBorderColor.toInt(), InputTextField.INPUT_TYPE_TEXT, _fontColor, _font,
                "Target folder:", "C:/magiccards");
            addChild(_targetFolder);

            // Back
            _backBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight),
                "Back", _fontColor, _font,
                "svg/btn_white_normal", "svg/btn_white_click", "svg/btn_white_hover");
            _backBtn.addEventListener(MouseEvent.CLICK, handleBackClick);
            addChild(_backBtn);

            // Ok
            _okBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight),
                "Ok", _fontColor, _font,
                "svg/btn_white_normal", "svg/btn_white_click", "svg/btn_white_hover");
            _okBtn.addEventListener(MouseEvent.CLICK, handleOkClick);
            addChild(_okBtn);
        }

        // Position settings
        _numParDownloads.x = 0.03 * stage.stageWidth;
        _prefix.x = _numParDownloads.x;
        _postfix.x = _prefix.x + _prefix.width + 0.03 * stage.stageWidth;
        _toLower.x = _numParDownloads.x;
        _toUpper.x = _toLower.x + _toLower.width + 0.03 * stage.stageWidth;
        _targetFolder.x = _toLower.x;

        _numParDownloads.y = 0.03 * stage.stageHeight;
        _prefix.y = _numParDownloads.y + _numParDownloads.height + 0.03 * stage.stageHeight;
        _postfix.y = _prefix.y;
        _toLower.y = _postfix.y + _postfix.height + 0.03 * stage.stageWidth;
        _toUpper.y = _toLower.y;
        _targetFolder.y = _toLower.y + _toLower.height + 0.03 * stage.stageWidth;

        // Position buttons
        _okBtn.x = 0.85 * stage.stageWidth;
        _backBtn.x = 0.85 * stage.stageWidth;

        _okBtn.y = height - 0.05 * stage.stageHeight - _okBtn.height;
        _backBtn.y = _okBtn.y - 0.05 * stage.stageHeight - _backBtn.height;
    }

    /**
     * Will go back to the last step.
     */
    private function handleBackClick(p_event :MouseEvent) :Void
    {
        dispatchEvent(new Event(BACK));
    }

    /**
     * Will continue to the next step.
     */
    private function handleOkClick(p_event :MouseEvent) :Void
    {
        // Take note of settings
        DownloadSettings.numParallelDownloads = Std.parseInt(_numParDownloads.getText());
        DownloadSettings.prefix = _prefix.getText();
        DownloadSettings.postfix = _postfix.getText();
        DownloadSettings.toLower = _toLower.getChecked();
        DownloadSettings.toUpper = _toUpper.getChecked();
        DownloadSettings.targetFolder = _targetFolder.getText();

        // Dispatch done
        dispatchEvent(new Event(DONE));
    }
}
