#!/usr/bin/env sh

ffmpeg  -f v4l2 -framerate 30 -video_size 320x240 -i /dev/video2 \
  -re -f lavfi -i sine=frequency=1000 -r 30 \
  -filter_complex "[0:v]vignette,format=gbrp,lenscorrection=k1=0.2:k2=0.2[lensed]; \
  [lensed]split=9[v0][v1][v2][v3][v4][v5][v6][v7][v8]; \
  [v1]tpad=start=550[r1]; \
  [v2]tpad=start=1350[r2]; \
  [v3]tpad=start=1950[r3]; \
  [v4]tpad=start=175[r4]; \
  [v5]tpad=start=1000[r5]; \
  [v6]tpad=start=750[r6]; \
  [v7]tpad=start=2200[r7]; \
  [v8]tpad=start=400[r8]; \
  [v0][r1][r2]hstack=inputs=3[l1]; \
  [r3][r4][r5]hstack=inputs=3[l2]; \
  [r6][r7][r8]hstack=inputs=3[l3]; \
  [l1][l2][l3]vstack=inputs=3[outv]" \
  -map '[outv]' -map 1:a:0 \
  -c:v libx264 -x264opts keyint=60:no-scenecut -s 852x480 -r 30 -preset ultrafast -c:a aac -sws_flags bilinear \
  -b:v 2800k -b:a 256k -f flv rtmps://live-api-s.facebook.com:443/rtmp/FB-2498075843957294-0-AbzjuY2B1XHrDtH3
