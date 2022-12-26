using System.Collections;
using UnityEngine;
using EKTemplate;
using DG.Tweening;
public class ColorButtons : MonoBehaviour
{
    public GameObject mergeButton;

    public GameObject btnRed;
    public GameObject btnBlue;
    public GameObject btnGreen;

    public GameObject circleBlue;
    public GameObject circleGreen;
    public GameObject circleRed;

    float green = 5;
    float greenTime = 1;
    bool checkGreen = false;

    float blue = 5;
    float blueTime = 1;
    bool checkBlue = false;

    float red = 5;
    float redTime = 1;
    bool checkRed = false;
    #region Circles
    IEnumerator BlueCircle()
    {
        yield return new WaitForSeconds(1);
        blueTime -= (1/blue);
        circleBlue.GetComponent<ProgressBarPro>().Value = blueTime;
        StartCoroutine(BlueCircle());
    }
    IEnumerator RedCircle()
    {
        yield return new WaitForSeconds(1);
        redTime -= (1 / red);
        circleRed.GetComponent<ProgressBarPro>().Value = redTime;
        StartCoroutine(RedCircle());
    }
    IEnumerator GreenCircle()
    {
        yield return new WaitForSeconds(1);
        greenTime -= (1 / green);
        circleGreen.GetComponent<ProgressBarPro>().Value = greenTime;
        StartCoroutine(GreenCircle());
    }
    private void CloseCircles()
    {
        circleBlue.SetActive(false);
        circleRed.SetActive(false);
        circleGreen.SetActive(false);

        redTime = 1f;
        greenTime = 1f;
        blueTime = 1f;

        circleGreen.GetComponent<ProgressBarPro>().Value = 1f;
        circleRed.GetComponent<ProgressBarPro>().Value = 1f;
        circleBlue.GetComponent<ProgressBarPro>().Value = 1f;
    }
    #endregion
    public void BlueButton()
    {
        StopAllCoroutines();
        CloseCircles();
        if (GameManager.instance.money < 50) return;
        GameManager.instance.money -= 50;
        btnBlue.GetComponent<Animator>().SetTrigger("Select");
        circleBlue.SetActive(true);
        StartCoroutine(BlueCircle());

        green = 5;
        red = 5;
        checkGreen = false;
        checkRed = false;
        if (!checkBlue)
        {
            StartCoroutine(DelayBlue());
        }
        else
        {
            blue += 1;
            blueTime = 1f;

        }
        StartCoroutine(DelayBlue());
        IEnumerator DelayBlue()
        {
            checkBlue = true;
            TapManager.instance.selectBased = true;
            TapManager.instance.cylinder.GetComponent<SkinnedMeshRenderer>().materials[1].color = new Color(0f, 0.63f, 0.75f, 1);
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Color = new Color(0.21f, 1f, 0.92f, 1);
            ChangeParticleSplashColor(0f, 0.63f, 0.75f);
            yield return new WaitForSeconds(blue);
            TapManager.instance.selectBased = false;
            checkBlue = false;
            blue = 5;
            circleBlue.SetActive(false);
            blueTime = 1f;
        }
    }
    public void RedButton()
    {
        StopAllCoroutines();
        CloseCircles();
        if (GameManager.instance.money < 50) return;
        GameManager.instance.money -= 50;
        btnRed.GetComponent<Animator>().SetTrigger("Select");
        circleRed.SetActive(true);
        StartCoroutine(RedCircle());

        green = 5;
        blue = 5;
        checkBlue = false;
        checkGreen = false;
        if (!checkRed)
        {
            StartCoroutine(DelayRed());
        }
        else
        {
            red += 1;
            redTime = 1f;
        }
        StartCoroutine(DelayRed());
        IEnumerator DelayRed()
        {
            checkRed = true;
            TapManager.instance.selectBased = true;
            TapManager.instance.cylinder.GetComponent<SkinnedMeshRenderer>().materials[1].color = new Color(0.75f, 0f, 0f, 1);
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Color = new Color(1f, 0.15f, 0.15f, 1);
            ChangeParticleSplashColor(0.75f, 0f, 0f);

            yield return new WaitForSeconds(red);
            TapManager.instance.selectBased = false;
            checkRed = false;
            red = 5;
            circleRed.SetActive(false);
            redTime = 1f;
        }
    }
    public void GreenButton()
    {
        StopAllCoroutines();
        CloseCircles();
        if (GameManager.instance.money < 50) return;
        GameManager.instance.money -= 50;
        btnGreen.GetComponent<Animator>().SetTrigger("Select");
        circleGreen.SetActive(true);
        StartCoroutine(GreenCircle());

        red = 5;
        blue = 5;
        checkBlue = false;
        checkGreen = false;
        if (!checkGreen)
        {
            StartCoroutine(DelayGreen());
        }
        else
        {
            green += 1;
            greenTime = 1f;
        }
        StartCoroutine(DelayGreen());
        IEnumerator DelayGreen()
        {
            checkGreen = true;
            TapManager.instance.selectBased = true;
            TapManager.instance.cylinder.GetComponent<SkinnedMeshRenderer>().materials[1].color = new Color(0.22f, 0.62f, 0.24f, 1);
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Color = new Color(0.25f, 1f, 0.3f, 1);
            ChangeParticleSplashColor(0.22f, 0.62f, 0.24f);

            yield return new WaitForSeconds(green);
            TapManager.instance.selectBased = false;
            checkGreen = false;
            green = 5;
            circleGreen.SetActive(false);
            greenTime = 1f;
        }
    }

    public void ChangeParticleSplashColor(float _r,float _g, float _b)
    {
        LevelContainer.instance.PaintObj.GetChild(0).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
        LevelContainer.instance.PaintObj.GetChild(1).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
        LevelContainer.instance.PaintObj.GetChild(2).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
    }
}
