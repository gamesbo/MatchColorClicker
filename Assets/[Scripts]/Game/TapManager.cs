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
    public Transform cylinder;
    public Tween tw;
    public Material selectedColor;
    public Material basedColor;
    public bool selectBased = false;
    public bool isGameOver = false;
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
        LevelContainer.instance.levelTargetObj.SetActive(true);
    }
    public void ChangeParticleSplashColor(float _r, float _g, float _b)
    {
        LevelContainer.instance.PaintObj.GetChild(0).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
        LevelContainer.instance.PaintObj.GetChild(1).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
        LevelContainer.instance.PaintObj.GetChild(2).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
    }
    void Update()
    {
        if (isGameOver) return;
        if (!selectBased)
        {
            cylinder.GetComponent<SkinnedMeshRenderer>().materials[1].color = new Color(0.6f, 0.77f, 0.8f, 1);
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Color = new Color(0.85f, 1f, 0.95f, 1);
            LevelContainer.instance.isYellow = false;
            ChangeParticleSplashColor(0.6f, 0.77f, 0.8f);
        }
        if (canClick)
        {
            if (Input.GetMouseButtonDown(0))
            {
                Haptic.LightTaptic();
                if (cylinder.localScale.z > 0.6f)
                {
                    isGameOver = true;
                    LevelManager.instance.Success();
                }
                if (cylinder.localScale.z < 0.61f)
                {
                    if (tw == null)
                    {
                        LevelContainer.instance.PaintObj.DOLocalMove(new Vector3(LevelContainer.instance.PaintObj.localPosition.x + 0.10f, -0.59f, 0), 1.2f);
                        LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Scale = new Vector3(LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Scale.x,
                            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Scale.y + 0.262f,
                            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Scale.z);
                        tw = cylinder.DOScale(new Vector3(cylinder.localScale.x, cylinder.localScale.y, cylinder.localScale.z + 0.01f), 1.2f).OnComplete(()=> { tw = null; });
                    }
                }
                GameObject money = Instantiate(Resources.Load("plusmoney"),new Vector3(transform.position.x + Random.Range(-2.9f,2.9f), transform.position.y + 2.7f, transform.position.z + 1.75f), Quaternion.Euler(24f,0,0))as GameObject;
                money.transform.DOScale(1, 1.3f).SetEase(Ease.OutBounce).OnComplete(() =>
                {
                    Destroy(money,0.2f);
                });
                GameManager.instance.AddMoney(5);
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
