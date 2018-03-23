#!/usr/bin/env bash
file=$2
name=$1
export $name="$(awk 'BEGIN{}{out=out$0"\n"}END{print out}' $file| sed 's/\n$//')"
