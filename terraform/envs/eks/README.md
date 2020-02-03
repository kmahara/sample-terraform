## 概要

AWS に以下のリソースを作成します。

- VPC
- EKS クラスター
- ECR リポジトリ
- bastion (踏み台用 EC2 インスタンス)

## 設定方法

- vi backend.tf

backend.tf.tmpl の {{...}} となっている箇所を置換します。

- vi terraform.tfvars

| 項目 | 説明 | 例
----
| service_name | サービス名 | test6
| stage | dev, stg, prd などを指定 | dev
| key_pair | 踏み台サーバにアクセスするときの ssh 公開鍵 |

## 実行

```
terraform init
terraform apply
```

実行すると以下のファイルが生成される。

- out/deployment.yaml
-- ../../templates/deployment.yaml をベースに生成される。
-- kubectl apply -f out/deployment.yaml のように実行すると、pod が作成される。
- out/env.sh
-- ../../templates/env.sh をベースに作成される。
-- シェルでいろいろバッチ処理を行うときに使用できる。
- out/kubeconfig_dev-test6
-- kubectl で今回作成した EKS クラスターに接続するために使用する。
```

### kubeconfig の使用例

```
kubectl --kubeconfig out/kubeconfig_dev-test6 apply -f out/deployment.yaml
```

### alias を使用すると便利

```
vi ~/.bashrc

# 以下の記述を追加
alias k='kubectl --kubeconfig terraform/out/kubeconfig_dev_test6'

# 現在使用中のシェルに設定を反映
. ~/.bashrc

# 以下のように使用する。
k apply -f out/deployemnt.yaml
```

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

# もしくは秘密鍵を明示的に指定して接続
ssh -i id_rsa ec2-user@18.138.250.67
```

### kubectl を使う

まず ~/.kube/config に EKS クラスターの設定を追加する。

```
aws eks update-kubeconfig --name クラスター名
```

複数のクラスターを管理していて切り替える場合

```
# コンテキスト一覧を表示
kubectl config get-contexts

# デフォルトで使用するコンテキストを変更する
Kubectl config use-context arn:aws:eks:ap-southeast-1:123456789012:cluster/dev-test6
```

いろいろ実行してみる。

```
# ノード一覧表示
kubectl get nodes -A

# pod 一覧表示
kubectl get pods -A

# サービス一覧表示
kubectl get svc -A
```
