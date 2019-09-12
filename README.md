Script to update dnshome.de ipv4 and ipv6 addresses based on https://gist.github.com/corny/7a07f5ac901844bd20c9

Usage: `[device (e.g. wlp5s0)] [dnshome.de subdomain] [dnshome password]`

To run script every 5 minutes, add:

`*/5 * * * * /path/to/script `

to your crontab using `crontab -e`
