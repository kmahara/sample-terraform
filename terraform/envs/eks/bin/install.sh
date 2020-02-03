#!/bin/bash

cat <<EOF
以下のファイルを更新します。
../../../app/.env
~/.kube/config
EOF

echo -n "よろしいですか([y]/n) ?"

read x

if [ "$x" = "n" ]; then
	echo "Aborted."
	exit 1
fi

cp out/env.sh ../../../app/.env
cp out/kubeconfig_dev-test6 ~/.kube/config

echo "Done."
