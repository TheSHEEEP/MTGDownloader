
package eu.jdrabner.mtgdownloader.download;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFormat;
import flash.text.TextField;
import flash.text.Font;
import openfl.Assets;
import eu.jdrabner.ui.ProgressBar;
import eu.jdrabner.mtgdownloader.download.FileDownloader;
import eu.jdrabner.mtgdownloader.download.DownloadSettings;

/**
 * This class displays the progress and name of one download job.
 */
class DownloadDisplay extends Sprite
{
    private var _font              :String;
    private var _fontColor         :Int;
    private var _barFillColor      :Int;
    private var _targetWidth       :Float;
    private var _targetHeight      :Float;

    private var _label         :TextField;
    private var _progressBar   :ProgressBar;
    private var _job           :DownloadJob;

    /**
     * Constructor.
     * @param  p_width     The target width of the display. In pixels.
     * @param  p_height    The target width of the display. In pixels.
     * @param  p_fontName  The font name,   
     * @param  p_fontColor The font color.
     * @param  p_fillColor The filling color of the progress bar.                                              
     * @param  p_job       The job to track. May be null to be set later.
     */
    public function new(p_width :Float, p_height :Float, p_fontName :String, p_fontColor :Int, p_fillColor :Int
                          p_job :DownloadJob = null)
    {
        // Remember settings
        _targetWidth = p_width;
        _targetHeight = p_height;
        _font = p_fontName;
        _fontColor = p_fontColor;
        _barFillColor = p_fillColor;

        setDownloadJob(p_job);

        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /**
     * Initializes the display.
     */
    private function init(p_event :Event) :Void 
    {
        // Create UI elements
        if (_label == null)
        {
            // Label
            var font :Font = Assets.getFont(_font);
            var textFormat :TextFormat = new TextFormat();
            textFormat.bold = true;
            textFormat.size = _targetHeight * 0.4;
            textFormat.font = font.fontName;
            textFormat.color = _fontColor;
            _label = new TextField();
            _label.embedFonts = true;
            _label.mouseEnabled = false;
            _label.selectable = false;
            _label.defaultTextFormat = textFormat;
            addChild(_label);

            // Progress bar
            _progressBar = new ProgressBar(_targetWidth, 0.45 * _targetHeight, _fontColor, _barFillColor);
            addChild(_progressBar);
        }

        // Register progress bar
        if (_job != null)
        {
            _job.setProgressBar(_progressBar);
        }

        // Update label
        updateLabel();

        // Position progress bar
        _progressBar.y = 0.55 * _targetHeight;
        
    }
    
    /**
     * @param p_job The DownloadJob to track.
     */
    public function setDownloadJob(p_job :DownloadJob) :Void 
    {
        // Unregister old one
        if (_job != null)
        {

        }

        // Register new job
        if (p_job != null)
        {
            _job = p_job;
            if (_progressBar != null)
            {
                _job.setProgressBar(_progressBar);
            }
        }

        // Update label
        updateLabel();
    }

    /**
     * Updates the label.
     */
    private function updateLabel() :Void 
    {
        if (_label != null)
        {
            // Make sure the label is not completely empty
            if (_job != null)
            {
                _label.text = _job.getFullDescription();
            }
            else
            {
                _label.text = "  ";
            }

            _label.width = _label.textWidth * 1.03;
            _label.height = _label.textHeight * 1.03;
            _label.x = _targetWidth / 2 - _label.width / 2;
            _label.y = 0.05 * _targetHeight;
        }
    }

}