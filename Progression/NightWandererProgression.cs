namespace SpiritualRealmWalker.Progression;

/// <summary>第一版成长规则；累计经验包含当前等级内经验。</summary>
public static class NightWandererProgression
{
    public const int ExperienceCap = 300;
    public static int Clamp(int experience) => Math.Clamp(experience, 0, ExperienceCap);
    public static int Level(int experience) => Math.Min(3, Clamp(experience) / 100 + 1);
    public static int LevelExperience(int experience) => Clamp(experience) - (Level(experience) - 1) * 100;
    public static int TrialTier(int experience) => (200 - Clamp(experience)) switch
    {
        <= 0 => 0,
        <= 30 => 1,
        <= 60 => 2,
        <= 100 => 3,
        _ => 4
    };
}
