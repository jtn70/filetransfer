/**
 * filetransfer.d
 *
 * D version of file transfer console application. See README.md for further
 * information.
 * To compile:
 * - Download d from dlang.org
 * - dmd filetransfer.d
 *
 * Authors:
 *  Jens Torgeir Solaugsten (torgeir at solaugsten dot no)
 *
 * Version: 1.0
 * 
 * Date: June 2018
 *
 * Copyright: (c) 2018 Jens Torgeir Solaugsten
 * 
 * This software is licensed under GNU GPL v3, please see LICENSE.TXT for information.
 */

import std.stdio;
import std.file;
import std.path;
import core.stdc.stdlib;
import std.conv;
import std.string;
import std.json;
import std.process;
import std.algorithm;

JSONValue settings;
 
void main(string[] args)
{
    version (linux)
    {
        writeln("FATAL ERROR: OS not supported.");
        exit (1);
    }
    version (OSX)
    {
        writeln("FATAL ERROR: OS not supported.");
        exit (1);
    }
    if (args.length != 2)
    {
        writeln("ERROR: Argument missing.\n");
        showHelp();
        exit (1);
    }
    else if (args[1] == "-h" || args[1] == "/h" || args[1] == "/?" || args[1] == "-?")
    {
        writeln("\n");
        showHelp();
    }
    else if (!args[1].exists)
    {
        writeln("ERROR: There is no JSON file named: ", args[1]);
        exit (1);
    }
    else
    {
        readSettingsFile(args[1]);
    }

    jobLoop();
}

void showHelp()
{
    writeln("Usage: filetransfer <JSONFILE>");
    writeln("\nThe JSON file must adhere to the structure reproduced here:");
    writeln(`{`);
    writeln(`  "log": "[none|info|error|console]",`);
    writeln(`  "email": {`);
    writeln(`    "server": "[servername]",`);
    writeln(`    "port": "[port]",`);
    writeln(`    "from": "[from]"`);
    writeln(`  },`);
    writeln(`  "jobs": [`);
    writeln(`    {`);
    writeln(`      "name": "[name]",`);
    writeln(`      "source": "[filepath to copy from (wildcards supported)]",`);
    writeln(`      "destination": "[filepath to copy to]"`);
    writeln(`    },`);
    writeln(`    {`);
    writeln(`      ...`);
    writeln(`    }`);
    writeln(`  ]`);
    writeln(`}`);
    writeln("\nThe copy job will exit if no source files exist. The log wil be written to");
    writeln("to the eventviewer on windows or the standard log on OS X/Linux.\n");
}

void readSettingsFile(string file)
{
    try
    {
        string settingsString = readText(file);
        settings = parseJSON(settingsString);

        if (!(settings["log"].str == "none" || settings["log"].str == "info" || settings["log"].str == "error" || settings["log"].str == "console"))
        {
            writeln(`FATAL ERROR: The value for log in invalid, must be ["none"|"info"|"log"|"console"]`);
            exit (1);
        }
    }
    catch (Exception e)
    {
        writeln("FATAL ERROR: Could not read or parse settings file.");
        exit (1);
    }
}

void writeLog(string messagetype, string message)
{
    switch (settings["log"].str)
    {
        case "preinit":
            version (Windows)
            {
                writeLogEventviewer(messagetype, message);
            }
            writeLogConsole(message);
            break;
        case "none":
            // No logging, just break out = quit.
            break;
        case "info":
            // Log everything:
            version (Windows)
            {
                // Means print everything
                writeLogEventviewer(messagetype, message);
            }
            break;
        case "error":
            if (messagetype == "error")
            {
                version (Windows)
                {
                    writeLogEventviewer(messagetype, message);
                }
            }
            break;
        case "console":
            writeLogConsole(message);
            break;
        default:
            // This should never ever be reached!!!
        version (Windows)
        {
            writeLogEventviewer("ERROR", "FATAL ERROR: Invalid log type");
        }
        writeLogConsole("FATAL ERROR: Invalid log type");        
        exit (1);
    }
}

void writeLogEventviewer(string messagetype, string message)
{
    string cmdline;
    cmdline = "EventCreate /t ";
    if (messagetype == "info")
    {
        cmdline = cmdline ~ "INFORMATION";
    }
    else if (messagetype == "error")
    {
        cmdline = cmdline ~ "ERROR";
    }
    
    cmdline = cmdline ~ ` /T APPLICATION /SO "filetransfer.exe" /ID 1 /D"` ~ message ~ `"`;


    auto cmd = executeShell(cmdline);
}

void writeLogConsole(string message)
{
    writeln(message);
}

void jobLoop()
{
    // Loop through Jobs settings["jobs"];
   JSONValue jobs = (settings["jobs"]);
   //writeln(jobs.array.length);
   
   foreach (job; jobs.array.map!(a => a.object))
   {
      
      if (dirEntries(dirName(job["source"].str), baseName(job["source"].str),SpanMode.shallow).count > 0 && job["destination"].str.exists)
      {
          writeln ("Exists");
      }
      
      
   }
}

void transferFile(string frompath, string topath)
{

}
