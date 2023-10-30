#!/bin/bash

#resp=$(curl http://localhost:3000/vidcdn/watch/naruto-episode-220 | jq -r ".sources[0].file")

read -p "search anime: " ani


# Fetch the data from the API
anime_data=$(curl -s http://localhost:3000/search?keyw=$ani | tr -d '[:space:]')

# Loop through the data as an array of objects

index=1

for item in $(echo -n $anime_data | jq -cr ".[]"); do
  echo -n "$index) "
  name=$(echo -n $item | jq '.animeTitle')
  echo "$name" | tr -d '"'
  echo ""
  index=$(($index+1))
  
done

read -p "choose an option: " opt

arrind=$(($opt-1))
animeid=$(echo $anime_data | jq ".[$arrind].animeId")

anid=$(echo "$animeid" | tr -d '"')

anidet=$(curl -s http://localhost:3000/anime-details/$anid | tr -d '[:space:]')

totepcol=$(echo "$anidet" | jq ".totalEpisodes")

totep=$(echo $totepcol | tr -d '"')

read -p "select between [1-$totep]" noep

echo $noep

acep=$(($noep-1))

anwat=$(curl -s http://localhost:3000/vidcdn/watch/$anid-episode-$noep | tr -d '[:space:]')

linkmu=$(echo $anwat | jq -r ".sources[0].file")

mpv --no-terminal "$linkmu"

#ffmpeg -i "http://vidsrc.to/embed/movie/385687" -f rawvideo -pix_fmt yuv420p -vf fps=25 - | mpv

