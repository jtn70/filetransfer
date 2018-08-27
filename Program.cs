using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.Threading.Tasks;


namespace filetransfer
{
    class Program
    {
        static void Main(string[] args)
        {
            
            if (args.Length == 0 || args.Length > 1)
            {
                System.Console.WriteLine("\nERROR: Wrong number of arguments.");
                Usage();
                System.Environment.Exit(1);
            }
            else if (args[0] == @"/h" || args[0] == @"/?" || args[0] == @"-h")
            {
                Usage();
                System.Environment.Exit(0);
            }
            else
            {
                if (!File.Exists(args[0]))
                {
                    Console.WriteLine("\nERROR: [" + args[0] + "] does not exist or is not accessible by filetransfer.");
                    Usage();
                    System.Environment.Exit(1);
                }
            }

            FileTransfer ft = new FileTransfer(args[0]);
            
        }

        static void Usage()
        {
            System.Console.WriteLine("\n\nUsage: filetransfer <xmlfile>");
            System.Console.WriteLine("\nThe xml file must use the following structure and format:");
            System.Console.WriteLine("<filetransfer>");
            System.Console.WriteLine("   <log>none|error|info|console</log>");
            System.Console.WriteLine("   <emailserver>a.b.c:25</emailserver>");
            System.Console.WriteLine("   <email>a@b.c</email>");
            System.Console.WriteLine("   <application>");
            System.Console.WriteLine("      <name>name of the transferjob</name>");
            System.Console.WriteLine("      <from>file area to transfer file(s) from</from>");
            System.Console.WriteLine("      <to>file area to transfer file(s) to</to>");
            System.Console.WriteLine("   </application>");
            System.Console.WriteLine("   <application>...</application>");
            System.Console.WriteLine("...");
            System.Console.WriteLine("</filetransfer");
            System.Console.WriteLine("\nThe file area can contain a catalogue or a catalogue with filename wildcard.");
            System.Console.WriteLine("<from>..</from> must contain files for transfer to happen.");
            System.Console.WriteLine("Source files are deleted when the files are identical. ");
        }
    }
}
