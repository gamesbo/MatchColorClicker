using UnityEngine;
using DG.Tweening;
using EKTemplate;

[SelectionBase]
public class Money : MonoBehaviour
{
    void Start()
    {
        transform.DORotate(transform.eulerAngles + new Vector3(0f, 360f, 0f), 2f, RotateMode.FastBeyond360).SetLoops(-1).SetEase(Ease.Linear).SetLink(gameObject);
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Destroy(gameObject);
            //Destroy(Instantiate(Resources.Load<GameObject>("money-collect-effect"), transform.position + Vector3.up * 0.5f, Quaternion.Euler(-90f, 0f, 0f)), 2f);
            //if (DataManager.instance.vibration) Haptic.MediumTaptic();
        }
    }
}
