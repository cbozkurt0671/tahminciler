#!/bin/bash

# Takım logolarını Transfermarkt'tan indir
# SofaScore'dan gelen GERÇEK Team ID'leri ile

echo "🏈 Takım logoları indiriliyor..."

# Premier League (SofaScore ID'leri)
curl -o 35.png "https://tmssl.akamaized.net/images/wappen/head/985.png" 2>/dev/null && echo "✅ Manchester United (35)"
curl -o 17.png "https://tmssl.akamaized.net/images/wappen/head/281.png" 2>/dev/null && echo "✅ Manchester City (17)"
curl -o 19.png "https://tmssl.akamaized.net/images/wappen/head/631.png" 2>/dev/null && echo "✅ Chelsea (19)"
curl -o 31.png "https://tmssl.akamaized.net/images/wappen/head/31.png" 2>/dev/null && echo "✅ Liverpool (31)"
curl -o 42.png "https://tmssl.akamaized.net/images/wappen/head/11.png" 2>/dev/null && echo "✅ Arsenal (42)"
curl -o 33.png "https://tmssl.akamaized.net/images/wappen/head/148.png" 2>/dev/null && echo "✅ Tottenham (33)"
curl -o 60.png "https://tmssl.akamaized.net/images/wappen/head/989.png" 2>/dev/null && echo "✅ Bournemouth (60)"

# Serie A (SofaScore ID'leri)
curl -o 2702.png "https://tmssl.akamaized.net/images/wappen/head/12.png" 2>/dev/null && echo "✅ Roma (2702)"
curl -o 2697.png "https://tmssl.akamaized.net/images/wappen/head/506.png" 2>/dev/null && echo "✅ Juventus (2697)"
curl -o 2692.png "https://tmssl.akamaized.net/images/wappen/head/46.png" 2>/dev/null && echo "✅ Inter Milan (2692)"
curl -o 2687.png "https://tmssl.akamaized.net/images/wappen/head/5.png" 2>/dev/null && echo "✅ AC Milan (2687)"
curl -o 2714.png "https://tmssl.akamaized.net/images/wappen/head/6195.png" 2>/dev/null && echo "✅ Napoli (2714)"

# Süper Lig (SofaScore ID'leri)
curl -o 3052.png "https://tmssl.akamaized.net/images/wappen/head/36.png" 2>/dev/null && echo "✅ Fenerbahçe (3052)"
curl -o 3036.png "https://tmssl.akamaized.net/images/wappen/head/114.png" 2>/dev/null && echo "✅ Galatasaray (3036)"
curl -o 3024.png "https://tmssl.akamaized.net/images/wappen/head/141.png" 2>/dev/null && echo "✅ Beşiktaş (3024)"
curl -o 3085.png "https://tmssl.akamaized.net/images/wappen/head/3386.png" 2>/dev/null && echo "✅ Konyaspor (3085)"

# La Liga (SofaScore ID'leri)
curl -o 2829.png "https://tmssl.akamaized.net/images/wappen/head/131.png" 2>/dev/null && echo "✅ Barcelona (2829)"
curl -o 2817.png "https://tmssl.akamaized.net/images/wappen/head/418.png" 2>/dev/null && echo "✅ Real Madrid (2817)"
curl -o 2836.png "https://tmssl.akamaized.net/images/wappen/head/13.png" 2>/dev/null && echo "✅ Atletico Madrid (2836)"

# Bundesliga (SofaScore ID'leri)
curl -o 2672.png "https://tmssl.akamaized.net/images/wappen/head/27.png" 2>/dev/null && echo "✅ Bayern Munich (2672)"
curl -o 2673.png "https://tmssl.akamaized.net/images/wappen/head/16.png" 2>/dev/null && echo "✅ Borussia Dortmund (2673)"

# Ligue 1 (SofaScore ID'leri)
curl -o 1644.png "https://tmssl.akamaized.net/images/wappen/head/583.png" 2>/dev/null && echo "✅ PSG (1644)"

echo ""
echo "📊 İndirme tamamlandı!"
echo "📁 $(ls -1 *.png 2>/dev/null | wc -l) logo indirildi"
