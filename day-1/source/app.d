import std.stdio;
import std.conv;
import std.array;
import std.string;
import std.algorithm;

class Elv
{
    long[] mCalories;
    this (long[] calories)
    {
        mCalories = calories;
    }

    long[] calories()
    {
        return mCalories;
    }

    override bool opEquals(Elv)(const Elv other) const
    {
        return mCalories.sum == other.calories.sum;
    }

    int opCmp(Elv other) const
    {
        return to!int(mCalories.sum - other.calories.sum);
    }

    override string toString()
    {
        return "Elv(" ~ to!string(mCalories) ~ ")";
    }
}

auto fileToElves(string path)
{
    auto f = File(path).byLine;
    long[] calories;
    Elv[] elves;
    foreach (calorie; f)
    {
        if (calorie.length == 0) {
            elves ~= new Elv(calories);
            calories = [];
        } else {
            calories ~= to!long(calorie);
        }
    }
    elves ~= new Elv(calories);
    return elves;
}

long partOne(Elv[] elves)
{
    return elves.map!(elv => elv.calories.sum).array.maxElement;
}

auto partTwo(Elv[] elves)
{
    return elves.sort[$-3..$].map!(elv => elv.calories.sum).sum;
}

void main()
{
    auto elves = fileToElves("source/input.txt");
    writeln(partTwo(elves));
}
