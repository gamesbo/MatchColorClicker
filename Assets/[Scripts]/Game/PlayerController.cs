using System.Collections;
using UnityEngine;
using EKTemplate;
using DG.Tweening;
using Dreamteck.Splines;
public class PlayerController : MonoBehaviour
{
    [Header("VARIABLES")]
    public float speed = 5f;
    public static bool canMove, _swerve = false;
    public static Vector3 pos;
    public float speedstrech;
    [Header("OtherThings")]
    public GameObject[] Stickmans;
    public SplineComputer spline;
    public float distance;
    private float offsetX = 0f;
    private int stickmanLevel;
    #region Singleton

    public static PlayerController instance = null;

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
    private void StartEvent()
    {
        canMove = true;
        _swerve = true;
    }
    void Update()
    {
        Movement();
    }
  
    #region Movement
    void Movement()
    {
        if (canMove)
        {
                distance += speed * Time.deltaTime;

                SplineSample ss = spline.Evaluate(spline.Travel(0, distance));
                //if (_swerve)
                //{
                //    offsetX += Time.fixedDeltaTime * InputManager.instance.input.x * speedstrech;
                //    offsetX = Mathf.Clamp(offsetX, -3, 3);
                //}
                transform.position = new Vector3(ss.position.x, ss.position.y, ss.position.z) + ss.right * offsetX;
                transform.rotation = ss.rotation;
            }
    }
    #endregion
}
