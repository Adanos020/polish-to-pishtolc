module pishtolc;


import std.algorithm.searching : canFind;
import std.ascii : isAlpha;
import std.stdio : writeln;


/**
 * Translates a prepared word.
 */
dstring translate(dstring word)
{
        return word.replaceSounds
                   .normalize
                   .reduceConsonantClusters
        ;
}

private: // Implementation details that don't have to be exposed.

bool isVowel(dchar letter)
{
        return "aäąeėiïouųyÿ"d.canFind(letter);
}

bool isConsonant(dchar letter)
{
        return letter.isAlpha && !letter.isVowel;
}

bool isObstructiveConsonant(dchar letter)
{
        return letter.isConsonant && !"jsṡš"d.canFind(letter);
}

bool isAdjacentToVowel(dstring str, size_t index)
{
        return (index > 0                        && str[index - 1].isVowel)
            || (index < cast(int) str.length - 1 && str[index + 1].isVowel);
}

bool isSurroundedByVowels(dstring str, size_t index)
{
        return (index > 0                        && str[index - 1].isVowel)
            && (index < cast(int) str.length - 1 && str[index + 1].isVowel);
}

dstring replaceSounds(dstring word)
{
        immutable(dstring[dstring]) exchange = [
                "a"    : "a",           "ą"    : "oh",          "b"    : "b",           "c"    : "u",
                "ci"   : "yjn",         "cia"  : "yr",          "cią"  : "yjeh",        "cie"  : "yje",
                "cię"  : "yjeh",        "cio"  : "yje",         "ció"  : "yjy",         "ciu"  : "yjy",
                "ch"   : "s",           "cz"   : "y",           "ć"    : "yj",          "d"    : "a",
                "dz"   : "u",           "dzi"  : "yjn",         "dzia" : "yr",          "dzią" : "yjeh",
                "dzie" : "yje",         "dzię" : "yjeh",        "dzio" : "yje",         "dzió" : "yjy",
                "dziu" : "yjy",         "dź"   : "yj",          "dż"   : "y",           "e"    : "e",
                "ę"    : "eh",          "f"    : "d",           "g"    : "t",           "h"    : "s",
                "i"    : "n",           "ia"   : "r",           "ią"   : "ieh",         "ie"   : "ie",
                "ię"   : "ieh",         "ii"   : "ṅų",          "io"   : "ie",          "ió"   : "iy",
                "iu"   : "iy",          "j"    : "ṅ",           "ja"   : "r",           "ją"   : "jeh",
                "je"   : "je",          "ję"   : "jeh",         "ji"   : "ṅų",          "jo"   : "je",
                "jó"   : "ṅy",          "ju"   : "ṅy",          "k"    : "k",           "l"    : "l",
                "ł"    : "l",           "m"    : "m",           "n"    : "h",           "ni"   : "ḣn",
                "nia"  : "ḣa",          "nią"  : "ḣeh",         "nie"  : "ḣe",          "nię"  : "ḣeh",
                "nii"  : "ḣų",          "nio"  : "ḣe",          "nió"  : "ḣy",          "niu"  : "ḣy",
                "ń"    : "ḣ",           "o"    : "o",           "ó"    : "y",           "p"    : "t",
                "r"    : "p",           "rz"   : "si",          "rzo"  : "sie",         "s"    : "š",
                "si"   : "vin",         "sia"  : "vir",         "sią"  : "vieh",        "sie"  : "vie",
                "się"  : "vieh",        "sio"  : "vie",         "sió"  : "viy",         "siu"  : "viy",
                "sz"   : "v",           "ś"    : "vi",          "t"    : "t",           "u"    : "y",
                "w"    : "b",           "y"    : "i",           "z"    : "č",           "zi"   : "ċų",
                "zia"  : "ċir",         "zią"  : "ċeh",         "zie"  : "ċe",          "zię"  : "ċeh",
                "zio"  : "ċe",          "zió"  : "ċy",          "ziu"  : "ċy",          "ź"    : "ċ",
                "ż"    : "ṡ",           "żo"   : "ṡe",
        ];

        immutable(dstring[]) digraphs = [
                "ci", "ch", "cz",
                "dz", "dź", "dż",
                "ia", "ią", "ie", "ię", "ii", "io", "ió", "iu",
                "ja", "ją", "je", "ję", "ji", "jo", "jó", "ju",
                "ni",
                "rz",
                "si", "sz",
                "zi",
                "żo",
        ];

        immutable(dstring[]) trigraphs = [
                "cia", "cią", "cie", "cię", "cio", "ció", "ciu",
                "dzi",
                "nia", "nią", "nie", "nię", "nii", "nio", "nió", "niu",
                "rzo",
                "sia", "sią", "sie", "się", "sio", "sió", "siu",
                "zia", "zią", "zie", "zię", "zio", "zió", "ziu",
        ];

        immutable(dstring[]) polygraphs = [
                "dzia", "dzią", "dzie", "dzię", "dzio", "dzió", "dziu",
        ];

        dchar[] result;
        for (int i; i < word.length; ++i)
        {
                /**/ if (i < cast(int) word.length - 3 && polygraphs.canFind(word[i .. i + 4]))
                {
                        result ~= exchange[word[i .. i + 4]];
                        i += 3;
                }
                else if (i < cast(int) word.length - 2 && trigraphs.canFind(word[i .. i + 3]))
                {
                        result ~= exchange[word[i .. i + 3]];
                        i += 2;
                }
                else if (i < cast(int) word.length - 1 && digraphs.canFind(word[i .. i + 2]))
                {
                        result ~= exchange[word[i .. i + 2]];
                        ++i;
                }
                else if (""d ~ word[i] in exchange)
                {
                        result ~= exchange[""d ~ word[i]];
                }
                else
                {
                        result ~= word[i];
                }
        }

        return result.idup;
}

