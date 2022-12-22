using UnityEngine;
using System.Collections;

namespace EKTemplate
{
    public class CameraManager : MonoBehaviour
    {
        public bool onMobile = false;
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
            if (onMobile)
            {
                transform.position = new Vector3(0, 14.1f, -11f);
            }
        }
    }
}
