# 🏈 Takım Logoları - Alternatif İndirme Yöntemleri

SofaScore API 403 hatası verdiği için alternatif yöntemler:

## ✅ YÖNTEM 1: GitHub'dan Hazır Paket (ÖNERİLEN)

### Adım 1: Repo'yu klonlayın veya ZIP indirin
```bash
# Terminal'de çalıştırın:
cd ~/Downloads
git clone https://github.com/lemoncode/football-team-logos.git
```

Ya da direkt: https://github.com/lemoncode/football-team-logos/archive/refs/heads/master.zip

### Adım 2: Logoları kopyalayın
Logoları `assets/images/team_logos/` klasörüne kopyalayın ve Team ID'ye göre yeniden isimlendirin.

**Önemli Takım ID'leri:**
- Manchester City → `17.png`
- Manchester United → `18.png`
- Chelsea → `19.png`
- Liverpool → `20.png`
- Arsenal → `21.png`
- Barcelona → `2829.png`
- Real Madrid → `2817.png`
- Bayern Munich → `2672.png`
- PSG → `1644.png`

---

## ✅ YÖNTEM 2: Wikimedia Commons (Telif Hakkı Yok)

1. Git: https://commons.wikimedia.org/wiki/Category:Association_football_team_logos
2. Takım logosunu bul
3. "Download" butonuna tıkla
4. PNG formatında indir
5. Team ID ile yeniden isimlendirip kopyala

---

## ✅ YÖNTEM 3: API-Sports (RapidAPI)

### Ücretsiz hesap oluşturun:
1. https://rapidapi.com/api-sports/api/api-football
2. Subscribe to Test (Ücretsiz 100 istek/gün)
3. API key alın

### Python script ile indirin:
```python
import requests

api_key = "YOUR_RAPIDAPI_KEY"
team_id = 33  # Manchester City

url = f"https://v3.football.api-sports.io/teams?id={team_id}"
headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': api_key
}

response = requests.get(url, headers=headers)
data = response.json()
logo_url = data['response'][0]['team']['logo']

# Logo'yu indir
logo_response = requests.get(logo_url)
with open(f'{team_id}.png', 'wb') as f:
    f.write(logo_response.content)
```

---

## ✅ YÖNTEM 4: Manuel Browser İndirme

### Chrome/Safari kullanarak:

1. **Developer Tools'u açın** (F12 veya Cmd+Option+I)
2. **Network sekmesine** gidin
3. **Browser'da** takım logosunu gösterin: `https://www.sofascore.com/team/football/barcelona/2829`
4. Network'te **"image"** tipindeki istekleri filtreleyin
5. Logo isteğini bulun ve **sağ tıklayıp "Copy as cURL"**
6. Terminal'de yapıştırın ve `-o 2829.png` ekleyin

---

## 🎨 Basit Çözüm: Emoji Placeholder

Logo bulamazsanız geçici olarak emoji kullanabilirsiniz:

`lib/core/utils/team_logo_manager.dart` dosyasında:

```dart
// Fallback to emoji if logo not found
return Text(
  '⚽',
  style: TextStyle(fontSize: size * 0.6),
);
```

---

## 📦 Hızlı Test İçin Sample Logolar

Birkaç örnek logo manuel indirip test edebilirsiniz:

1. Barcelona (2829): https://tmssl.akamaized.net/images/wappen/head/131.png
2. Real Madrid (2817): https://tmssl.akamaized.net/images/wappen/head/418.png
3. Man City (17): https://tmssl.akamaized.net/images/wappen/head/281.png
4. Liverpool (20): https://tmssl.akamaized.net/images/wappen/head/31.png

Bu URL'leri browser'da açıp "Farklı Kaydet" yapın.

---

## ⚡ Hızlı Başlangıç

Test için sadece 5-10 popüler takımın logosunu indirin. Diğerleri için shield ikonu gösterilecek.

**Minimum Set:**
- 2829.png (Barcelona)
- 2817.png (Real Madrid)
- 17.png (Man City)
- 20.png (Liverpool)
- 2672.png (Bayern)

Bu kadarı bile uygulamayı test etmek için yeterli!
