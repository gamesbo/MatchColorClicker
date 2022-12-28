using UnityEngine;
using EKTemplate;
using DG.Tweening;
public class Roller : MonoBehaviour
{
    private bool onPlay = false;
    public bool middleRotate = false;
    public float speed = 150f;
    public float middleSpeed = 150f;
    #region Singleton
    public static Roller instance = null;
    private void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }
    #endregion
    void Start()
    {
        LevelManager.instance.startEvent.AddListener(() => StartEvent());
    }
    public void StartEvent()
    {
        onPlay = true;    
    }
   
    void Update()
    {
        if (onPlay)
        {
            if (middleRotate)
            {
                transform.Rotate(-1 * Vector3.down * Time.deltaTime * TapManager.instance.speed);
            }
            else
            {
                transform.Rotate(-1 * Vector3.forward * Time.deltaTime * (TapManager.instance.speed *3f));
            }
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if (LevelContainer.instance.isYellow && !other.GetComponent<Percent>().isTouch)
        {
            if (other.CompareTag("Percent"))
            {
                LevelContainer.instance.percent.Add(other.gameObject);
                other.GetComponent<Percent>().isTouch = true;
            }
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (!LevelContainer.instance.isYellow)
        {
            if (other.CompareTag("Percent"))
            {
                LevelContainer.instance.percent.Remove(other.gameObject);
                other.GetComponent<Percent>().isTouch = false;

            }
        }
    }
}
