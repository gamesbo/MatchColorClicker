using UnityEngine;
using EKTemplate;
using DG.Tweening;
public class Roller : MonoBehaviour
{
    private bool onPlay = false;
    public bool middleRotate = false;
    public float speed = 150f;
    public float middleSpeed = 150f;
    void Start()
    {
        LevelManager.instance.startEvent.AddListener(() => StartEvent());
    }
    public void StartEvent()
    {
        onPlay = true;
        if (!middleRotate)
        {
            Scale();
        }
    }
    public void Scale()
    {
        if (transform.localScale.z > 0.55f)
        {
            Debug.Log("end");
        }
        if (transform.localScale.z > 0.55f) return;
        LevelContainer.instance.PaintObj.DOLocalMove(new Vector3(LevelContainer.instance.PaintObj.localPosition.x + 0.11f,-0.59f, 0), 1.1f);
        LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Scale = new Vector3(LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Scale.x,
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Scale.y + 0.28f,
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Scale.z);
        transform.DOScale(new Vector3(transform.localScale.x, transform.localScale.y, transform.localScale.z + 0.01f), 1.1f).OnComplete(()=> { Scale(); });
    }
    void Update()
    {
        if (onPlay)
        {
            if (middleRotate)
            {
                transform.Rotate(-1 * Vector3.down * Time.deltaTime * middleSpeed);
            }
            else
            {
                transform.Rotate(-1 * Vector3.forward * Time.deltaTime * speed);
            }
        }
    }
}
