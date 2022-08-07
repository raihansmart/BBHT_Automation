#!/bin/bash

GREEN=$(tput setaf 10)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 14)
RESET=$(tput sgr0)

echo "${BLUE} ========================================================= ${RESET}"
echo "${BLUE} -->          BUG BOUNTY AUTOMATION FOR HUNTING        <-- ${RESET}"
echo "${BLUE} -->            Author : Ahmad Raihan Prawira          <-- ${RESET}"
echo "${BLUE} ========================================================= ${RESET}"
echo ""

echo "${GREEN} -->  TAKE A CUP OF COFFEE WHILE THIS TOOL IS DOING HUNTING FOR YOU   <-- ${RESET}"
echo ""


# Subdomain Enumeration

subdomain(){
echo ""
echo "${YELLOW} [+] Perforing Subdomain Enumeration ${RESET}"
echo ""
 
subfinder -d ${Domain} -o ${Domain}_subfinder.txt
amass enum -passive -d ${Domain} | tee ${Domain}_amass.txt
assetfinder ${Domain} | tee ${Domain}_assetfinder.txt
subscraper ${Domain} --censys-id 6d25cce7-cdd5-4efb-906d-de9f07fe7590 --censys-secret Jxy6jDCvnTxETzJcR6chbcrn6L5sndOR -r ${Domain}_subscraper.txt
github-subdomains -d $Domain -t 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 -o ${Domain}_github.txt

cat ${Domain}_amass.txt | anew ${Domain}.txt
cat ${Domain}_assetfinder.txt | anew ${Domain}.txt
cat ${Domain}_subscraper.txt | anew ${Domain}.txt
cat ${Domain}_github.txt | anew ${Domain}.txt


probing 

URLEndpoints

rm ${Domain}*.txt

mv final.txt ${Domain}_final.txt
}

# Subdomain Probing

probing(){
echo ""
echo "${YELLOW} [+] Performing Subdomain Probe ${RESET}"
echo ""

cat ${Domain}.txt | httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee ${Domain}_uncommon_probe.txt

cat ${Domain}.txt | httpx -o ${Domain}_probed.txt

cat ${Domain}_uncommon_probe.txt | anew ${Domain}_probed.txt
}

# URL Endpoint / Web Spidering

URLEndpoints(){
echo ""
echo "${YELLOW} [+] Performing Web Spidering ${RESET}"
echo ""

cat ${Domain}_probed.txt | gau --fc 400,402,404,405,406,408,422,429,500,501,502,503,504 --verbose --o ${Domain}_gau.txt
arjun -i ${Domain}_probed.txt -t 100 --passive -oT ${Domain}_arjun.txt

cat ${Domain}_arjun.txt | anew ${Domain}_gau.txt
cat ${Domain}_gau.txt | uro > final.txt
}

echo "${YELLOW} [?] Enter your target domain: "
echo ""
read Domain
subdomain


echo ""
echo "${GREEN} ========================================================= ${RESET}"
echo ""
echo "${GREEN} -->              HUNTING COMPLETED                    <-- ${RESET}"
echo ""
echo "${GREEN} -->              ENJOY AND CHEERS                     <-- ${RESET}"
echo ""
echo "${GREEN} ========================================================= ${RESET}"
