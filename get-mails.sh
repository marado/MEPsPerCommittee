#!/bin/bash

# Tired to write this again and again, this time I'm putting this together and online.
# This is totally messy, issues and PRs are welcome.

# TODO: since the only thing that changes in the URL between committees is the
# actual committee name, get it as an argument

# change this to the URL of the committee you want to get e-mail addresses for
url="http://www.europarl.europa.eu/committees/en/juri/members.html?action="

# number of pages with members there are. I should be extracting this, but whatever
# Note: if you see "pages 1 to 8" then the actual number here is "7" and we'll go 0 to 7
# TODO: get this information instead of making the user manually update the value
pages=4

DEBUG=false

# get the pages
rm -rf debug *html
for p in $(seq 0 $pages); do
	wget "$url$p" -o /dev/null -O "$p.html";
done

# get the MEP page URLs
grep photo_mep *html|cut -d\" -f2|sed 's/\ /%20/g' > meps-urls

# get the MEP pages
if [ "$DEBUG" != true ]; then
	rm *html
else
	mkdir debug; mv *html debug
fi
for m in $(cat meps-urls); do
	wget "http://www.europarl.europa.eu$m" -o /dev/null;
done

# get the email addresses from the MEP pages
grep mailto *html|cut -d\" -f2|cut -d: -f2-|rev|sed 's/\]ta\[/@/g'|sed 's/\]tod\[/\./g' > emails

# cleanup
if [ "$DEBUG" != true ]; then
	rm meps-urls
	rm *html
fi
