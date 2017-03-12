#!/bin/bash

file="${1}"
charset=${2}

tmpfile=$(mktemp)

w3m -I ${charset} -T text/html -dump ${file} > ${tmpfile}

sed  -i -e '/^$/d' -e 's/^\s\{1\}$//g'  ${tmpfile}

# grep only the relevant gpg lines to decrypt.
# this will output ALL encrypted instances to $TEMPFILE
sed -n '/^-----BEGIN PGP MESSAGE/,/^-----END PGP MESSAGE/p' ${tmpfile} > ${tmpfile}.gpg

if [[ -s ${tmpfile}.gpg ]]; then
	echo -n "GPG Passphrase: "; read -s passphrase
	echo "${passphrase}" | gpg --passphrase-fd 0 --batch --no-verbose --quiet --output - ${tmpfile}.gpg | less
else
	less ${tmpfile}
fi

rm -f ${tmpfile} ${tmpfile}.gpg
