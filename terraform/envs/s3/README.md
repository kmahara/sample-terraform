## 概要

Terraform の tfstate を AWS で管理するために、以下の作業を行います。

- S3 バケット作成
- DynamoDB にロック用テーブル作成

## 設定方法

- vi main.tf

main.tf.tmpl の {{...}} となっている箇所を置換します。

- vi terraform.tfvars

aws アクセスに関する設定を行います。

1. aws cli のデフォルトプロファイルを使用する場合

```
aws = {
  region = "ap-southeast-1"
}
```

2. aws cli の指定したプロファイルを使う場合

```
aws = {
  region = "ap-southeast-1"
  profile = "name1"
}
```

3. アクセスキーを指定する場合

```
aws = {
  region = "ap-southeast-1"
  access_key = "__ACCESS_KEY__"
  secret_key = "__SECRET_KEY__"
}
```

## 実行

```
terraform init
terraform apply
```
