#!/usr/bin/env bash

# Simple terminal capability test script
# Tests: bold, italic, underline, undercurl, colors, background, truecolor

echo -e "\n=== Basic Text Styles ==="
echo -e "Normal text"
echo -e "\033[1mBold text\033[0m"
echo -e "\033[3mItalic text\033[0m"
echo -e "\033[4mUnderlined text\033[0m"
echo -e "\033[9mStrikethrough text\033[0m"

# Undercurl (requires proper terminfo support, usually xterm-256color)
# \033[4:3m = curly underline (undercurl)
# You can also try other underline styles like double, dotted, dashed:
echo -e "\n=== Undercurl Tests ==="
# Basic undercurl
echo -e "\033[4:3mUndercurl text (default color)\033[0m"
echo -e "\033[4:2mDouble underline\033[0m"
echo -e "\033[4:4mDotted underline\033[0m"
echo -e "\033[4:5mDashed underline\033[0m"

# Colored undercurls (using 24-bit color)
echo -e "\033[4:3m\033[58;2;255;0;0mRed undercurl\033[0m"
echo -e "\033[4:3m\033[58;2;0;255;0mGreen undercurl\033[0m"
echo -e "\033[4:3m\033[58;2;0;128;255mBlue undercurl\033[0m"
echo -e "\033[4:3m\033[58;2;255;128;0mOrange undercurl\033[0m"
echo -e "\033[4:3m\033[58;2;255;0;255mMagenta undercurl\033[0m"
echo -e "\033[4:3m\033[58;2;128;128;128mGray undercurl\033[0m"

# Reset underline color explicitly
echo -e "\033[59m(Underline color reset)\033[0m"

echo -e "\n=== Foreground Colors (ANSI 8 / 16 colors) ==="
for code in {30..37}; do
  echo -ne "\033[${code}m██ Color ${code}\033[0m  "
done
echo
for code in {90..97}; do
  echo -ne "\033[${code}m██ Bright ${code}\033[0m  "
done
echo -e "\n"

echo -e "=== Background Colors (ANSI 8 / 16 colors) ==="
for code in {40..47}; do
  echo -ne "\033[${code}m  BG ${code}  \033[0m  "
done
echo
for code in {100..107}; do
  echo -ne "\033[${code}m  BG ${code}  \033[0m  "
done
echo -e "\n"

echo -e "=== 256-Color Gradient ==="
for i in {16..231}; do
  echo -ne "\033[48;5;${i}m \033[0m"
  if (((i - 15) % 36 == 0)); then echo; fi
done
echo -e "\n"

echo -e "=== Truecolor Gradient (24-bit) ==="
for i in {0..100}; do
  r=$((255 - i * 2))
  g=$((i * 2))
  b=$((128))
  echo -ne "\033[48;2;${r};${g};${b}m \033[0m"
done
echo -e "\n"

echo -e "\n✅ Done — if you saw colors, italics, and curls, your terminal supports them!\n"
