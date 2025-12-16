using System.Collections.Generic;

namespace CrimsonRufus.Commands
{
    public interface ICommand
    {
        void Execute(Dictionary<string, string> arguments);
    }
}