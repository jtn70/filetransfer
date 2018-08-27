using System;
using System.Collections;
using System.Xml;
using System.IO;

namespace filetransfer
{
    public struct copyEntry
    {
        public string ifrom;
        public string ito;

        public copyEntry (string from, string to)
        {
            ifrom = from;
            ito = to;
        }
    }

    public enum loglevel { e}

    public class FileTransfer
    {
        XmlDocument ftSettings;
        Queue copyjobs;


        public FileTransfer(string settingsfile)
        {
            parseXmlFile(settingsfile);
        }

        void parseXmlFile(string settingsfile)
        {
            ftSettings = new XmlDocument();
            ftSettings.PreserveWhitespace = true;

            try
            {
                ftSettings.Load(settingsfile);
            }
            catch
            {
                // OOps
            }



        }
    }
}
