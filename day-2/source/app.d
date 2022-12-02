import std.stdio;
import std.typecons;
import std.algorithm;
import std.array;
import std.string;
import std.conv;

enum Choice
{
    ROCK = 1, PAPER = 2, SCISSORS = 3
}

alias Round = Tuple!(Choice, "firstPlayer", Choice, "secondPlayer");

Choice letterToChoice(char[] s)
{
    switch (s)
    {
        case "A": case "X": return Choice.ROCK;
        case "B": case "Y": return Choice.PAPER;
        case "C": case "Z": return Choice.SCISSORS;
        default: break;
    }
    
    throw new Exception("Unknown character '" ~ to!string(s) ~ "'");
}

int roundResult(Round round)
{
    if (round.firstPlayer == round.secondPlayer) return 3;
    Round[] wins = [Round(Choice.SCISSORS, Choice.ROCK),
                    Round(Choice.PAPER, Choice.SCISSORS), Round(Choice.ROCK, Choice.PAPER)];
    if (wins.canFind(round)) return 6;
    return 0;
}

int selectionBonus(Round round)
{
    return to!int(round.secondPlayer);
}

Round[] fileToRounds(string path)
{
    Round[] result;
    auto f = File(path, "r").byLine;
    foreach (line; f)
    {
        auto choices = line.split(" ");
        result ~= Round(letterToChoice(choices[0]), letterToChoice(choices[1]));
    }

    return result;
}

enum Decision
{
    WIN, LOSE, DRAW
}

Decision letterToDecision(char[] s)
{
    switch(s)
    {
        case "X": return Decision.LOSE;
        case "Y": return Decision.DRAW;
        case "Z": return Decision.WIN;
        default: break;
    }

    throw new Exception("Don't know what to do with '" ~ to!string(s) ~ "'");
}

Round getARound(Choice firstPlayer, Decision decision)
{
    Choice secondPlayer;
    Round[] wins = [Round(Choice.SCISSORS, Choice.ROCK),
                    Round(Choice.PAPER, Choice.SCISSORS), Round(Choice.ROCK, Choice.PAPER)];
    Round[] defeats = [Round(Choice.ROCK, Choice.SCISSORS),
                    Round(Choice.SCISSORS, Choice.PAPER), Round(Choice.PAPER, Choice.ROCK)];
    if (decision == Decision.WIN) {
        foreach (round; wins)
        {
            if (round.firstPlayer == firstPlayer) {
                secondPlayer = round.secondPlayer;
                break;
            }
        }
    } else if (decision == Decision.LOSE) {
        foreach (round; defeats)
        {
            if (round.firstPlayer == firstPlayer) {
                secondPlayer = round.secondPlayer;
                break;
            }
        }
    } else {
        secondPlayer = firstPlayer;
    }

    return Round(firstPlayer, secondPlayer);
}

Round[] fileToRoundsPartTwo(string path)
{
    Round[] result;
    auto f = File(path, "r").byLine;
    foreach (line; f)
    {
        auto choices = line.split(" ");
        auto firstPlayer = letterToChoice(choices[0]);
        auto decision = letterToDecision(choices[1]);
        result ~= getARound(firstPlayer, decision);
    }

    return result;
}

auto partOne(string path)
{
    auto rounds = fileToRounds(path);
    return rounds.map!(round => roundResult(round) + selectionBonus(round)).sum;
}

auto partTwo(string path)
{
    auto rounds = fileToRoundsPartTwo(path);
    return rounds.map!(round => roundResult(round) + selectionBonus(round)).sum;
}

void main()
{
    writeln(partTwo("source/input.txt"));
}