dstring normalize(dstring halfPishtolc)
{
        dchar[] result;
        for (int i; i < halfPishtolc.length; ++i)
        {
                switch (halfPishtolc[i])
                {
                        case 'a':
                        {
                                if (i < cast(int) halfPishtolc.length - 1 && halfPishtolc[i + 1] == 'a')
                                {
                                        if (i < cast(int) halfPishtolc.length - 2 && halfPishtolc[i + 2] == 'a')
                                        {
                                                result ~= "ą"d;
                                                i += 2;
                                        }
                                        else
                                        {
                                                result ~= "ä"d;
                                                ++i;
                                        }
                                }
                                else
                                {
                                        result ~= "a"d;
                                }
                                break;
                        }

                        case 'y':
                        {
                                if (i < cast(int) halfPishtolc.length - 1 && halfPishtolc[i + 1] == 'y')
                                {
                                        result ~= "ÿ"d;
                                        ++i;
                                }
                                else
                                {
                                        result ~= "y"d;
                                }
                                break;
                        }

                        case 'i':
                        {
                                if (i < cast(int) halfPishtolc.length - 1 && halfPishtolc[i + 1] == 'i')
                                {
                                        result ~= "ï"d;
                                        ++i;
                                }
                                else if (halfPishtolc.isSurroundedByVowels(i))
                                {
                                        result ~= "j"d;
                                }
                                else
                                {
                                        result ~= "i"d;
                                }
                                break;
                        }

                        case 'h':
                        {
                                result ~= "h"d;
                                if (i < cast(int) halfPishtolc.length - 1 && halfPishtolc[i + 1] == 'h')
                                {
                                        ++i;
                                }
                                break;
                        }

                        case 'r':
                        {
                                if (halfPishtolc.isAdjacentToVowel(i))
                                {
                                        result ~= "r"d;
                                }
                                else
                                {
                                        result ~= "ir"d;
                                }
                                break;
                        }

                        case 'n':
                        {
                                if (    i == cast(int) halfPishtolc.length - 1
                                        || halfPishtolc.isAdjacentToVowel(i)
                                ) {
                                        if (    i == cast(int) halfPishtolc.length - 1 && i > 1
                                                && halfPishtolc[i - 1].isConsonant
                                        ) {
                                                result ~= "ė"d;
                                        }
                                        result ~= "n"d;
                                }
                                else
                                {
                                        result ~= "ų"d;
                                }
                                break;
                        }

                        case 't':
                        {
                                if (i == cast(int) halfPishtolc.length - 1)
                                {
                                        result ~= halfPishtolc[i];
                                        break;
                                }
                                if (halfPishtolc[i + 1] == 's')
                                {
                                        result ~= "c"d;
                                        ++i;
                                        break;
                                }
                                goto case;
                        }

                        case 'b', 'p', 'd', 'k', 'c', 'č':
                        {
                                int[dchar] hierarchy = [
                                        'b' : 1, 'p' : 1,
                                        'd' : 2, 't' : 2,
                                        'k' : 3,
                                        'c' : 4, 'č' : 4,
                                ];

                                if (i == cast(int) halfPishtolc.length - 1 || halfPishtolc[i + 1] !in hierarchy)
                                {
                                        result ~= halfPishtolc[i];
                                        break;
                                }

                                if (halfPishtolc[i .. i + 2] == "kt"d)
                                {
                                        result ~= "kt"d;
                                        ++i;
                                }
                                else if (hierarchy[halfPishtolc[i]] > hierarchy[halfPishtolc[i + 1]])
                                {
                                        result ~= halfPishtolc[i++] ~ "f"d;
                                }
                                else if (hierarchy[halfPishtolc[i]] <= hierarchy[halfPishtolc[i + 1]])
                                {
                                        result ~= "f"d ~ halfPishtolc[++i];
                                }
                                else
                                {
                                        result ~= halfPishtolc[i];
                                }
                                break;
                        }

                        default:
                        {
                                result ~= halfPishtolc[i];
                                break;
                        }
                }
        }

        return result.idup;
}

dstring reduceConsonantClusters(dstring almostPishtolc)
{
        dchar[] result;
        for (int i; i < almostPishtolc.length; ++i)
        {
                if (    almostPishtolc[i].isObstructiveConsonant
                        && i < cast(int) almostPishtolc.length - 1
                        && almostPishtolc[i + 1].isObstructiveConsonant
                ) {
                        if (    i < cast(int) almostPishtolc.length - 2
                                && almostPishtolc[i + 2].isObstructiveConsonant
                        ) {
                                if (    i < cast(int) almostPishtolc.length - 3
                                        && almostPishtolc[i + 3].isObstructiveConsonant
                                ) {
                                        result ~= almostPishtolc[i .. i + 2] ~ "ė"d
                                                ~ almostPishtolc[i + 2 .. i + 4];
                                        i += 3;
                                }
                                else
                                {
                                        result ~= almostPishtolc[i] ~ "ė"d
                                                ~ almostPishtolc[i + 1 .. i + 3];
                                        i += 2;
                                }
                        }
                        else if (almostPishtolc[i + 1] == 'n' && !almostPishtolc.isAdjacentToVowel(i + 1))
                        {
                                result ~= almostPishtolc[i] ~ "ėn"d;
                                ++i;
                        }
                        else
                        {
                                result ~= almostPishtolc[i .. i + 2];
                                ++i;
                        }
                }
                else
                {
                        result ~= almostPishtolc[i];
                }
        }

        return result.idup;
}