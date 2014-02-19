
package eu.jdrabner.mtgDownloader;

import flash.display.Sprite;
import flash.events.Event;
import tweenx909.TweenX;
import tweenx909.EaseX;
import eu.jdrabner.mtgdownloader.screens.ScanScreen;
import eu.jdrabner.mtgdownloader.screens.SettingScreen;
import eu.jdrabner.mtgdownloader.screens.DownloadScreen;
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
    private var _downloadScreen :DownloadScreen;   

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
        _settingScreen = new SettingScreen(_database, 0x4B9F94, 0xFFFFFF, 0x65BEB4, 0.8, "fonts/OpenSans-Semibold.ttf");
        _settingScreen.addEventListener(SettingScreen.DONE, handleSettingScreenDone);
        _settingScreen.addEventListener(SettingScreen.BACK, handleSettingScreenBack);
        _settingScreen.visible = false;
        addChild(_settingScreen);
        
        // 3: Download
        _downloadScreen = new DownloadScreen(_database, 0x272822, 0xF8F8F2, 0xFFFFFF, 0.8, "fonts/OpenSans-Semibold.ttf");
        _downloadScreen.addEventListener(DownloadScreen.DONE, handleDownloadScreenDone);
        _downloadScreen.visible = false;
        addChild(_downloadScreen);
        
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /**
     * Initialize the title bar and the screens.
     */
    private function init(p_event :Event) :Void 
    {
        _scanScreen.y = 0.2 * stage.stageHeight;
        _settingScreen.y = 0.2 * stage.stageHeight;
        _downloadScreen.y = 0.2 * stage.stageHeight;
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
     * Will switch to the setting screen.
     */
    private function handleSettingScreenBack(p_event :Event) :Void 
    {
        TweenX.to(_settingScreen, {alpha : 0.0} ).time(0.8).ease(EaseX.quintIn).onFinish(hideScreen);
        _toHide = _settingScreen;
        TweenX.to(_scanScreen, {alpha : 1.0} ).time(0.8).ease(EaseX.quintIn);
        _scanScreen.alpha = 0.0;
        _scanScreen.visible = true;

        _titleBar.setTitleText("Select Editions");
    }

    /**
     * Will switch to the setting screen.
     */
    private function handleSettingScreenDone(p_event :Event) :Void 
    {
        TweenX.to(_settingScreen, {alpha : 0.0} ).time(0.8).ease(EaseX.quintIn).onFinish(hideScreen);
        _toHide = _settingScreen;
        TweenX.to(_downloadScreen, {alpha : 1.0} ).time(0.8).ease(EaseX.quintIn).onFinish(startDownloads);
        _downloadScreen.alpha = 0.0;
        _downloadScreen.visible = true;

        _titleBar.setTitleText("Downloading...");
    }

    /**
     * Will start the download screen.
     */
    private function startDownloads() :Void 
    {
        _downloadScreen.go();
    }

    /**
     * Will switch to the setting screen.
     */
    private function handleDownloadScreenBack(p_event :Event) :Void 
    {
        TweenX.to(_downloadScreen, {alpha : 0.0} ).time(0.8).ease(EaseX.quintIn).onFinish(hideScreen);
        _toHide = _downloadScreen;
        TweenX.to(_settingScreen, {alpha : 1.0} ).time(0.8).ease(EaseX.quintIn);
        _settingScreen.alpha = 0.0;
        _settingScreen.visible = true;

        _titleBar.setTitleText("Setup Download");
    }

    /**
     * Will switch to the setting screen.
     */
    private function handleDownloadScreenDone(p_event :Event) :Void 
    {
        trace("Downloaded everything.");
    }

    /**
     * Hides the screen after the tween
     */
    private function hideScreen() :Void 
    {
        _toHide.visible = false;
    }

}