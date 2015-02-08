#Adblocking Softether VPN with DNSMasq Supplementary Hosts file
Here, you can find the config files and script I use on my own system to run an ads-free network when I'm connected to VPN
I do use Softether VPN, DNSMasq and some cron jobs to ensure it's running stable.

This repo consolidates several reputable `hosts` files and consolidates them into a single hosts file that you can use.

**Currently this hosts file contains 48674 unique entries.**

## Source of hosts are listed here

Currently the `hosts` files from the following locations are amalgamated:

* MVPs.org Hosts file at [http://winhelp2002.mvps.org/hosts.htm](http://winhelp2002.mvps.org/hosts.htm), updated monthly, or thereabouts.
* Dan Pollock at [http://someonewhocares.org/hosts/](http://someonewhocares.org/hosts/) updated regularly.
* Malware Domain List at [http://www.malwaredomainlist.com/](http://www.malwaredomainlist.com/), updated regularly.
* Peter Lowe at [http://pgl.yoyo.org/adservers/](http://pgl.yoyo.org/adservers/), updated regularly.
* AdAway at [http://adaway.org/](http://adaway.org/), updated regularly
* Hosts-file.net ad blocking servers [http://hosts-file.net/](http://adaway.org/), updated regularly
* My own rules for blocking Turkish Advertising Agencies

You can add any additional sources you'd like under the data/ directory. Provide a copy of the current `hosts` file and a file called
update.info with the URL to the `hosts` file source. This will allow updateHostsFile.py to automatically update your source.


## What is a hosts file?

A hosts file, named `hosts` (with no file extension), is a plain-text file used by all operating systems to map hostnames to IP addresses. 

In most operating systems, the `hosts` file is preferential to `DNS`.  Therefore if a host name is resolved by the `hosts` file, the request never leaves your computer.

Having a smart `hosts` file goes a long way towards blocking malware, adware, and other irritants.

For example, to nullify requests to some doubleclick.net servers, adding these lines to your hosts file will do it:

    # block doubleClick's servers
    127.0.0.1 ad.ae.doubleclick.net
    127.0.0.1 ad.ar.doubleclick.net
    127.0.0.1 ad.at.doubleclick.net
    127.0.0.1 ad.au.doubleclick.net
    127.0.0.1 ad.be.doubleclick.net
    # etc...



## Location of your hosts file
To modify your current `hosts` file, look for it in the following places and modify it with a text editor.

**Mac OS X, iOS, Android, Linux**: `/etc/hosts` folder.

**Windows**: `%SystemRoot%\system32\drivers\etc\hosts` folder.

## Reloading hosts file
Your operating system will cache DNS lookups. You can either reboot or run the following commands to manually flush your DNS cache once the new hosts file is in place.

If you are running DNSMasq on your system run:
`/etc/init.d/dnsmasq restart`

Otherwise, considering you have nscd installed, open a Terminal and run:
`/etc/init.d/nscd restart`
