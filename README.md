# ファイル構成

- app/ - Kubernetes に対して配置するサンプルアプリケーション
- terraform/ - Terraform 設定ファイル

# Getting Started

## aws cli 設定

最初に AWS に対して EKS クラスターを作成するためのアカウント設定を行ってください。

現在の設定を確認。

```
aws configure list
```

デフォルトプロファイルを変更する場合。

```
aws configure
```

プロファイルを作成する場合。

```
aws configure --profile trasis
```

## Terraform 設定

```
cd terraform/env/eks
cp terraform.tfvars.sample terraform.tfvars
vi terraform.tfvars
```

## Terraform 実行

```
terraform init
terraform apply
```

## 動作確認

Kubernetes にアクセスしてみる。

```
kubectl --kubeconfig out/kubeconfig_dev-test6 get pods -A
```

踏み台サーバに ssh ログインしてみる。

```
ssh ec2-user@<IP アドレス>
```

## 生成されたファイルをもとに各種設定

1. アプリケーションに対する設定

```
cp out/env.sh ../../../app/.env
```

2. kubectl に対する設定

```
cp out/kubeconfig_dev-test6 ~/.kube/config
```

## アプリケーションをビルド＆実行する

```
cd ../../../app
docker-compose up
```

ブラウザで http://localhost:8080/ にアクセスしてみる。

### Docker イメージを ECR に push する

```
make push
```

### Kubernetes に反映する

```
make update
```

または

```
kubectl apply -f k8s
```
