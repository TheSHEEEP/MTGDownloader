
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
import eu.jdrabner.ui.ScrollableContainer;
import eu.jdrabner.ui.ProgressBar;
import eu.jdrabner.mtgdownloader.download.FileDownloader;
import eu.jdrabner.mtgdownloader.data.Database;
import eu.jdrabner.mtgdownloader.data.Edition;

/**
 * This screen is responsible for all the downloads.
 */
class DownloadScreen extends Sprite
{
    public static inline var     DONE :String = "Done!";
    public static inline var     BACK :String = "Back!";

    private var _database     :Database;

    private var _bgColor         :Int;
    private var _fontColor       :Int;
    private var _fontHoverColor  :Int;
    private var _relSize         :Float;
    private var _font            :String;

    private var _editionsProgress :TextField;
    private var _cardsProgress    :TextField;
    private var _container        :ScrollableContainer;

    private var _backBtn          :SVGTextButton;

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
        if (_editionsProgress == null)
        {
            // Create text format to use
            var font :Font = Assets.getFont(_font);
            var textFormat :TextFormat = new TextFormat();
            textFormat.bold = true;
            textFormat.size = stage.stageHeight * _relSize * 0.03;
            textFormat.font = font.fontName;
            textFormat.color = _fontColor;

            // Editions progress
            _editionsProgress = new TextField();
            _editionsProgress.embedFonts = true;
            _editionsProgress.selectable = false;
            _editionsProgress.mouseEnabled = false;
            _editionsProgress.defaultTextFormat = textFormat;
            _editionsProgress.text = "Edition progress: 0 / 0";
            _editionsProgress.width = _editionsProgress.textWidth * 1.03;
            _editionsProgress.height = _editionsProgress.textHeight * 1.03;
            addChild(_editionsProgress);

            // Cards progress
            _cardsProgress = new TextField();
            _cardsProgress.embedFonts = true;
            _cardsProgress.selectable = false;
            _cardsProgress.mouseEnabled = false;
            _cardsProgress.defaultTextFormat = textFormat;
            _cardsProgress.text = "Cards progress: 0 / 0";
            _cardsProgress.width = _cardsProgress.textWidth * 1.03;
            _cardsProgress.height = _cardsProgress.textHeight * 1.03;
            addChild(_cardsProgress);

            // Back
            _backBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight), 
                "Back", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            _backBtn.addEventListener(MouseEvent.CLICK, handleBackClick);
            addChild(_backBtn);

            // Scrollable container
            _container = new ScrollableContainer(0.84 * stage.stageWidth, stage.stageHeight * _relSize * 0.8, 0.02, 
                                                _fontColor, _fontHoverColor);
            addChild(_container);
        }
        
        // Position UI elements
        _editionsProgress.x = 0.03 * stage.stageWidth;
        _cardsProgress.x = 0.03 * stage.stageWidth;

        _editionsProgress.y = 0.03 * stage.stageHeight;
        _cardsProgress.y = _editionsProgress.y + _editionsProgress.height + 0.03 * stage.stageHeight;
        _container.y = _cardsProgress.y + _cardsProgress.height + 0.03 * stage.stageHeight;

        // Position buttons
        _backBtn.x = 0.85 * stage.stageWidth;
        _backBtn.y = height - 0.05 * stage.stageHeight - _backBtn.height;
    }

    /**
     * Start downloading all editions.
     */
    public function go() :Void 
    {
        // First, start downloading all editions
        var editions :Array<Edition> = _database.getEditionsToDownload();
        for (edition in editions)
        {
            // TODO: here
            // Create download display
            // Create download job
            // Listen to the download
        }
    }

    /**
     * Returns the nth index of the passed string token.
     * @param  p_string  The string to look in.
     * @param  p_lookFor The token to look for.
     * @param  p_n       The n.
     * @return The nth index.
     */
    private function nthIndexOf(p_string :String, p_lookFor :String, p_n :Int) :Int 
    {
        var lastIndex :Int = 0;
        for (count in 0 ... p_n)
        {
            lastIndex = p_string.indexOf(p_lookFor, lastIndex + p_lookFor.length);
        }
        return lastIndex;
    }

    /**
     * Will parse the downloaded HTML file to get all editions.
     */
    private function handleDownloadDone(p_event :Event) :Void 
    {
        // Find all "a" inside the second table, which contains all editions
        // We can't parse the whole site as it contains errors and freaks out any parser
        var downloader :FileDownloader = cast p_event.target;
        var data :String = downloader.getData();
        var bodyIndex :Int = nthIndexOf(data, "<table", 2);
        var bodyEndIndex: Int = nthIndexOf(data, "</table>", 2);
        var dataStripped :String = data.substr(bodyIndex, bodyEndIndex - bodyIndex + 8);
        var xml :HtmlDocument = new HtmlDocument(dataStripped);
        var finds :Array<HtmlNodeElement> = xml.find("a");

        // Construct every edition and add it to the database
        // Also create a check box for it
        var title :String = "";
        var shorty :String = "/bng/en.html";
        var edition :Edition = null;
        for (element in finds)
        {
            // Get the title and the shorty
            title = element.innerHTML;
            shorty = element.getAttribute("href");
            shorty = shorty.substr(1, shorty.length - 1 - 8); // 8 is "/en.html"

            // _container.addObject(checkbox);
        }
    }

    /**
     * Will go back to the last step.
     */
    private function handleBackClick(p_event :MouseEvent) :Void 
    {
        dispatchEvent(new Event(BACK));
    }
}