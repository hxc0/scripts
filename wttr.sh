#!/bin/bash

curl -H "Accept-Language: ${LANG%_*}" wttr.in/${2:-Wroclaw}?qp${1:-0}
