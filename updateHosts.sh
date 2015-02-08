#!/bin/bash


# Let's create our temporary files
temphosts1=$(mktemp)
temphosts2=$(mktemp)

# Obtain various hosts files and merge into one
# You can add/remove more as you wish.
echo "Downloading ad-blocking hosts files..."
curl -sS http://winhelp2002.mvps.org/hosts.txt > $temphosts1
curl -sS http://someonewhocares.org/hosts/zero/hosts >> $temphosts1
curl -sS "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext&useip=0.0.0.0" >> $temphosts1
curl -sS https://raw.githubusercontent.com/nomadturk/vpn-adblock/master/hosts-sources/Turkish/hosts >> $temphosts1
curl -sS "http://hosts-file.net/.%5Cad_servers.txt" >> $temphosts1
curl -sS https://adaway.org/hosts.txt >> $temphosts1
curl -sS http://www.malwaredomainlist.com/hostslist/hosts.txt >> $temphosts1

# Do some work on the file:
# 1. Remove MS-DOS carriage returns
# 2. Delete all lines that don't begin with 127.0.0.1 or 0.0.0.0
# 3. Delete any lines containing the word localhost because we'll obtain that from the original hosts file
# 4. Replace 127.0.0.1 with 0.0.0.0 because then we don't have to wait for the resolver to fail
# 5. Scrunch extraneous spaces separating address from name into a single tab
# 6. Delete any comments on lines
# 7. Clean up leftover trailing blanks
# 8. Finally, delete all lines that don't begin with 0.0.0.0 to make sure that all remnants are removed
# Pass all this through sort with the unique flag to remove duplicates and save the result
echo 
echo "Parsing" 
echo "Cleaning""
echo "De-duplicating"
echo "Sorting..."
echo 
sed -e 's/\r//'                         \
    -e '/^127.0.0.1\|0.0.0.0/!d'        \
    -e '/localhost/d'                   \
    -e 's/127.0.0.1/0.0.0.0/'           \
    -e 's/ \+/\t/'                      \
    -e 's/#.*$//'                       \
    -e '/^0.0.0.0/!d'                   \
    -e 's/[ \t]*$//'                    \
     < $temphosts1 | sort -u > $temphosts2

# Combine system hosts with adblocks
echo "Creating supplementary hosts file is complete..."
echo -e "\n# Ad blocking hosts generated "$(date) | cat $temphosts2 > ~/hosts.supp
# Clean up temp files and remind user to copy new file
echo "Time to clean up..."
rm $temphosts1 $temphosts2
echo "Done."
echo
echo "Copying ad-blocking hosts file with this command:"
echo "We are going to use a supplementary file named hosts.supp"
echo "This is required to not to mess with the existing hosts file"
echo "cp ~/hosts.supp /etc"
cat ~/hosts.supp > /etc/hosts.supp
echo
echo "You can always delete or update this file or just remove any references"
echo "from DNSMasq or whatever you use it with"
echo
