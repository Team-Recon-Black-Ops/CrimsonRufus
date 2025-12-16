using System;
using System.Collections.Generic;
using CrimsonRufus.lib.Interop;


namespace CrimsonRufus.Commands
{
    public class Purge : ICommand
    {
        public static string CommandName => "purge";

        public void Execute(Dictionary<string, string> arguments)
        {
            Console.WriteLine("\r\n[] Action: Purge Tickets");

            LUID luid = new LUID();

            if (arguments.ContainsKey("/luid"))
            {
                try
                {
                    luid = new LUID(arguments["/luid"]);
                }
                catch
                {
                    Console.WriteLine("[X] Invalid LUID format ({0})\r\n", arguments["/luid"]);
                    return;
                }
            }

            LSA.Purge(luid);
        }
    }
}