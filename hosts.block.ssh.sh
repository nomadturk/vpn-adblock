#!/bin/bash
# Last revision: 2019/06/22
# M. Omer GOLGELI - az@cokh.net

# Let's create our temporary files
temphosts1=$(mktemp)
temphosts2=$(mktemp)

# Obtain various hosts files and merge into one
# You can add/remove more as you wish.
echo "Downloading block definitions..."
curl -ksSfL "https://raw.githubusercontent.com/firehol/blocklist-ipsets/344e797c4c6883ac2fc25a84de3823d5a3129925/normshield_high_spam.ipset" > $temphosts1
curl -ksSfL "https://raw.githubusercontent.com/firehol/blocklist-ipsets/a34101465e6dc803115f863cac2517ac24d5a326/dshield_top_1000.ipset" >> $temphosts1
curl -ksSfL "https://lists.blocklist.de/lists/strongips.txt" >> $temphosts1
curl -ksSfL "https://lists.blocklist.de/lists/mail.txt" >> $temphosts1
curl -ksSfL "https://lists.blocklist.de/lists/imap.txt" >> $temphosts1
curl -ksSfL "https://lists.blocklist.de/lists/pop3.txt" >> $temphosts1
curl -ksSfL "https://lists.blocklist.de/lists/postfix.txt" >> $temphosts1
curl -ksSfL "https://lists.blocklist.de/lists/courierimap.txt" >> $temphosts1
curl -ksSfL "https://lists.blocklist.de/lists/courierpop3.txt" >> $temphosts1
curl -ksSfL "https://lists.blocklist.de/lists/bruteforcelogin.txt" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/assp/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/sasl/2?age=7d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/sasl/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/postfix-sasl/1?age=7d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/postfix-sasl/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/exim/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/local-exim/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/courierpop3/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/courierauth/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/qmail-smtp/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/plesk-postfix/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/badbots/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/dovecot/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/dovecot/1?age=3d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/dovecot-pop3imap/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/mail/0?age=1d" >> $temphosts1
curl -ksSfL "https://www.badips.com/get/list/smtp/0?age=1d" >> $temphosts1
curl -ksSfL "http://blocklist.greensnow.co/greensnow.txt" >> $temphosts1
curl -ksSfL "http://danger.rulez.sk/projects/bruteforceblocker/blist.php" | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" >> $temphosts1
curl -ksSfL "http://www.malwaredomainlist.com/hostslist/ip.txt" >> $temphosts1

# Do some work on the file:
# 1. Remove MS-DOS carriage returns
# 2. Delete all lines that begins with 127.0.0.1 or 0.0.0.0
# 3. Delete any lines containing the word localhost because we'll obtain that from the original hosts file
# 4. Replace 127.0.0.1 with 0.0.0.0 because then we don't have to wait for the resolver to fail
# 5. Scrunch extraneous spaces separating address from name into a single tab
# 6. Delete any comments on lines
# 7. Clean up leftover trailing blanks
# 8. Finally, delete all lines that begins with 0.0.0.0 to make sure that all remnants are removed
# Pass all this through sort with the unique flag to remove duplicates and save the result
echo
echo "Parsing"
echo "Cleaning"
echo "De-duplicating"
echo "Sorting..."
echo
sed -e 's/\r//'                         \
    -e '/^127.0.0.1\|0.0.0.0/d'        \
    -e '/localhost/d'                   \
    -e 's/127.0.0.1/0.0.0.0/'           \
    -e 's/ \+/\t/'                      \
    -e 's/#.*$//'                       \
    -e 's/[ \t]*$//'                    \
    -e '/^0.0.0.0/d'                   \
     < $temphosts1 | sort -u > $temphosts2


# Combine system hosts with adblocks
echo "Creating supplementary hosts file is complete..."
echo -e "#<local-data>" > ./hosts.blackhole
echo -e "\n# Brute Force Attacking IP list generated "$(date) >> ./hosts.blackhole
cat $temphosts2 > ./hosts.blackhole.tmp
totallines="$(grep --regexp="$" --count ./hosts.blackhole.tmp)"
echo -e "# Total number of blocked hosts are:" $totallines >> ./hosts.blackhole
rm -rf ./hosts.blackhole.tmp
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $temphosts2|sort|uniq >> ./hosts.blackhole
echo -e "#</local-data>" >> ./hosts.blackhole
# Clean up temp files and remind user to copy new file
echo "Time to clean up..."
rm $temphosts1 $temphosts2
echo "Done."
echo
echo
echo
