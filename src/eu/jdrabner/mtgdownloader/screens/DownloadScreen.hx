
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
import eu.jdrabner.ui.RGBColor;
import eu.jdrabner.mtgdownloader.download.FileDownloader;
import eu.jdrabner.mtgdownloader.download.DownloadJob;
import eu.jdrabner.mtgdownloader.download.DownloadSettings;
import eu.jdrabner.mtgdownloader.download.DownloadDisplay;
import eu.jdrabner.mtgdownloader.data.Database;
import eu.jdrabner.mtgdownloader.data.Edition;
import eu.jdrabner.mtgdownloader.data.Card;

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

    private var _displays             :Array<DownloadDisplay>;
    private var _waitingDownloads     :Array<Dynamic>;

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

        _displays = new Array<DownloadDisplay>();
        _waitingDownloads = new Array<Dynamic>();

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
            addDownload(edition);
        }
    }

    /**
     * Will add a download.
     * @param p_edition The Edition or Card to download.
     */
    private function addDownload(p_source :Dynamic) :Void 
    {
        // Create download job
        var job :DownloadJob = new DownloadJob(p_source);
        job.addEventListener(DownloadJob.DONE, handleJobDone);

        // Try recycling an existing display
        for (display in _displays)
        {
            // Re-use an idle display
            if (display.isIdle())
            {
                display.setDownloadJob(job);
                return;
            }
        }

        // Try creating a new display
        if (_container.getNumObjects() <= DownloadSettings.numParallelDownloads)
        {
            // Create download display
            var color :RGBColor = RGBColor(_fontColor);
            color.add(0.2);
            var display :DownloadDisplay = 
                new DownloadDisplay(0.2 * stage.stageWidth, 0.05 * stage.stageHeight, _font, _fontColor, color.toInt(), job);

            // Add it
            _container.addObject(display);
            _displays.push(display);
        }
        else
        {
            // Add this job to the waiting queue
            _waitingDownloads.push(p_source);
        }
    }

    /**
     * Will handle completed downloads of an edition or a card.
     */
    private function handleJobDone(p_event :Event) :Void 
    {
        var job :DownloadJob = cast p_event.target;
        job.removeEventListener(DownloadJob.DONE, handleJobDone);

        // If this was an edition, parse the HTML
        if (Std.is(job.getSource(), Edition))
        {
            // Let the edition read the HTML
            var edition :Edition = cast job.getSource();
            edition.readCardsFromEditionHtml(job.getData());

            // Start a download for each card
            for (card ... edition.getCards())
            {
                addDownload(card);
            }
        }
        // Otherwise, store the card
        else
        {
            var card :Card = cast job.getSource();
            trace("Now download card: " + card.getFullName());
        }

        // If we have waiting downloads, add one of these
        if (_waitingDownloads.length > 0)
        {
            var source :Dynamic = _waitingDownloads[1];
            _waitingDownloads.splice(0, 1);
            addDownload(source);
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