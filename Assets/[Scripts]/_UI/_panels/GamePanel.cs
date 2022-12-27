using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

namespace EKTemplate
{
    public class GamePanel : Panel
    {
        public RectTransform coinPanelRect;
        public RectTransform restartButtonRect;

        [HideInInspector] int inGameCurrency;

        public GameObject yellowPrice;
        public GameObject greenPrice;
        public GameObject redPrice;
        public GameObject bluePrice;

        private Tween tween;
        private Text moneyText { get { return coinPanelRect.GetChild(1).GetChild(0).GetComponent<Text>(); } }
        private Button restartButton { get { return restartButtonRect.GetComponent<Button>(); } }

        private void Start()
        {
            restartButton.onClick.AddListener(OnClickRestartButton);
        }
        private void Update()
        {
            moneyText.text = GameManager.instance.money.ToString();

            if (GameManager.instance.money < 50)
            {
                yellowPrice.GetComponent<TMPro.TextMeshProUGUI>().color = new Color(1f, 0.29f, 0.2f, 1);
            }
            else
            {
                yellowPrice.GetComponent<TMPro.TextMeshProUGUI>().color = new Color(0.44f, 1, 0.35f, 1);
            }

            if (GameManager.instance.money < 55)
            {
                bluePrice.GetComponent<TMPro.TextMeshProUGUI>().color = new Color(1f, 0.29f, 0.2f, 1);
            }
            else
            {
                bluePrice.GetComponent<TMPro.TextMeshProUGUI>().color = new Color(0.44f, 1, 0.35f, 1);
            }


            if (GameManager.instance.money < 65)
            {
                redPrice.GetComponent<TMPro.TextMeshProUGUI>().color = new Color(1f, 0.29f, 0.2f, 1);
            }
            else
            {
                redPrice.GetComponent<TMPro.TextMeshProUGUI>().color = new Color(0.44f, 1, 0.35f, 1);
            }


            if (GameManager.instance.money < 85)
            {
                greenPrice.GetComponent<TMPro.TextMeshProUGUI>().color = new Color(1f, 0.29f, 0.2f, 1);
            }
            else
            {
                greenPrice.GetComponent<TMPro.TextMeshProUGUI>().color = new Color(0.44f, 1, 0.35f, 1);
            }
        }
        public void SetMoney(float to, float duration = 0.3f)
        {
            if (tween != null) tween.Kill();

            coinPanelRect
            .DOScale(1.2f, duration * 0.5f)
            .SetEase(Ease.Linear)
            .SetLoops(2, LoopType.Yoyo);

            float startFrom = int.Parse(moneyText.text);
            tween = DOTween.To((x) => startFrom = x, startFrom, to, duration)
            .OnUpdate(() =>
            {
                moneyText.text = ((int)startFrom).ToString();
            })
            .OnComplete(() => moneyText.text = ((int)to).ToString());
        }

        public void AddMoney(int amount)
        {
            float startFrom = int.Parse(moneyText.text);
            SetMoney(inGameCurrency + amount);
        }

        private void OnClickRestartButton()
        {
            GameManager.instance.RestartScene();
        }
    }
}