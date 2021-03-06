#!/bin/bash

# Tired to write this again and again, this time I'm putting this together and online.
# This is totally messy, issues and PRs are welcome.

# TODO: since the only thing that changes in the URL between committees is the
# actual committee name, get it as an argument

COM=(
  "afet"
  "droi"
  "sede"
  "deve"
  "inta"
  "budg"
  "cont"
  "econ"
  "empl"
  "envi"
  "itre"
  "imco"
  "tran"
  "regi"
  "agri"
  "pech"
  "cult"
  "juri"
  "libe"
  "afco"
  "femm"
  "peti"
  "terr"
  "pest"
  "tax3"
)

PS3="Which committee do you want the emails from? "
select choice in "${COM[@]}";
do
  if [[ -n $choice ]]; then
    for i in ${!COM[@]}
    do
      if [ "${COM[i]}" = "$choice" ]; then
		# change this to the URL of the committee you want to get e-mail addresses for
		url="http://www.europarl.europa.eu/committees/en/${COM[i]}/members.html?action="

		# Let's do this:
		DEBUG=false
		rm -rf debug *html

		# There's always at least one page:
		wget $url"0" -o /dev/null -O "0.html";

		# number of pages with members there are. I should be extracting this, but whatever
		pages=$(grep \"?action= 0.html|grep class=\"\" |grep -v next_page|tail -1|cut -d\" -f2|cut -d= -f2);
		if [ "$DEBUG" != true ]; then
		  echo "There are $pages pages to process"
		fi

		# get the pages
		for p in $(seq 1 $pages); do
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
		grep mailto *html|cut -d\" -f4|cut -d: -f2-|rev|sed 's/\]ta\[/@/g'|sed 's/\]tod\[/\./g' > emails

		# cleanup
		if [ "$DEBUG" != true ]; then
			rm meps-urls
			rm *html
		fi
        break
      fi
    done
  else
    echo "Invalid selection."
  fi
done
