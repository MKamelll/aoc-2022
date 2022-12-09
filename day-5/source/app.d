import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.typecons;
import std.algorithm;
import std.ascii;

struct Move
{
    long crateCount;
    long from;
    long destination;

    this (long c, long f, long d)
    {
        crateCount = c;
        from = f - 1;
        destination = d - 1;
    }

    string toString() const @safe pure nothrow
    {
        return "Move(crate: " ~ to!string(crateCount)
            ~ ", from: " ~ to!string(from) ~ ", destination: " ~ to!string(destination) ~ ")";
    }
}

class Stack
{
    private string[] mCrates;

    this (string[] crates)
    {
        mCrates = crates;
    }

    string[] crates()
    {
        return mCrates;
    }

    void pop()
    {
        mCrates = mCrates[0..$-1];
    }

    void addCrate(string crate)
    {
        mCrates ~= crate;
    }

    void addCrates(string[] crates)
    {
        mCrates ~= crates;
    }

    override string toString()
    {
        return "Stack(" ~ to!string(mCrates) ~ ")";
    }
}

class Crane
{
    private Stack[] mStacks;
    
    this (Stack[] stackes)
    {
        mStacks = stackes;
    }

    Stack[] stacks()
    {
        return mStacks;
    }

    Crane shift(Move[] moves)
    {
        foreach (move; moves)
        {    
            auto fromStack = mStacks[move.from];
            auto toStack = mStacks[move.destination];
            auto numOfCrates = move.crateCount;
            for (long i = 0; i < numOfCrates; i++)
            {
                toStack.addCrate(fromStack.crates[$-1]);
                fromStack.pop();
            }
        }
        return this;
    }

    Crane shiftWithSameOrder(Move[] moves)
    {
        foreach (move; moves)
        {    
            auto fromStack = mStacks[move.from];
            auto toStack = mStacks[move.destination];
            auto numOfCrates = move.crateCount;
            auto movedCrates = fromStack.crates[$-numOfCrates..$];
            toStack.addCrates(movedCrates);
            for (long i = 0; i < numOfCrates; i++)
            {
                fromStack.pop();
            }
        }
        return this;
    }

    override string toString()
    {
        return "Crane(" ~ to!string(mStacks) ~ ")";
    }
}

auto fileToCraneAndMoves(string path)
{
    auto f = File(path, "r").byLine;

    char[][ulong] lines;
    Stack[] stacks;
    foreach (line; f)
    {
        if (line.length < 1) break;
        auto stack = line.split("");
        foreach (i, s; stack)
        {
            if (isAlpha(to!char(s))) lines[i] ~= s;
        }
    }
    auto keys = lines.keys.sort;
    foreach (key; keys)
    {
        stacks ~= new Stack(to!(string[])(lines[key].reverse.split("")));
    }
    
    auto crane = new Crane(stacks);

    Move[] moves;

    foreach (line; f)
    {
        if (line.length < 1) continue;
        auto nums = line.split(" ").filter!(s => isNumeric(s)).map!(s => to!(long)(s)).array;
        moves ~= Move(nums[0], nums[1], nums[2]);
    }

    return tuple(crane, moves);
}

auto partOne(Crane crane, Move[] moves)
{
    crane = crane.shift(moves);
    return crane.stacks.map!(stack => stack.crates[$-1]).join("");
}

auto partTwo(Crane crane, Move[] moves)
{
    crane = crane.shiftWithSameOrder(moves);
    return crane.stacks.map!(stack => stack.crates[$-1]).join("");
}

void main()
{
    auto test = "source/test.txt";
    auto input = "source/input.txt";
    auto result = fileToCraneAndMoves(input);
    auto crane = result[0];
    auto moves = result[1];
	writeln(partTwo(crane, moves));
}
