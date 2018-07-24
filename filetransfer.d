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

struct job
{
    string jobname;
    string source;
    string destination;
}

struct settings 
{
    string log;
    string emailserver;
    string emailport;
    string emailfrom;
    job[] jobelement;
}

settings appsettings;

 
void main(string[] args)
{
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
        writeln("ERROR: There is no XML file named: ", args[1]);
        exit (1);
    }
    else
    {
        readSettingsFile(args[1]);
    }
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
  
}
