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
import std.xml;
import std.string;
import dxml.dom;

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
    writeln("Usage: filetransfer <XMLFILE>");
    writeln("\nThe XML file must adhere to the structure reproduced here:");
    writeln("<filetransfer>");
    writeln("   <log>none|info|error|console</log>");
    writeln("   <emailserver>smtp.company.com</emailserver>");
    writeln("   <emailport>25</emailport>");
    writeln("   <emailfrom>filetransfer@company.com</emailfrom>");
    writeln("   <job>");
    writeln("       <jobname>jobname</jobname>");
    writeln("       <source>filepath (and wildcard) to copy from</source>");
    writeln("       <destination>filepath to copy to</destination>");
    writeln("   </job>");
    writeln("   <job>...</job>");
    writeln("   ...");
    writeln("</filetransfer>");
    writeln("\nThe copy job will exit if no source files exist. The log wil be written to");
    writeln("to the eventviewer on windows andcthe standard log on OS X/Linux.\n");
}

void readSettingsFile(string file)
{
    auto sxml = readText(file);

    auto dom = parseDOM(sxml);

    writeln(dom.children["filetransfer"]);
}
