#!/bin/sh
# 実行すると以下の処理を行います。
# 
# 1. ECR へイメージをプッシュ
#  タグは最後に git commit したときのハッシュ先頭 7 文字となります。 
# git rev-parse --short HEAD
#
# 2. k83/deployment.yaml の Docker リポジトリ URI を修正します。

CWD=`dirname $0`
ROOT=$(cd $CWD/..; pwd)
cd $ROOT

ENVFILE=$ROOT/.env

if [ $ENVFILE ]; then
	. $ENVFILE
fi

if [ "$IMAGE_NAME" = "" ]; then
        IMAGE_NAME=test
fi


SHORT_SHA=`git rev-parse --short HEAD`

TAG=$DOCKER_REPOSITORY_URI:$SHORT_SHA

# =================================================================

if [ "$DOCKER_REPOSITORY_URI" = "" ]; then
	echo "DOCKER_REPOSITORY_URI is not set. Aborted."
	exit 1
fi


# =================================================================
echo "## Push image $IMAGE_NAME to $TAG"
echo

docker build -t $IMAGE_NAME .
docker tag $IMAGE_NAME $TAG

$(aws ecr get-login --no-include-email)

docker push $TAG

# =================================================================

echo "## update k8s/deployment.yaml"
echo

DATE=`date "+%Y%m%d_%H%M%S"`

sed \
-e "s#__ECR_REPOSITORY_URI__#${TAG}#" \
-e "s#__DATE__#${DATE}#" \
$ROOT/k8s/deployment.yaml.tmpl > $ROOT/k8s/deployment.yaml

