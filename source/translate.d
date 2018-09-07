module translate;


import pishtolc;
import std.array : split;
import std.conv  : to;
import std.json;
import std.stdio  : File;
import std.string : endsWith;


private JSONValue replacements;

static this()
{
        File file = File("word_replacements.json", "r");
        string buf;

        while (!file.eof)
        {
                buf ~= file.readln();
        }
        file.close();
        
        replacements = parseJSON(buf);
}

/**
 * Translates a Polish word into a Pishtolc word.
 */
dstring toPishtolc(dstring polish)
{
        if (polish.to!string in replacements)
        {
                dstring[] words = replacements[polish.to!string]
                                        .to!dstring[1 .. $ - 1] // Removing quotation marks.
                                        .split(',');
                dstring result;
                foreach (i, word; words)
                {
                        dstring prefix;
                        if (word.endsWith(" się"d))
                        {
                                prefix = "sie"d;
                                word = word[0 .. $ - 4];
                        }
                        result ~= (prefix ~ word).translate ~ (i < cast(int) words.length - 1 ? ", "d : ""d);
                }
                return result;
        }

        if (polish.endsWith(" się"d))
        {
                polish = "sie"d ~ polish[0 .. $ - 4];
        }

        return polish.translate;
}