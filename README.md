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

`terraform apply` に成功すると、out ディレクトリに以下のファイルが生成されます。

- kubeconfig_xxxx - kubectl 用の設定ファイル
- env.sh - シェルスクリプト用設定ファイル

このコマンドを実行すると、以下の処理が行われます。

```
make install
```

1. app/ ディレクトリ配下に .env を配置します。  
  .env はシェルスクリプト形式のファイルで、生成された ECR リポジトリの URI などが記載されています。

2. ~/.kube/config を置き換えます。

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

このコマンドを実行すると、以下の処理が行われます。

1. Docker イメージをビルドして ECR へ push。  
  イメージのタグは最後に git commit したときの ID (ハッシュ) の先頭 7 文字です。
  以下のコマンドの実行結果となります。
  
  ```
  git rev-parse --short HEAD
  ```
  
2. k83/deployment.yaml を更新します。  
  同ディレクトリにある deployment.yaml.tmpl のベースに `__XXX__` となっている箇所を置換します。

### Kubernetes に反映する

```
make update
```

または

```
kubectl apply -f k8s
```
