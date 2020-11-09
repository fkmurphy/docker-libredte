#!/bin/sh

[ ! $UID -eq 0 ] && exit 1;

cd /app && git clone --recursive https://github.com/LibreDTE/libredte-webapp.git .


