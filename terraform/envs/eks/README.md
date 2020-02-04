## 概要

AWS に以下のリソースを作成します。

- VPC
- EKS クラスター
- ECR リポジトリ
- bastion (踏み台用 EC2 インスタンス)

## 設定方法

```
vi backend.tf
```

backend.tf.tmpl の {{...}} となっている箇所を置換します。

```
vi terraform.tfvars
```

| 項目 | 説明 | 例 |
----|----|----
| service_name | サービス名 | test6 |
| stage | dev, stg, prd などを指定 | dev |
| key_pair | 踏み台サーバにアクセスするときの ssh 公開鍵 |

## 実行

```
terraform init
terraform apply
```

実行すると以下のファイルが生成されます。

- out/env.sh
-- ../../templates/env.sh をベースに作成される。
-- シェルでいろいろバッチ処理を行うときに使用できる。
- out/kubeconfig_dev-test6
-- kubectl で今回作成した EKS クラスターに接続するために使用する。

## 自分の環境への反映

以下のコマンドを実行すると、out で生成されたファイルが適切な場所へ反映されます。

```
make install
```

1. out/env.sh が ../../../app/.env という名前でインストールされます。
2. out/kubeconfig_* は ~/.kube/config にコピーされます。

## 確認

### コマンドラインから確認する場合

```
# vpc
aws ec2 describe-vpcs | jq '.Vpcs[] | select(.Tags and .Tags[].Key == "Name" and .Tags[].Value == "dev-test6")'

# subnet
aws ec2 describe-subnets | jq '.Subnets[] | select(.Tags and .Tags[].Key == "kubernetes.io/cluster/dev-test6")'

# EC2
aws ec2 describe-instances
```

### 踏み台サーバにログインしてみる

```
ssh ec2-user@18.138.250.67
```

もしくは秘密鍵を明示的に指定して接続

```
ssh -i id_rsa ec2-user@18.138.250.67
```

### kubectl を使う

いろいろ実行してみる。

```
# ノード一覧表示
kubectl get nodes -A

# pod 一覧表示
kubectl get pods -A

# サービス一覧表示
kubectl get svc -A
```
