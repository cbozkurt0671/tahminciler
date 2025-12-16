# Logo İndirme Script'i
# Alternatif: Wikimedia Commons'dan indir (Telif hakkı sorunu yok)

import requests
import os
from pathlib import Path

# İndirilecek takım ID'leri ve Wikimedia/alternatif URL'leri
# Format: teamId: (team_name, logo_url)
teams = {
    # Premier League
    17: "Manchester City",
    18: "Manchester United",
    19: "Chelsea",
    20: "Liverpool",
    21: "Arsenal",
    22: "Tottenham",
    33: "Newcastle United",
    34: "Brighton",
    38: "Aston Villa",
    
    # La Liga
    2829: "Barcelona",
    2817: "Real Madrid",
    2833: "Atletico Madrid",
    2836: "Sevilla",
    2885: "Real Betis",
    
    # Bundesliga
    2672: "Bayern Munich",
    2673: "Borussia Dortmund",
    2674: "RB Leipzig",
    2681: "Bayer Leverkusen",
    
    # Serie A
    2697: "Juventus",
    2692: "Inter Milan",
    2687: "AC Milan",
    2714: "Napoli",
    2702: "AS Roma",
    
    # Ligue 1
    1644: "PSG",
    1649: "Marseille",
    1648: "Lyon",
    
    # Other Top Clubs
    2948: "Ajax",
    2920: "Porto",
    2935: "Benfica",
    2829: "Celtic",
}

def download_logo(team_id, team_name):
    """SofaScore'dan takım logosunu indir"""
    url = f'https://api.sofascore.com/api/v1/team/{team_id}/image'
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        'Referer': 'https://www.sofascore.com/',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
    }
    
    try:
        print(f'⏳ İndiriliyor: {team_name} (ID: {team_id})...')
        response = requests.get(url, headers=headers, timeout=15)
        
        if response.status_code == 200:
            # Dosyayı kaydet
            filename = f'{team_id}.png'
            with open(filename, 'wb') as f:
                f.write(response.content)
            
            # Dosya boyutunu kontrol et
            file_size = os.path.getsize(filename) / 1024  # KB
            print(f'✅ İndirildi: {filename} ({file_size:.1f} KB) - {team_name}')
            return True
        else:
            print(f'❌ Başarısız: {team_name} (Status: {response.status_code})')
            return False
            
    except Exception as e:
        print(f'❌ Hata: {team_name} - {str(e)}')
        return False

def main():
    print('🏈 Takım Logoları İndiriliyor...\n')
    
    success_count = 0
    fail_count = 0
    
    for team_id, team_name in teams.items():
        if download_logo(team_id, team_name):
            success_count += 1
        else:
            fail_count += 1
        print()  # Boş satır
    
    print(f'\n📊 Özet:')
    print(f'✅ Başarılı: {success_count}')
    print(f'❌ Başarısız: {fail_count}')
    print(f'📁 Toplam: {success_count + fail_count}')
    print(f'\n💡 İndirilen logoları "assets/images/team_logos/" klasörüne kopyalayın')

if __name__ == '__main__':
    main()
