import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.algorithm;

class Bag
{
    private string[] mFirstComp;
    private string[] mSecondComp;

    this (string first, string second)
    {
        mFirstComp = first.split("");
        mSecondComp = second.split("");
    }

    string[] wholeContent()
    {
        return mFirstComp ~ mSecondComp;
    }

    string[] firstComp()
    {
        return mFirstComp;
    }

    string[] secondComp()
    {
        return mSecondComp;
    }

    string[] compartmentIntersection()
    {
        return setIntersection(mFirstComp.sort.uniq, mSecondComp.sort.uniq).array;
    }

    override string toString()
    {
        return "Bag(firstComp: " ~ to!string(mFirstComp) ~ ", secondComp: " ~ to!string(mSecondComp) ~ ")";
    }
}

class Group
{
    private Bag mFirstBag;
    private Bag mSecondBag;
    private Bag mThirdBag;

    this (Bag first, Bag second, Bag third)
    {
        mFirstBag = first;
        mSecondBag = second;
        mThirdBag = third;
    }

    this (Bag[] bags)
    {
        mFirstBag = bags[0];
        mSecondBag = bags[1];
        mThirdBag = bags[2];
    }

    Bag firstBag()
    {
        return mFirstBag;
    }

    Bag secondBag()
    {
        return mSecondBag;
    }

    string[] bagIntersection()
    {
        return setIntersection(mFirstBag.wholeContent.sort.uniq,
            mSecondBag.wholeContent.sort.uniq, mThirdBag.wholeContent.sort.uniq).array;
    }

    override string toString()
    {
        return "Group(firstBag: " ~ to!string(mFirstBag)
            ~ ", secondBag: " ~ to!string(mSecondBag) ~ ", thirdBag: " ~ to!string(mThirdBag) ~ ")";
    }
}

auto fileToBags(string path)
{
    auto f = File(path, "r").byLine;
    Bag[] bags;

    foreach (line; f)
    {
        auto half = line.length / 2;
        auto firstComp = line[0..half];
        auto secondComp = line[half..$];
        bags ~= new Bag(to!string(firstComp), to!string(secondComp));
    }

    return bags;
}

auto partOne(Bag[] bags, int[string] priorities)
{
    return bags.map!(bag => bag.compartmentIntersection)
               .map!(diffArr => diffArr.map!(diff => priorities[diff]).sum).sum;
}

Group[] bagsToGroups(Bag[] bags, Group[] result = [])
{
    if (bags.length == 0) return result;
    return bagsToGroups(bags[3..$], result ~ new Group(bags[0..3]));
}

auto partTwo(Group[] groups, int[string] priorities)
{
    return groups.map!(group => group.bagIntersection)
                 .map!(diffArr => diffArr.map!(diff => priorities[diff]).sum).sum;
}

void main()
{
    int[string] priorities;

    int i = 1;
    foreach (ch; 'a'..'z')
    {
        priorities[to!string(ch)] = i;
        i++;
    }

    priorities["z"] = i;

    i = 27;
    foreach (ch; 'A'..'Z')
    {
        priorities[to!string(ch)] = i;
        i++;
    }

    priorities["Z"] = i;

    auto bags = fileToBags("source/input.txt");
    auto groups = bagsToGroups(bags);
    
    //writeln(partOne(bags, priorities));
    writeln(partTwo(groups, priorities));
}
