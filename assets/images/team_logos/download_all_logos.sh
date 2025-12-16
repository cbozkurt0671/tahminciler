#!/bin/bash

# TÜM LİGLERDEKİ TAKIMLARIN LOGOLARINI İNDİR
# SofaScore Team ID'leri ile eşleştirilmiş

echo "🏈 TÜM LİGLERDEN TAKIMLARIN LOGOLARI İNDİRİLİYOR..."
echo "=================================================="
echo ""

total=0
success=0
failed=0

download_logo() {
    local id=$1
    local url=$2
    local name=$3
    
    if curl -s -o "${id}.png" "$url" 2>/dev/null; then
        if [ -s "${id}.png" ]; then
            echo "✅ $name ($id)"
            ((success++))
        else
            rm -f "${id}.png"
            echo "❌ $name ($id) - Boş dosya"
            ((failed++))
        fi
    else
        echo "❌ $name ($id) - İndirme hatası"
        ((failed++))
    fi
    ((total++))
}

# ============================================
# PREMIER LEAGUE (İngiltere)
# ============================================
echo "🏴󠁧󠁢󠁥󠁮󠁧󠁿 PREMIER LEAGUE"
echo "----------------------------------------"
download_logo 17 "https://tmssl.akamaized.net/images/wappen/head/281.png" "Manchester City"
download_logo 35 "https://tmssl.akamaized.net/images/wappen/head/985.png" "Manchester United"
download_logo 31 "https://tmssl.akamaized.net/images/wappen/head/31.png" "Liverpool"
download_logo 42 "https://tmssl.akamaized.net/images/wappen/head/11.png" "Arsenal"
download_logo 19 "https://tmssl.akamaized.net/images/wappen/head/631.png" "Chelsea"
download_logo 33 "https://tmssl.akamaized.net/images/wappen/head/148.png" "Tottenham"
download_logo 34 "https://tmssl.akamaized.net/images/wappen/head/1237.png" "Newcastle United"
download_logo 39 "https://tmssl.akamaized.net/images/wappen/head/405.png" "Aston Villa"
download_logo 48 "https://tmssl.akamaized.net/images/wappen/head/1020.png" "Brighton"
download_logo 38 "https://tmssl.akamaized.net/images/wappen/head/379.png" "West Ham"
download_logo 30 "https://tmssl.akamaized.net/images/wappen/head/873.png" "Everton"
download_logo 60 "https://tmssl.akamaized.net/images/wappen/head/989.png" "Bournemouth"
download_logo 44 "https://tmssl.akamaized.net/images/wappen/head/931.png" "Fulham"
download_logo 29 "https://tmssl.akamaized.net/images/wappen/head/1003.png" "Brentford"
download_logo 36 "https://tmssl.akamaized.net/images/wappen/head/1003.png" "Crystal Palace"
download_logo 47 "https://tmssl.akamaized.net/images/wappen/head/703.png" "Wolves"
download_logo 37 "https://tmssl.akamaized.net/images/wappen/head/1132.png" "Leicester City"
download_logo 45 "https://tmssl.akamaized.net/images/wappen/head/1123.png" "Nottingham Forest"
download_logo 49 "https://tmssl.akamaized.net/images/wappen/head/180.png" "Southampton"
download_logo 2755 "https://tmssl.akamaized.net/images/wappen/head/8657.png" "Ipswich Town"
echo ""

