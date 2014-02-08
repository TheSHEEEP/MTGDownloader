
package eu.jdrabner.mtgDownloader;

import flash.display.Sprite;
import flash.events.Event;
import tweenx909.TweenX;
import tweenx909.EaseX;
import eu.jdrabner.mtgdownloader.screens.ScanScreen;
import eu.jdrabner.mtgdownloader.screens.SettingScreen;
import eu.jdrabner.mtgdownloader.data.Database;

/**
 * The main class of the MTg Downloader.
 * Creates the title and all screens and manages navigation between them.
 */
class DownloaderMain extends Sprite
{
    private var _database     :Database;

    private var _titleBar     :TitleBar;

    private var _scanScreen     :ScanScreen;
    private var _settingScreen  :SettingScreen;   

    private var _toHide :Sprite;

    /**
     * Constructor.
     */
    public function new()
    {
        super();

        // Create database
        _database = new Database();
        
        // Create title bar
        _titleBar = new TitleBar(0xFFFFFF, 0x504C4C, 0.2, 0.7, -0.09, "fonts/OpenSans-Bold.ttf");
        _titleBar.setTitleText("Select Editions");
        addChild(_titleBar);

        // Create the screens
        // 1: Edition scanning
        _scanScreen = new ScanScreen(_database, 0xE1E0D7, 0x8c8c8b, 0x1e1e1e, 0.8, "fonts/OpenSans-Semibold.ttf");
        _scanScreen.addEventListener(ScanScreen.DONE, handleScanScreenDone);
        addChild(_scanScreen);

        // 2: Settings
        _settingScreen = new SettingScreen(_database, 0x4B9F94, 0xFFFFFF, 0x1e1e1e, 0.8, "fonts/OpenSans-Semibold.ttf");
        _settingScreen.visible = false;
        addChild(_settingScreen);
        
        // 3: Download
        
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /**
     * Initialize the title bar and the screens.
     */
    private function init(p_event :Event) :Void 
    {
        _scanScreen.y = 0.2 * stage.stageHeight;
        _settingScreen.y = 0.2 * stage.stageHeight;
        _scanScreen.go();
    }

    /**
     * Will switch to the setting screen.
     */
    private function handleScanScreenDone(p_event :Event) :Void 
    {
        TweenX.to(_scanScreen, {alpha : 0.0} ).time(0.8).ease(EaseX.quintIn).onFinish(hideScreen);
        _toHide = _scanScreen;
        TweenX.to(_settingScreen, {alpha : 1.0} ).time(0.8).ease(EaseX.quintIn);
        _settingScreen.alpha = 0.0;
        _settingScreen.visible = true;

        _titleBar.setTitleText("Setup Download");
    }

    /**
     * Hides the screen after the tween
     */
    private function hideScreen() :Void 
    {
        _toHide.visible = false;
    }

}