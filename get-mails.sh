#!/bin/bash

# Tired to write this again and again, this time I'm putting this together and online.
# This is totally messy, issues and PRs are welcome.

# change this to the URL of the committee you want to get e-mail addresses for
url="http://www.europarl.europa.eu/committees/en/imco/members.html?action="

# number of pages with members there are. I should be extracting this, but whatever
# Note: if you see "pages 1 to 8" then the actual number here is "7" and we'll go 0 to 7
pages=7

# get the pages
rm *html
for p in $(seq 0 $pages); do
	wget "$url$p" -o /dev/null -O "$p.html";
done

# get the MEP page URLs
grep photo_mep *html|cut -d\" -f2 > meps-urls

# get the MEP pages
rm *html
for m in $(cat meps-urls); do
	wget "http://www.europarl.europa.eu$m" -o /dev/null;
done

# get the email addresses from the MEP pages
grep mailto *html|cut -d\" -f2|cut -d: -f2-|rev|sed 's/\]ta\[/@/g'|sed 's/\]tod\[/\./g' > emails

# cleanup
rm meps-urls
rm *html
