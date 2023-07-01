//  DREDGE AutoSplitter v1.0
//  Author: Phrayse

state("DREDGE")
{
    // v1.2.0 prod | build 1883
    // bool isLoading : "UnityPlayer.dll", 0x014DE26C, 0x7C, 0x4, 0x48, 0x1C, 0xC, 0x0, 0x228;
    // int relicCount : "UnityPlayer.dll", 0x014DE26C, 0x7C, 0x4, 0x48, 0x1C, 0xC, 0x0, 0x230;
    // int isRunning : "UnityPlayer.dll", 0x014AD6D4, 0x138, 0x110, 0x370, 0x210, 0x80, 0x2C, 0x2CC;
    
    // v1.2.0 prod | build 1892
    bool isLoading : "UnityPlayer.dll", 0x14D23C8, 0x4;
    int isRunning : "UnityPlayer.dll", 0x014AD6D4, 0x138, 0x110, 0x370, 0x220, 0x80, 0x2C, 0x2CC;
    int relicCount : "UnityPlayer.dll", 0x14AD6D4, 0x138, 0x110, 0x370, 0x220, 0x80, 0x2C, 0x2C8;
}

startup
{
    // Set LiveSplit timing method to Game Time to allow for load removal.
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        if (MessageBox.Show("Spooky Boat Game now has load removal!\nEnable it by using Game Time?",
        "DREDGE", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    // Dictionary of all split options.
    vars.splitSettings = new Dictionary<string, Tuple<bool, string, string, string>>()
    {
        {"relics", Tuple.Create(true, "Return Relics", "", "Split upon returning Relics")},
        {"relics1234", Tuple.Create(true, "Relics 1-4", "relics", "Order doesn't matter")},
        {"relic5", Tuple.Create(false, "Relic 5", "relics", "Mostly just used by 100% runners")},
        {"final", Tuple.Create(true, "Final Split", "", "Applies to both Keeper & Collector endings")}
    };

    // Create all split options.
    foreach (var setting in vars.splitSettings)
    {
        settings.Add(setting.Key, setting.Value.Item1, setting.Value.Item2, setting.Value.Item3 != "" ? setting.Value.Item3 : null);
        settings.SetToolTip(setting.Key, setting.Value.Item4);
    }

    // List of all split conditions.
    vars.conditions = new List<Func<bool>>()
    {
        () => current.relicCount == old.relicCount + 1 &&
            (++vars.relicCounter < 5 && settings["relics1234"] ||
            settings["relic5"] && vars.relicCounter > 4),
        () => old.isRunning == 1 && current.isRunning == 2 && settings["final"]
    };
}

init
{
    refreshRate = 30;
}

update
{
    // Debug - change ### to whatever is being tested.
    // if (current.### != old.###)
    // { print("### changed, now " + current.###.ToString()); }
}

onStart
{
    // Initialise counter objects for split settings.
    vars.relicCounter = 0;
}

start
{
    // isRunning is set to 0 in the main menu
    if (old.isRunning == 0 && current.isRunning == 1)
    {
        return true;
    }
}

split
{
    foreach (var condition in vars.conditions)
    {
        if (condition())
        {
            return true;
        }
    }
}

isLoading
{
    return current.isLoading;
}
