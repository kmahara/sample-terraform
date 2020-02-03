## S3 に tfstate を格納した構成で、実際に共有できているかを確認する

1. まずはリソース作成

```
cd envs/dev
terraform init
terraform apply
```

S3 に格納されたオブジェクトを確認。

```
aws s3 ls mahara-terraform --recursive
aws s3api get-object --bucket mahara-terraform --key test6/dev s3
less s3
rm s3
```

DynamoDB にデータが追加されたことを確認。

```
aws dynamodb scan --table-name mahara-terraform-lock
```

2. 別のユーザが利用する手順を再現

```
cd ..
cp -a dev dev-test
cd dev-test
rm -rf terraform.tfstate* .terraform
```

リソースを削除してみる。

```
terraform init
terraform destroy
```

削除成功。

今度は作成した方に戻って apply してみる。

```
cd ../dev
terraform apply
```

すると、別ユーザによってリソースが削除されたことを認識しており、再度作成しようとするので意図通り。

