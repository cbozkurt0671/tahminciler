#!/bin/bash

# Download league logos from SofaScore API

echo "🏆 Downloading league logos from SofaScore..."

curl -L "https://img.sofascore.com/api/v1/unique-tournament/17/image" -o premier_league.png
echo "✅ Premier League downloaded"

curl -L "https://img.sofascore.com/api/v1/unique-tournament/52/image" -o super_lig.png
echo "✅ Süper Lig downloaded"

curl -L "https://img.sofascore.com/api/v1/unique-tournament/35/image" -o bundesliga.png
echo "✅ Bundesliga downloaded"

curl -L "https://img.sofascore.com/api/v1/unique-tournament/23/image" -o serie_a.png
echo "✅ Serie A downloaded"

curl -L "https://img.sofascore.com/api/v1/unique-tournament/8/image" -o la_liga.png
echo "✅ La Liga downloaded"

curl -L "https://img.sofascore.com/api/v1/unique-tournament/34/image" -o ligue_1.png
echo "✅ Ligue 1 downloaded"

echo "🎉 All league logos downloaded!"
ls -lh *.png