# ============================================
# LA LIGA (İspanya)
# ============================================
echo "🇪🇸 LA LIGA"
echo "----------------------------------------"
download_logo 2817 "https://tmssl.akamaized.net/images/wappen/head/418.png" "Real Madrid"
download_logo 2829 "https://tmssl.akamaized.net/images/wappen/head/131.png" "Barcelona"
download_logo 2836 "https://tmssl.akamaized.net/images/wappen/head/13.png" "Atletico Madrid"
download_logo 2821 "https://tmssl.akamaized.net/images/wappen/head/1049.png" "Athletic Bilbao"
download_logo 2833 "https://tmssl.akamaized.net/images/wappen/head/714.png" "Real Sociedad"
download_logo 2885 "https://tmssl.akamaized.net/images/wappen/head/150.png" "Real Betis"
download_logo 2845 "https://tmssl.akamaized.net/images/wappen/head/1050.png" "Villarreal"
download_logo 2826 "https://tmssl.akamaized.net/images/wappen/head/367.png" "Sevilla"
download_logo 2819 "https://tmssl.akamaized.net/images/wappen/head/1049.png" "Valencia"
download_logo 2860 "https://tmssl.akamaized.net/images/wappen/head/3368.png" "Girona"
download_logo 2824 "https://tmssl.akamaized.net/images/wappen/head/940.png" "Osasuna"
download_logo 2885 "https://tmssl.akamaized.net/images/wappen/head/3302.png" "Rayo Vallecano"
download_logo 2820 "https://tmssl.akamaized.net/images/wappen/head/1049.png" "Espanyol"
download_logo 2855 "https://tmssl.akamaized.net/images/wappen/head/3368.png" "Mallorca"
download_logo 2828 "https://tmssl.akamaized.net/images/wappen/head/940.png" "Celta Vigo"
download_logo 2885 "https://tmssl.akamaized.net/images/wappen/head/1049.png" "Getafe"
download_logo 2831 "https://tmssl.akamaized.net/images/wappen/head/1049.png" "Las Palmas"
download_logo 2848 "https://tmssl.akamaized.net/images/wappen/head/1049.png" "Alaves"
download_logo 2839 "https://tmssl.akamaized.net/images/wappen/head/940.png" "Leganes"
download_logo 2859 "https://tmssl.akamaized.net/images/wappen/head/714.png" "Valladolid"
echo ""

# ============================================
# SERIE A (İtalya)
# ============================================
echo "🇮🇹 SERIE A"
echo "----------------------------------------"
download_logo 2697 "https://tmssl.akamaized.net/images/wappen/head/506.png" "Juventus"
download_logo 2692 "https://tmssl.akamaized.net/images/wappen/head/46.png" "Inter Milan"
download_logo 2687 "https://tmssl.akamaized.net/images/wappen/head/5.png" "AC Milan"
download_logo 2714 "https://tmssl.akamaized.net/images/wappen/head/6195.png" "Napoli"
download_logo 2702 "https://tmssl.akamaized.net/images/wappen/head/12.png" "Roma"
download_logo 2700 "https://tmssl.akamaized.net/images/wappen/head/402.png" "Lazio"
download_logo 2682 "https://tmssl.akamaized.net/images/wappen/head/800.png" "Atalanta"
download_logo 2712 "https://tmssl.akamaized.net/images/wappen/head/430.png" "Fiorentina"
download_logo 2722 "https://tmssl.akamaized.net/images/wappen/head/4171.png" "Bologna"
download_logo 2729 "https://tmssl.akamaized.net/images/wappen/head/5404.png" "Torino"
download_logo 2715 "https://tmssl.akamaized.net/images/wappen/head/1046.png" "Udinese"
download_logo 2711 "https://tmssl.akamaized.net/images/wappen/head/1390.png" "Genoa"
download_logo 2704 "https://tmssl.akamaized.net/images/wappen/head/1047.png" "Como"
download_logo 2685 "https://tmssl.akamaized.net/images/wappen/head/1244.png" "Lecce"
download_logo 2724 "https://tmssl.akamaized.net/images/wappen/head/1390.png" "Parma"
download_logo 2716 "https://tmssl.akamaized.net/images/wappen/head/5802.png" "Empoli"
download_logo 2686 "https://tmssl.akamaized.net/images/wappen/head/6574.png" "Cagliari"
download_logo 2708 "https://tmssl.akamaized.net/images/wappen/head/6195.png" "Verona"
download_logo 2705 "https://tmssl.akamaized.net/images/wappen/head/430.png" "Monza"
download_logo 2710 "https://tmssl.akamaized.net/images/wappen/head/430.png" "Venezia"
echo ""

