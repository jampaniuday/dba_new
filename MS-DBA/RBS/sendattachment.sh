#! /bin/ksh
/usr/lib/sendmail -f traiana.reports@traiana.com -v $2 <<EOF
To:ms-dba@traiana.com
Cc:
Subject: $3
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="==Traina====================="

--==Porsche=====================
Content-Type: text/plain; charset="us-ascii"

Attached Traina Sunday Maintanence Report

--==Traina=====================
Content-Type: application/octet-stream; name="${1##*/}"
Content-Transfer-Encoding: binary
Content-Disposition: attachment; filename="${1##*/}"

`cat $1`
--==Traina====================--
EOF

