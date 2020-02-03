## 概要

- backend.tf で tfstate の格納に S3 を利用します。
- main.tf で dev-app1 のような名前でECR リポジトリを作成します。

## 設定方法

- vi backend.tf

backend.tf.tmpl の {{...}} となっている箇所を置換します。


- vi terraform.tfvars

| 項目 | 説明 | 例
----
| service_name | サービス名 | test6
| stage | dev, stg, prd などを指定 | dev

## 実行

```
terraform init
terraform apply
```

## その他

(テスト)[[TEST.md]]
