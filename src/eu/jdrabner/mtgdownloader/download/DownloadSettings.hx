
package eu.jdrabner.mtgdownloader.download;

/**
 * Helper class that holds all download settings.
 */
class DownloadSettings 
{
    public static var numParallelDownloads     :Int = 0;
    public static var prefix                   :String = "";
    public static var postfix                  :String = "";
    public static var toLower                  :Bool = false;
    public static var toUpper                  :Bool = false;
    public static var targetFolder             :String = "";
}