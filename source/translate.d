module translate;


import pishtolc;
import std.conv : to;
import std.json;
import std.stdio : File;


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
                polish = replacements[polish.to!string].to!dstring[1 .. $ - 1]; // Removing quotation marks.
        }

        return polish.translate;
}