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
  イメージのタグは yyyyyMMdd_HHmmss 形式になっています。
  
  独自のイメージタグを設定する場合、イメージタグは毎回異なるものにしてください。
  そうしないと後述する rollout undo 機能が使用できません。
  
2. k8s/deployment.yaml を更新します。  
  同ディレクトリにある deployment.yaml.tmpl のベースに `__XXX__` となっている箇所を置換します。

### Kubernetes に反映する

```
make update
```

または

```
kubectl apply -f k8s
```

ロードバランサーの URL を確認します。

```
kubectl get svc

NAME         TYPE           CLUSTER-IP       EXTERNAL-IP                                                                          PORT(S)        AGE
kubernetes   ClusterIP      10.100.0.1       <none>                                                                               443/TCP        3h35m
service1     LoadBalancer   10.100.131.213   a80526393464c11ea857006576efaf26-90b0873a61ed8663.elb.ap-southeast-1.amazonaws.com   80:31318/TCP   133m
```

ブラウザでアクセスします。
http://a80526393464c11ea857006576efaf26-90b0873a61ed8663.elb.ap-southeast-1.amazonaws.com/

初回に kubectl apply を実行すると、ロードバランサーの作成や DNS への登録が行われ、DNS が浸透するのに数分かかります。
上記 URL で画面が出てくるようになるまで、しばらく待ちます。

### アプリケーションを修正してみる

src/server.go ファイルを適当に修正してみます。

```
vi src/server.go
```

| 修正前 | fmt.Fprintln(w, "version: 1") |
| 修正後 | fmt.Fprintln(w, "version: 2") |

ECR へのアップと Kubernetes への反映を行います。

```
make push
make update
```

この２つのコマンドを一度に実行するなら:

```
make up
```


ブラウザで reload すると、バージョン表示が更新されていることを確認します。

### undo 実施してみる

何度か Kubernetes への更新を行った後、履歴を見てみます。

```
make history

REVISION  CHANGE-CAUSE
...
18        2020-02-03_15:31:18 166641880126.dkr.ecr.ap-southeast-1.amazonaws.com/dev-test6:6ca7fd8
19        2020-02-03_153002 166641880126.dkr.ecr.ap-southeast-1.amazonaws.com/dev-test6:6ca7fd8
22        2020-02-03_17:25:27 166641880126.dkr.ecr.ap-southeast-1.amazonaws.com/dev-test6:20200203_172522
23        2020-02-03_17:25:53 166641880126.dkr.ecr.ap-southeast-1.amazonaws.com/dev-test6:20200203_172546
```

１つ前のバージョンに戻すには以下のコマンドを実行します。

```
make undo
```

このサンプルアプリケーションの場合、数秒で前のバージョンに戻ります。

もう一度履歴を見てみます。

```
make history

REVISION  CHANGE-CAUSE
...
18        2020-02-03_15:31:18 166641880126.dkr.ecr.ap-southeast-1.amazonaws.com/dev-test6:6ca7fd8
19        2020-02-03_153002 166641880126.dkr.ecr.ap-southeast-1.amazonaws.com/dev-test6:6ca7fd8
23        2020-02-03_17:25:53 166641880126.dkr.ecr.ap-southeast-1.amazonaws.com/dev-test6:20200203_172546
24        2020-02-03_17:25:27 166641880126.dkr.ecr.ap-southeast-1.amazonaws.com/dev-test6:20200203_172522
```

よく見ると、今回の 23, 24 は前回の 22, 23 が入れ替わったものであることを確認できます。
なのでこの状態で再度 undo すると、最新バージョンが再度反映されます。

ということで、make undo するたびに最新バージョンと１つ前のバージョンが交互に反映されます。

```
make undo
```

レビジョンを指定して戻すこともできます。

```
kubectl rollout undo deployment app1 --to-revision=19
```
