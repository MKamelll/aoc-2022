import std.stdio;
import std.typecons;
import std.array;
import std.string;
import std.algorithm;
import std.conv;

class Assignment
{
    private long mStart;
    private long mEnd;

    this (long start, long end)
    {
        mStart = start;
        mEnd = end;
    }


    this (long[] range)
    {
        mStart = range[0];
        mEnd = range[1];
    }

    long start()
    {
        return mStart;
    }

    long end()
    {
        return mEnd;
    }

    override string toString()
    {
        return "Assignment(start: " ~ to!string(mStart) ~ ", end: " ~ to!string(mEnd) ~ ")"; 
    }
}

class AssignmentPair
{
    private Assignment mFirst;
    private Assignment mSecond;

    this (Assignment first, Assignment second)
    {
        mFirst = first;
        mSecond = second;
    }

    Assignment first()
    {
        return mFirst;
    }

    Assignment second()
    {
        return mSecond;
    }

    bool doOverlap()
    {
        return (mFirst.start >= mSecond.start
            && mFirst.end <= mSecond.end)
            || (mSecond.start >= mFirst.start && mSecond.end <= mFirst.end);
    }

    bool doIntersect()
    {
        long[] arr1;
        long[] arr2;
        long i = mFirst.start;
        while (i <= mFirst.end)
        {
            arr1 ~= i;
            i++;
        }

        i = mSecond.start;
        while (i <= mSecond.end)
        {
            arr2 ~= i;
            i++;
        }

        return setIntersection(arr1.sort, arr2.sort).array.length > 0;
    }

    override string toString()
    {
        return "Pair(first: " ~ to!string(mFirst) ~ ", second: " ~ to!string(mSecond) ~ ")"; 
    }

}

AssignmentPair[] fileToAssignmentPairs(string path)
{
    auto f = File(path, "r").byLine;

    AssignmentPair[] result;
    foreach (line; f)
    {
        auto ranges = line.split(",").map!(range => range.split("-").map!(ch => to!long(ch)).array).array;
        auto assignments = ranges.map!(range => new Assignment(range));
        long i = 0;
        while (i + 1 < assignments.length)
        {
            result ~= new AssignmentPair(assignments[i], assignments[i+1]);
            i += 2;
        }
    }

    return result;
}

auto partOne(AssignmentPair[] pairs)
{
    return pairs.filter!(pair => pair.doOverlap).array.length;
}

auto partTwo(AssignmentPair[] pairs)
{
    return pairs.filter!(pair => pair.doIntersect).array.length;    
}

void main()
{
    auto test = "source/test.txt";
    auto input = "source/input.txt";
	writeln(partOne(fileToAssignmentPairs(test)));
    writeln(partOne(fileToAssignmentPairs(input)));
    writeln(partTwo(fileToAssignmentPairs(test)));
    writeln(partTwo(fileToAssignmentPairs(input)));
}
