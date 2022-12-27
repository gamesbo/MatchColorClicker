using UnityEngine;
public class LevelContainer : MonoBehaviour
{
    #region Singleton

    public static LevelContainer instance = null;

    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }
    #endregion
    public Transform PaintObj;
    public GameObject levelTargetObj;

    public int totalRedCount;
    public int totalBlueCount;
    public int totalGreenCount;
    public int totalYellowCount;

}