# ============================================
# BUNDESLIGA (Almanya)
# ============================================
echo "🇩🇪 BUNDESLIGA"
echo "----------------------------------------"
download_logo 2672 "https://tmssl.akamaized.net/images/wappen/head/27.png" "Bayern Munich"
download_logo 2673 "https://tmssl.akamaized.net/images/wappen/head/16.png" "Borussia Dortmund"
download_logo 2681 "https://tmssl.akamaized.net/images/wappen/head/15.png" "Bayer Leverkusen"
download_logo 2674 "https://tmssl.akamaized.net/images/wappen/head/23826.png" "RB Leipzig"
download_logo 2677 "https://tmssl.akamaized.net/images/wappen/head/82.png" "Eintracht Frankfurt"
download_logo 2679 "https://tmssl.akamaized.net/images/wappen/head/33.png" "VfB Stuttgart"
download_logo 2680 "https://tmssl.akamaized.net/images/wappen/head/244.png" "Wolfsburg"
download_logo 2678 "https://tmssl.akamaized.net/images/wappen/head/167.png" "Borussia Monchengladbach"
download_logo 2684 "https://tmssl.akamaized.net/images/wappen/head/39.png" "Werder Bremen"
download_logo 2698 "https://tmssl.akamaized.net/images/wappen/head/53.png" "Freiburg"
download_logo 2718 "https://tmssl.akamaized.net/images/wappen/head/60.png" "Union Berlin"
download_logo 2707 "https://tmssl.akamaized.net/images/wappen/head/124.png" "Mainz 05"
download_logo 2717 "https://tmssl.akamaized.net/images/wappen/head/14.png" "Hoffenheim"
download_logo 2699 "https://tmssl.akamaized.net/images/wappen/head/29.png" "FC Augsburg"
download_logo 2728 "https://tmssl.akamaized.net/images/wappen/head/3.png" "St. Pauli"
download_logo 2706 "https://tmssl.akamaized.net/images/wappen/head/91.png" "Heidenheim"
download_logo 2683 "https://tmssl.akamaized.net/images/wappen/head/4.png" "Holstein Kiel"
download_logo 2694 "https://tmssl.akamaized.net/images/wappen/head/34.png" "Bochum"
echo ""

# ============================================
# LIGUE 1 (Fransa)
# ============================================
echo "🇫🇷 LIGUE 1"
echo "----------------------------------------"
download_logo 1644 "https://tmssl.akamaized.net/images/wappen/head/583.png" "PSG"
download_logo 1649 "https://tmssl.akamaized.net/images/wappen/head/244.png" "Marseille"
download_logo 1639 "https://tmssl.akamaized.net/images/wappen/head/1082.png" "Monaco"
download_logo 1648 "https://tmssl.akamaized.net/images/wappen/head/1041.png" "Lyon"
download_logo 1643 "https://tmssl.akamaized.net/images/wappen/head/1084.png" "Lille"
download_logo 1641 "https://tmssl.akamaized.net/images/wappen/head/1273.png" "Lens"
download_logo 1646 "https://tmssl.akamaized.net/images/wappen/head/1396.png" "Nice"
download_logo 1642 "https://tmssl.akamaized.net/images/wappen/head/3420.png" "Brest"
download_logo 1715 "https://tmssl.akamaized.net/images/wappen/head/273.png" "Rennes"
download_logo 1678 "https://tmssl.akamaized.net/images/wappen/head/1084.png" "Strasbourg"
download_logo 1645 "https://tmssl.akamaized.net/images/wappen/head/3933.png" "Reims"
download_logo 1652 "https://tmssl.akamaized.net/images/wappen/head/714.png" "Toulouse"
download_logo 1647 "https://tmssl.akamaized.net/images/wappen/head/3368.png" "Nantes"
download_logo 1658 "https://tmssl.akamaized.net/images/wappen/head/3368.png" "Auxerre"
download_logo 1654 "https://tmssl.akamaized.net/images/wappen/head/3368.png" "Montpellier"
download_logo 1682 "https://tmssl.akamaized.net/images/wappen/head/3368.png" "Angers"
download_logo 1679 "https://tmssl.akamaized.net/images/wappen/head/3368.png" "Le Havre"
download_logo 1653 "https://tmssl.akamaized.net/images/wappen/head/3368.png" "Saint-Etienne"
echo ""

