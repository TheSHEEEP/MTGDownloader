
package eu.jdrabner.mtgdownloader.download;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import haxe.io.Error;
import eu.jdrabner.ui.ProgressBar;

class FileDownloader extends flash.events.EventDispatcher
{
    public static inline var         DOWNLOAD_DONE :String = "Download_Done";

    private var _loader      :URLLoader;
    private var _url         :String;
    private var _progressBar :ProgressBar;

    /**
     * Constructor.
     * @param  p_url The URL to download.
     * @param  p_bar (Optional) The prograss bar to keep updated about the progress.
     */
    public function new(p_url :String, p_bar :ProgressBar = null) 
    {
        super();

        _loader = new URLLoader();
        _url = p_url;
        _progressBar = p_bar;

        configureListeners();
    }

    /**
     * Configure the listeners for the download.
     */
    private function configureListeners() :Void 
    {
        _loader.addEventListener(Event.COMPLETE, completeHandler);
        _loader.addEventListener(Event.OPEN, openHandler);
        _loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    }

    /**
     * Starts the download.
     */
    public function startDownload() :Void 
    {
        var request :URLRequest = new URLRequest(_url);
        _loader.load(request);
    }

    /**
     * @return The downloaded data.
     */
    public function getData() :Dynamic
    {
        return _loader.data;
    }

    /**
     * Download complete!
     */
    private function completeHandler(p_event :Event) :Void 
    {
        trace("Done");

        if (_progressBar != null)
        {
            _progressBar.update(1.0);
            _progressBar = null;
        }

        // Remove all listeners
        _loader.removeEventListener(Event.COMPLETE, completeHandler);
        _loader.removeEventListener(Event.OPEN, openHandler);
        _loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        _loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        _loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

        // Dispatch event
        dispatchEvent(new Event(DOWNLOAD_DONE));
    }

    /**
     * Open handling.
     */
    private function openHandler(p_event :Event) :Void 
    {
        trace("openHandler: " + p_event.toString());
    }

    /**
     * Progress handling.
     */
    private function progressHandler(p_event :ProgressEvent) :Void 
    {
        if (_progressBar != null)
        {
            _progressBar.update(p_event.bytesLoaded / p_event.bytesTotal);
        }
        // trace("progressHandler loaded:" + p_event.bytesLoaded + " total: " + p_event.bytesTotal);
    }

    /**
     * Security Error handling.
     */
    private function securityErrorHandler(p_event :SecurityErrorEvent) :Void 
    {
        trace("securityErrorHandler: " + p_event.text);
    }

    /**
     * HTTP status handling.
     */
    private function httpStatusHandler(p_event :HTTPStatusEvent) :Void 
    {
        trace("httpStatusHandler: " + p_event.toString());
    }

    /**
     * IO Error handling.
     */
    private function ioErrorHandler(p_event :IOErrorEvent) :Void 
    {
        trace("ioErrorHandler: " + p_event.text);
    }
}