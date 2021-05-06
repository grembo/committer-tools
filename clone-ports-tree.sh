#!/bin/sh

set -e

if [ "$#" != 3 ]; then
  2>&1 echo "Invalid number of parameters.
Usage: 

  $0 origin handle realname

  origin	name of remote to be used. Usually 'origin',
                FreeBSD project documentation uses 'freebsd'
                though.
  handle        FreeBSD user handle (e.g., 'grembo')
  realname      Your real name, as known to the project
                (e.g., 'Michael Gmelin')
                             
Examples:

  $0 freebsd jd \"Jane Doe\"
  $0 origin grembo \"Michael Gmelin\"

"
  exit 1  
fi

ORIGIN=$1
HANDLE=$2
REALNAME=$3

echo "Cloning tree (this will take a while)"
git clone -o freebsd https://git.freebsd.org/ports.git
cd ports
echo "Configuring repo"
git config user.name "$REALNAME"
git config user.email "$HANDLE@FreeBSD.org"
git config merge.renameLimit 999999
git remote set-url --push freebsd \
  ssh://git@repo.freebsd.org/src.git
git config pull.rebase true

echo
echo "Your git config is:"
git config -l --show-origin
echo
echo "Your git remotes are:"
git remote -v
echo
echo "Successfully cloned and configured ports tree.

To install a commit message preparation hook, run:

fetch -o ports/.git/hooks/prepare-commit-msg \\
  https://raw.githubusercontent.com/grembo/\
committer-tools/main/ports-prepare-commit-msg
chmod 755 ports/.git/hooks/prepare-commit-msg

Happy hacking!
"
