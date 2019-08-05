SHELL := /bin/bash

HERE=$(shell pwd)

map:
	-. "$(HERE)/.backstage/build.sh"; build_map

html: map
	-. "$(HERE)/.backstage/build.sh"; build_html

prebook: map
	-. "$(HERE)/.backstage/build.sh"; build_book

book: prebook
	gitbook build "$(HERE)/out"

book-serve: prebook
	gitbook serve "$(HERE)/out"
