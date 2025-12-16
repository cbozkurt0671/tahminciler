#!/bin/bash

# SofaScore konsoldan gelen GERÇEK Team ID'leri ile eksikleri tamamla
# Konsol loglarından alınan ID'ler

echo "🔧 EKSİK VE YANLIŞ ID'LER DÜZELTİLİYOR..."
echo "=================================================="

# Konsol loglarından görülen eksik ID'ler
download_logo() {
    local id=$1
    local url=$2
    local name=$3
    
    if curl -s -o "${id}.png" "$url" 2>/dev/null; then
        if [ -s "${id}.png" ]; then
            echo "✅ $name ($id)"
            return 0
        else
            rm -f "${id}.png"
            echo "❌ $name ($id) - Boş dosya"
            return 1
        fi
    else
        echo "❌ $name ($id) - İndirme hatası"
        return 1
    fi
}

# Premier League - Konsol loglarından gelen gerçek ID'ler
echo "🏴󠁧󠁢󠁥󠁮󠁧󠁿 PREMIER LEAGUE (Eksik ID'ler)"
echo "----------------------------------------"
download_logo 7 "https://tmssl.akamaized.net/images/wappen/head/873.png" "Crystal Palace"
download_logo 14 "https://tmssl.akamaized.net/images/wappen/head/703.png" "Nottingham Forest"
download_logo 41 "https://tmssl.akamaized.net/images/wappen/head/3005.png" "Sunderland"
download_logo 37 "https://tmssl.akamaized.net/images/wappen/head/379.png" "West Ham United"
download_logo 40 "https://tmssl.akamaized.net/images/wappen/head/405.png" "Aston Villa"
download_logo 50 "https://tmssl.akamaized.net/images/wappen/head/1148.png" "Brentford"
download_logo 34 "https://tmssl.akamaized.net/images/wappen/head/399.png" "Leeds United"
download_logo 39 "https://tmssl.akamaized.net/images/wappen/head/1237.png" "Newcastle United"
echo ""

# Serie A - Konsol loglarından gelen gerçek ID'ler
echo "🇮🇹 SERIE A (Eksik ID'ler)"
echo "----------------------------------------"
download_logo 2693 "https://tmssl.akamaized.net/images/wappen/head/430.png" "Fiorentina"
download_logo 2701 "https://tmssl.akamaized.net/images/wappen/head/747.png" "Hellas Verona"
download_logo 2695 "https://tmssl.akamaized.net/images/wappen/head/410.png" "Udinese"
download_logo 2713 "https://tmssl.akamaized.net/images/wappen/head/1390.png" "Genoa"
download_logo 2697 "https://tmssl.akamaized.net/images/wappen/head/46.png" "Inter Milan"
download_logo 2687 "https://tmssl.akamaized.net/images/wappen/head/506.png" "Juventus"
download_logo 2793 "https://tmssl.akamaized.net/images/wappen/head/6574.png" "Sassuolo"
echo ""

# Bundesliga - Konsol loglarından gelen gerçek ID'ler
echo "🇩🇪 BUNDESLIGA (Eksik ID'ler)"
echo "----------------------------------------"
download_logo 2538 "https://tmssl.akamaized.net/images/wappen/head/60.png" "SC Freiburg"
download_logo 2556 "https://tmssl.akamaized.net/images/wappen/head/39.png" "1. FSV Mainz 05"
download_logo 2534 "https://tmssl.akamaized.net/images/wappen/head/134.png" "SV Werder Bremen"
download_logo 2677 "https://tmssl.akamaized.net/images/wappen/head/79.png" "VfB Stuttgart"
echo ""

# Süper Lig - Konsol loglarından gelen gerçek ID'ler
echo "🇹🇷 SÜPER LİG (Eksik ID'ler)"
echo "----------------------------------------"
download_logo 3054 "https://tmssl.akamaized.net/images/wappen/head/3234.png" "Göztepe"
download_logo 4954 "https://tmssl.akamaized.net/images/wappen/head/3234.png" "Fatih Karagümrük"
download_logo 3065 "https://tmssl.akamaized.net/images/wappen/head/3234.png" "Kocaelispor"
download_logo 3053 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Samsunspor"
download_logo 3086 "https://tmssl.akamaized.net/images/wappen/head/3389.png" "Başakşehir FK"
download_logo 3051 "https://tmssl.akamaized.net/images/wappen/head/449.png" "Trabzonspor"
download_logo 3050 "https://tmssl.akamaized.net/images/wappen/head/114.png" "Beşiktaş JK"
download_logo 5138 "https://tmssl.akamaized.net/images/wappen/head/7280.png" "Gaziantep FK"
echo ""

# Daha fazla eksik varsa ekleyelim
echo "🔧 DİĞER EKSİKLER"
echo "----------------------------------------"
download_logo 2729 "https://tmssl.akamaized.net/images/wappen/head/416.png" "Torino"
download_logo 2715 "https://tmssl.akamaized.net/images/wappen/head/410.png" "Udinese (alternatif)"
download_logo 1646 "https://tmssl.akamaized.net/images/wappen/head/417.png" "Nice"
download_logo 1642 "https://tmssl.akamaized.net/images/wappen/head/3911.png" "Brest"
download_logo 3009 "https://tmssl.akamaized.net/images/wappen/head/3234.png" "Başakşehir (alternatif)"
download_logo 3014 "https://tmssl.akamaized.net/images/wappen/head/2380.png" "Sivasspor"
download_logo 3011 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Kayserispor"
download_logo 3050 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Hatayspor"
download_logo 3025 "https://tmssl.akamaized.net/images/wappen/head/3761.png" "Bodrum FK"
download_logo 2959 "https://tmssl.akamaized.net/images/wappen/head/7.png" "Red Star Belgrade"
echo ""

echo "=================================================="
echo "📊 TOPLAM LOGO SAYISI"
echo "=================================================="
echo "📁 $(ls -1 *.png 2>/dev/null | wc -l) logo mevcut"
echo ""
echo "🎉 Düzeltme tamamlandı!"
