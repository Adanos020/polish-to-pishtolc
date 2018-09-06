import std.conv   : to;
import std.stdio  : writeln;
import std.string : toLower;
import translate  : toPishtolc;


void main(string[] args)
{
        foreach (word; args[1 .. $])
        {
                writeln(word, ": ", word.to!dstring.toLower.toPishtolc);
        }
}