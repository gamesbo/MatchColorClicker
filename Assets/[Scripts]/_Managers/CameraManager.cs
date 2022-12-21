using UnityEngine;
using System.Collections;

namespace EKTemplate
{
    public class CameraManager : MonoBehaviour
    {
        public Transform target;
        public Vector3 direction;
        public float distance = 20f;
        #region Singleton
        public static CameraManager instance = null;

        private void Awake()
        {
            if (instance == null)
            {
                instance = this;
            }
        }
        #endregion
        private void Update()
        {
            Refresh();

        }
        public void Refresh()
        {
            if (target == null)
            {
                Debug.LogWarning("Missing target ref !", this);
                return;
            }
            Vector3 pos = target.position + (target.TransformDirection(direction) * distance);
            transform.position = Vector3.Lerp(transform.position, pos, Time.deltaTime * 5f);
            Vector3 lookDir = target.position - transform.position;
            transform.rotation = Quaternion.Lerp(transform.rotation, Quaternion.LookRotation(lookDir), Time.deltaTime * 10f);
        }
    }
}
