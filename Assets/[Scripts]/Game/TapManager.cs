using System.Collections;
using UnityEngine;
using EKTemplate;
using DG.Tweening;
public class TapManager : MonoBehaviour
{
    private float clickSpeed;
    private float clickFactor;
    private float FollowSpeed;
    private bool canClick = true;
    public float speed;
    public float rotateSpeed;
    #region Singleton
    public static TapManager instance = null;
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
        LevelManager.instance.startEvent.AddListener(OnStarted);
    }
    public void OnUpgradeButtonEnter()
    {
        canClick = false;
    }
    public void OnStarted()
    {
        clickSpeed = 0.3f;
        clickFactor = 2f;
    }
    void Update()
    {
        if (canClick)
        {
            if (Input.GetMouseButtonDown(0))
            {
                Haptic.LightTaptic();
                if (clickDelayEnum != null)
                {
                    StopCoroutine(clickDelayEnum);
                    FollowSpeed = rotateSpeed;
                }
                clickDelayEnum = ClickDelay(clickSpeed);
                StartCoroutine(clickDelayEnum);
                FollowSpeed = FollowSpeed * clickFactor;
                ChangeSpeed(FollowSpeed);
            }
        }
        canClick = true;
    }
    private IEnumerator clickDelayEnum;
    public IEnumerator ClickDelay(float _clickSpeed)
    {
        yield return new WaitForSeconds(_clickSpeed);
        FollowSpeed = 2f;
        ChangeSpeed(FollowSpeed);
    }
    private Tween SpeedTween;
    public void ChangeSpeed(float _newSpeed)
    {
        float Speed = speed;
        SpeedTween?.Kill();
        SpeedTween = DOTween.To(() => Speed, x => Speed = x, _newSpeed, 0.25f).SetEase(Ease.Linear)
            .OnUpdate(() =>
            {
                speed = Speed;
            });
    }
}
