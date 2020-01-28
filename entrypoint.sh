#!/usr/bin/env sh

UMASK=$(which umask)
UMASK_SET=${UMASK_SET:-022}

if [[ ! -x $UMASK ]]; then
  echo "umask binary not found"
  exit 1
fi

echo $UMASK "$UMASK_SET"
$UMASK "$UMASK_SET"

CONFD=$(which confd)

if [[ ! -x $CONFD ]]; then
  echo "confd binary not found"
  exit 1
fi

echo $CONFD -onetime -backend env -log-level debug
$CONFD -onetime -backend env -log-level debug || exit 1

VSFTPD=$(which vsftpd)
VSFTPD_CONFIG=${VSFTPD_CONFIG:-/etc/vsftpd/vsftpd.conf}
if [[ ! -x $VSFTPD ]]; then
  echo "vsftpd binary not found"
  exit 1
fi

mkdir -p ${VSFTPD_CHROOT:-/var/run/vsftpd/empty} /var/log/
( umask 0 && truncate -s0 /var/log/{vsftpd.log,xferlog} )
tail --pid $$ -n0 -F /var/log/{vsftpd.log,xferlog} &

cat ${VSFTPD_CONFIG}
echo ${*:-${VSFTPD} ${VSFTPD_CONFIG}}
exec ${*:-${VSFTPD} ${VSFTPD_CONFIG}}