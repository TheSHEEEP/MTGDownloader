
package eu.jdrabner.mtgDownloader;

import flash.display.Sprite;
import flash.events.Event;
import eu.jdrabner.mtgdownloader.screens.ScanScreen;

/**
 * The main class of the MTg Downloader.
 * Creates the title and all screens and manages navigation between them.
 */
class DownloaderMain extends Sprite
{
    private var _titleBar     :TitleBar;

    private var _scanScreen     :ScanScreen;

    /**
     * Constructor.
     */
    public function new()
    {
        super();

        // Create title bar
        _titleBar = new TitleBar(0xFFFFFF, 0x504C4C, 0.2, 0.8, -0.09, "fonts/OpenSans-Bold.ttf");
        _titleBar.setTitleText("Select Editions");
        addChild(_titleBar);

        // Create the screens
        // 1: Edition scanning
        _scanScreen = new ScanScreen(0xE1E0D7, 0x8c8c8b, 0.8, "fonts/OpenSans-Semibold.ttf");
        addChild(_scanScreen);

        // 2: Settings
        
        // 3: Download progress
        
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /**
     * Initialize the title bar and the screens.
     */
    private function init(p_event :Event) :Void 
    {
        _scanScreen.y = 0.2 * stage.stageHeight;
        _scanScreen.go();
    }

}