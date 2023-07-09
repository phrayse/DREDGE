//  DREDGE AutoSplitter v1.0
//  Author: Phrayse
//  Big ups to SirBorris, and Joel from Black Salt Games.

state("DREDGE") {}

startup
{
    refreshRate = 30;

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "DREDGE";

    dynamic[,] dredgeSettings =
    {
        { null, "relics", "Return Relics", true, "Split upon returning Relics" },
            { "relics", "r1", "Relic 1", true,  null },
            { "relics", "r2", "Relic 2", true,  null },
            { "relics", "r3", "Relic 3", true,  null },
            { "relics", "r4", "Relic 4", true,  null },
            { "relics", "r5", "Relic 5", false, "Mostly just used by 100% runners" },
        { null, "final", "Final Split", true, "Applies to both Keeper & Collector endings" }
    };

    vars.Helper.Settings.CreateCustom(dredgeSettings, 4, 1, 3, 2, 5);

    vars.Helper.AlertGameTime();
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["IsLoading"] = mono.Make<bool>("AutoSplitterData", "isLoading");
        // vars.Helper["RelicsAcquired"] = mono.Make<int>("AutoSplitterData", "relicsAcquired");
        vars.Helper["RelicsRelinquished"] = mono.Make<int>("AutoSplitterData", "relicsRelinquished");
        vars.Helper["IsRunning"] = mono.Make<int>("AutoSplitterData", "isRunning");

        return true;
    });
}

onStart
{
    vars.startingRelics = current.RelicsRelinquished;
}

start
{
    // isRunning is set to 0 in the main menu
    return old.IsRunning == 0 && current.IsRunning == 1;
}

split
{
    int currentRelic = current.RelicsRelinquished - vars.startingRelics;
    return old.RelicsRelinquished < current.RelicsRelinquished && settings["r" + currentRelic]
        || old.IsRunning == 1 && current.IsRunning == 2 && settings["final"];
}

isLoading
{
    return current.IsLoading;
}
