import std.stdio;
import std.conv;
import std.algorithm;

auto scanDatastream(string ds, int patternLen)
{
    int index;
    char[] window;

    for (int i = 0; i < ds.length; i++)
    {
        int j = 0;
        while (j < patternLen) {
            if (!window.canFind(ds[i + j])) window ~= ds[i + j];
            j++;
        }

        if (window.length == patternLen) {
            index = i + j;
            break;
        }

        window = [];
    }
    return index;
}

auto partOne(string fName)
{
    auto f = File(fName, "r").byLine;
    auto indices = f.map!(stream => scanDatastream(to!string(stream), 4));

    return indices;
}

auto partTwo(string fName)
{
    auto f = File(fName, "r").byLine;
    auto indices = f.map!(stream => scanDatastream(to!string(stream), 14));

    return indices;
}

void main()
{
	writeln(partOne("source/test.txt"));
    writeln(partOne("source/input.txt"));
    writeln(partTwo("source/test.txt"));
    writeln(partTwo("source/input.txt"));

}