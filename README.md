#  Polish to Pishtolc

This little project serves me as a dictionary generator for my constructed language – Pishtolc.
The main reason behind making this is the way I create words for this language.
Some words from Polish, and some from Russian are transformed using some form of encryption.
Due to the fact that the language is constantly evolving, and hence the algorithm too, the resulting words often change forms.
However the input data for it never does in such way that the whole dictionary would be re-written due to that.
Thus, I wrote this program in order to avoid rewriting the whole dictionary after any minor change in the algorithm.

## Usage
To build the project just use `dub`. The program is run in the command line.
Each argument from command line, excluding the program name, to the program is treated as the next word to translate:

```bash
$ ./polish-to-pishtolc zrobić sobie wolne
zrobić: čfobnyj
sobie: še
wolne: bolhe
```