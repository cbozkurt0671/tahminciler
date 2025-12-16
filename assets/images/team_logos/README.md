# Takım Logoları - Kurulum Rehberi

Bu klasöre takım logolarını ekleyerek uygulamanın takım logolarını göstermesini sağlayabilirsiniz.

## 📁 Dosya İsimlendirme

Logolar **Team ID** bazlı isimlendirilmelidir:
- Format: `{teamId}.png`
- Örnekler: `2829.png` (Barcelona), `2817.png` (Real Madrid), `17.png` (Manchester City)

## 🔍 Team ID'leri Nereden Bulunur?

1. **SofaScore'dan**: 
   - Takım sayfasına gidin
   - URL'de team ID'yi görebilirsiniz: `sofascore.com/team/football/barcelona/2829`

2. **Konsol Loglarından**:
   - Uygulamayı çalıştırın
   - Debug konsolunda "Team IDs" loglarına bakın

## 🎨 Logo İndirme Kaynakları

### Seçenek 1: SofaScore'dan Manuel İndirme
```
https://api.sofascore.com/api/v1/team/{teamId}/image
```
Browser'da bu URL'yi açıp görseli "Farklı Kaydet" ile indirebilirsiniz.

### Seçenek 2: GitHub Logo Repositories
- [football-team-logos](https://github.com/lemoncode/football-team-logos) - 500+ logo
- [world-cup-2022-teams](https://github.com/dudeonthehorse/datasets) - Dünya kupası takımları

### Seçenek 3: Wikimedia Commons
- Telif hakkı sorunu yok
- Yüksek kalite
- URL: `https://commons.wikimedia.org/wiki/Category:Association_football_team_logos`

### Seçenek 4: Toplu İndirme Script'i (Python)

```python
import requests
import os

# İndirilecek takım ID'leri
team_ids = [
    17, 18, 19, 20, 21, 22,  # Premier League
    2829, 2817, 2833,         # La Liga
    2672, 2673,               # Bundesliga
    2697, 2692, 2687,         # Serie A
    1644,                     # PSG
]

headers = {
    'User-Agent': 'Mozilla/5.0',
    'Referer': 'https://www.sofascore.com/',
}

for team_id in team_ids:
    url = f'https://api.sofascore.com/api/v1/team/{team_id}/image'
    try:
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 200:
            with open(f'{team_id}.png', 'wb') as f:
                f.write(response.content)
            print(f'✅ Downloaded: {team_id}.png')
        else:
            print(f'❌ Failed: {team_id} (Status: {response.status_code})')
    except Exception as e:
        print(f'❌ Error: {team_id} - {e}')
```

## 📝 Logo Özellikleri

- **Format**: PNG (şeffaf arka plan önerilir)
- **Boyut**: 256x256px veya 512x512px (otomatik ölçeklendirilir)
- **Maksimum dosya boyutu**: ~50KB (optimize edilmiş)

## 🎯 Öncelikli Takımlar (İlk Eklenecekler)

### Premier League
- 17 - Manchester City
- 18 - Manchester United  
- 19 - Chelsea
- 20 - Liverpool
- 21 - Arsenal
- 22 - Tottenham

### La Liga
- 2829 - Barcelona
- 2817 - Real Madrid
- 2833 - Atletico Madrid

### Bundesliga
- 2672 - Bayern Munich
- 2673 - Borussia Dortmund

### Serie A
- 2697 - Juventus
- 2692 - Inter Milan
- 2687 - AC Milan

### Diğer
- 1644 - PSG

## 🔄 Logoları Ekledikten Sonra

1. `flutter pub get` çalıştırın
2. Hot restart yapın (Hot reload yeterli olmayabilir)
3. Logolar otomatik olarak gösterilecek

## ⚠️ Notlar

- Logo bulunamazsa shield ikonu gösterilir
- Tüm takımlar için logo eklemeniz gerekmez
- Logolar uygulama boyutunu artıracaktır (~50KB/logo)
- Telif haklarına dikkat edin!