# ============================================
# SÜPER LİG (Türkiye)
# ============================================
echo "🇹🇷 SÜPER LİG"
echo "----------------------------------------"
download_logo 3036 "https://tmssl.akamaized.net/images/wappen/head/114.png" "Galatasaray"
download_logo 3052 "https://tmssl.akamaized.net/images/wappen/head/36.png" "Fenerbahçe"
download_logo 3024 "https://tmssl.akamaized.net/images/wappen/head/141.png" "Beşiktaş"
download_logo 3002 "https://tmssl.akamaized.net/images/wappen/head/2381.png" "Trabzonspor"
download_logo 3009 "https://tmssl.akamaized.net/images/wappen/head/3389.png" "Başakşehir"
download_logo 3014 "https://tmssl.akamaized.net/images/wappen/head/1024.png" "Sivasspor"
download_logo 3085 "https://tmssl.akamaized.net/images/wappen/head/3386.png" "Konyaspor"
download_logo 3055 "https://tmssl.akamaized.net/images/wappen/head/1003.png" "Kasımpaşa"
download_logo 3001 "https://tmssl.akamaized.net/images/wappen/head/2380.png" "Antalyaspor"
download_logo 3010 "https://tmssl.akamaized.net/images/wappen/head/1132.png" "Alanyaspor"
download_logo 3011 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Kayserispor"
download_logo 3023 "https://tmssl.akamaized.net/images/wappen/head/2381.png" "Rizespor"
download_logo 3028 "https://tmssl.akamaized.net/images/wappen/head/1003.png" "Gaziantep FK"
download_logo 3050 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Hatayspor"
download_logo 3051 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Samsunspor"
download_logo 3012 "https://tmssl.akamaized.net/images/wappen/head/1003.png" "Adana Demirspor"
download_logo 3005 "https://tmssl.akamaized.net/images/wappen/head/1003.png" "Göztepe"
download_logo 3086 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Eyüpspor"
download_logo 3025 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Bodrum FK"
echo ""

# ============================================
# CHAMPIONS LEAGUE (Önemli Takımlar)
# ============================================
echo "🏆 CHAMPIONS LEAGUE"
echo "----------------------------------------"
download_logo 2948 "https://tmssl.akamaized.net/images/wappen/head/610.png" "Ajax"
download_logo 2920 "https://tmssl.akamaized.net/images/wappen/head/720.png" "Porto"
download_logo 2935 "https://tmssl.akamaized.net/images/wappen/head/1063.png" "Benfica"
download_logo 2951 "https://tmssl.akamaized.net/images/wappen/head/210.png" "Sporting CP"
download_logo 2913 "https://tmssl.akamaized.net/images/wappen/head/11.png" "Celtic"
download_logo 2918 "https://tmssl.akamaized.net/images/wappen/head/124.png" "Rangers"
download_logo 2817 "https://tmssl.akamaized.net/images/wappen/head/1049.png" "Shakhtar Donetsk"
download_logo 2959 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Red Star Belgrade"
echo ""

echo "=================================================="
echo "📊 İNDİRME ÖZET"
echo "=================================================="
echo "Toplam deneme: $total"
echo "✅ Başarılı: $success"
echo "❌ Başarısız: $failed"
echo ""
echo "📁 İndirilen logo sayısı: $(ls -1 *.png 2>/dev/null | wc -l)"
echo ""
echo "🎉 İşlem tamamlandı!"
