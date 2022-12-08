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
  "fisc"
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
  "beca"
  "covi"
  "ing2"
  "inge"
  "aida"
  "anit"
  "pega"
)

PS3="Which committee do you want the emails from? "
select choice in "${COM[@]}";
do
  if [[ -n $choice ]]; then
    for i in ${!COM[@]}
    do
      if [ "${COM[i]}" = "$choice" ]; then
		# Let's do this:
		DEBUG=false

		# change this to the URL of the committee you want to get e-mail addresses for
		wget "https://www.europarl.europa.eu/committees/en/${COM[i]}/home/members" -o /dev/null -O - |grep mepphoto|cut -d/ -f5|cut -d. -f1 > meps-urls

		for m in $(cat meps-urls); do
			wget "https://www.europarl.europa.eu/meps/en/$m" -o /dev/null -O "$m.html";
		done

		# get the email addresses from the MEP pages
		grep link_email\  ./*html|cut -d\" -f4|rev|sed 's/\]ta\[/@/g'|sed 's/\]tod\[/\./g' > emails

		# cleanup
		if [ "$DEBUG" != true ]; then
			rm meps-urls ./*html
		fi
        break
      fi
    done
  else
    echo "Invalid selection."
  fi
done
