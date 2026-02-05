# 1. Install required tools (rsvg-convert and webp)
sudo apt-get update && sudo apt-get install librsvg2-bin webp

# 2. Convert the SVG to a PNG at the correct size
rsvg-convert -w 240 -h 60 skillplot-wordmark.svg -o skillplot-wordmark.png
rsvg-convert skillplot-wordmark.svg -o skillplot-wordmark.png

# 3. Convert the PNG to WebP (quality 80 is usually enough)
cwebp -q 80 skillplot-wordmark.png -o skillplot-wordmark.webp
