using System;

namespace CrimsonRufus.Domain
{
    public static class Info
    {
        public static void ShowLogo()
        {
            Console.WriteLine("\r\n   _____      _                         ____        __           ");
            Console.WriteLine("  / ____|    (_)                       |  _ \\      / _|          ");
            Console.WriteLine(" | |     _ __ _ _ __ ___  ___  _ __   | |_) |_   _| |_ _   _ ___ ");
            Console.WriteLine(" | |    | '__| | '_ ` _ \\/ _ \\| '__|  |  _ <| | | |  _| | | / __|");
            Console.WriteLine(" | |____| |  | | | | | | (_) | |     | |_) | |_| | | | |_| \\__ \\");
            Console.WriteLine("  \\_____|_|  |_|_| |_| |_\\___/|_|     |____/ \\__,_|_|  \\__,_|___/");
            Console.WriteLine("  v2.3.3 \r\n");
        }

        public static void ShowUsage()
        {
                string usage = @"
Usage: CrimsonRufus.exe <command> [arguments]
";
            Console.WriteLine(usage);
        }
    }
}
