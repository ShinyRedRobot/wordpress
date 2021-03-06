#!/bin/bash
set -e

current="$(curl -sSL 'http://api.wordpress.org/core/version-check/1.7/' | sed -r 's/^.*"current":"([^"]+)".*$/\1/')"

sha1="$(curl -sSL "https://wordpress.org/wordpress-$current.tar.gz.sha1")"

sed -ri '
	s/^(ENV WORDPRESS_VERSION) .*/\1 '"$current"'/;
	s/^(ENV WORDPRESS_SHA1) .*/\1 '"$sha1"'/;
' "$variant/Dockerfile"
