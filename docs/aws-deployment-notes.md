# AWS Deployment Notes

## 概要

CodeHandoff Notes を AWS 上にデプロイし、Ruby on Rails アプリケーションを本番環境で公開した際の構築メモです。

このメモは、AWSで行った作業、構成、詰まった点、解決方法、面接で説明する要点を整理するために作成しています。

## 構成

```text
User
  ↓
Elastic IP
  ↓
EC2
  ↓
Nginx
  ↓
Puma
  ↓
Rails
  ↓
RDS PostgreSQL
```

## 使用した主な技術・サービス

* AWS EC2
* Elastic IP
* Amazon RDS for PostgreSQL
* Amazon EBS
* Security Group
* Ubuntu
* Nginx
* Puma
* systemd
* Ruby 3.4.7
* Ruby on Rails
* PostgreSQL

## 実施したこと

* AWSアカウント作成
* rootユーザーへのMFA設定
* Budgetsによる料金アラート設定
* EC2インスタンス作成
* キーペア作成
* セキュリティグループ設定
* MacからEC2へのSSH接続確認
* EC2インスタンスタイプ変更
* EBSボリューム拡張
* Elastic IPの作成とEC2への関連付け
* Ubuntuパッケージの更新
* Git、curl、build-essential、PostgreSQL client、Nginxなどのインストール
* rbenvのインストール
* Ruby 3.4.7 のインストール
* Bundlerのインストール
* GitHubからRailsアプリをclone
* Railsアプリで bundle install
* RDS PostgreSQL作成
* EC2からRDSへの接続確認
* DATABASE_URLの設定
* RAILS_MASTER_KEYの設定
* SECRET_KEY_BASEの設定
* production環境で db:migrate
* production環境で db:seed
* production環境で assets:precompile
* Pumaをsystemdで常駐化
* NginxからPumaへリクエストを転送
* EC2再起動後の自動起動確認
* 本番URLでRailsアプリ表示確認
* 本番URLでCSS反映確認
* GitHub API取得の本番環境での確認
* 本番環境でデモデータ表示確認
* 本番環境で新規作成・削除の動作確認

## EC2構築

EC2上にUbuntuサーバーを構築し、Railsアプリケーションを動かすための環境を整えました。

主に行ったことは以下です。

* SSH接続設定
* Ruby 3.4.7 のインストール
* Bundlerのインストール
* Railsアプリケーションのclone
* bundle install
* Nginxのインストール
* PostgreSQL clientのインストール
* 環境変数ファイルの作成

## RDS PostgreSQL構築

本番環境のデータベースとして Amazon RDS for PostgreSQL を使用しました。

主に行ったことは以下です。

* PostgreSQLエンジンでRDSを作成
* 初期データベース名を設定
* マスターユーザーを設定
* EC2から接続できるように設定
* パブリックアクセスは無効化
* EC2からpsqlで接続確認
* Rails production環境から db:migrate / db:seed を実行

## 環境変数管理

本番環境では、秘密情報をGitHubに含めず、EC2上の環境変数ファイルで管理しました。

使用した主な環境変数は以下です。

```text
RAILS_ENV=production
DATABASE_URL
RAILS_MASTER_KEY
SECRET_KEY_BASE
GITHUB_TOKEN
```

`DATABASE_URL` にはRDS PostgreSQLへの接続情報を設定しました。

`RAILS_MASTER_KEY` は Rails credentials を読むために設定しました。

`SECRET_KEY_BASE` は production 環境でRailsを起動するために設定しました。

## Puma設定

Railsアプリケーションサーバーとして Puma を使用しました。

Pumaはsystemdでサービス化し、EC2再起動後も自動で起動するように設定しました。

確認したことは以下です。

* systemdサービスファイル作成
* Pumaの起動確認
* `active (running)` の確認
* EC2再起動後も自動起動することの確認

## Nginx設定

Nginxをリバースプロキシとして設定し、外部からのHTTPアクセスをPumaへ転送しました。

構成は以下です。

```text
Browser
  ↓
Nginx
  ↓
Puma
  ↓
Rails
```

また、production環境でprecompileしたassetsをNginxから配信できるようにしました。

## 詰まった点と解決

### Rubyビルド時の容量不足

Ruby 3.4.7 のインストール時に、ビルド中の一時ファイル作成で容量不足が発生しました。

対応として、EC2インスタンスタイプを変更し、EBSボリュームを拡張しました。

これにより、Ruby 3.4.7 のインストールを完了できました。

### systemdからPumaを起動できない問題

手動では `bundle` が使えるのに、systemdからPumaを起動すると `bundle` が見つからない問題が発生しました。

原因は、systemd実行時にrbenvのPATHが正しく読み込まれていなかったことです。

対応として、systemdのサービスファイルにPATHを明示し、ExecStartでrbenv配下のbundleを使うように修正しました。

### secret_key_base不足

production環境でRailsを起動した際、`secret_key_base` が不足しているエラーが発生しました。

対応として、`SECRET_KEY_BASE` を生成し、EC2上の環境変数ファイルに追加しました。

### Nginx経由でCSSが反映されない問題

Railsアプリ自体は表示されましたが、CSSが反映されない問題が発生しました。

調査すると、HTML内では `/assets/application-xxxx.css` を読み込もうとしていましたが、Nginx経由では404になっていました。

対応として、`public/assets` 配下と親ディレクトリの権限を調整し、Nginxが静的ファイルを読めるようにしました。

### SSH接続できなくなった問題

EC2にSSH接続できなくなったことがありました。

原因は、セキュリティグループのSSH許可IPが現在のIPと合っていなかったことです。

対応として、EC2のセキュリティグループでSSHのソースを現在のマイIPに更新しました。

## 動作確認

本番環境で以下を確認しました。

* 本番URLでトップページが表示される
* CSSが反映される
* デモデータが表示される
* GitHub APIからリポジトリ情報を取得できる
* 引き継ぎドキュメントが表示される
* 新規プロジェクトを作成できる
* 作成したプロジェクトを削除できる
* Pumaがsystemdで起動している
* Nginxが起動している
* EC2再起動後もRailsアプリが自動起動する

## 面接で説明する要点

* AWS EC2上にUbuntuサーバーを構築した
* RailsアプリをEC2上にデプロイした
* Nginxをリバースプロキシとして設定した
* Pumaをsystemdで常駐化した
* DBにはAmazon RDS for PostgreSQLを使用した
* EC2からRDSへ接続できるようにした
* 秘密情報は環境変数で管理した
* EC2再起動後もRailsアプリが自動起動することを確認した
* 本番URLからRailsアプリにアクセスできる状態にした
* Rubyビルド、systemd、secret_key_base、assets配信などで発生した問題を調査して解決した

## 学んだこと

* EC2はAWS上でLinuxサーバーを構築するために使う
* RDSは本番環境のデータベースとして利用できる
* セキュリティグループでSSH、HTTP、PostgreSQL接続を制御する
* Nginxは外部からのHTTPリクエストを受けるWebサーバーとして使う
* PumaはRailsアプリケーションを動かすアプリケーションサーバーとして使う
* systemdを使うことでPumaを常駐化できる
* 本番環境では環境変数管理が重要になる
* Rails production環境ではassets precompileが必要になる
* Nginxでassetsを配信するにはファイル権限も重要になる
* サーバー構築では、CPU、メモリ、ディスク容量、ネットワーク、権限設定を総合的に見る必要がある

## 今後の改善

* 独自ドメインの設定
* HTTPS化
* ログ管理の改善
* デプロイ手順の自動化
* バックアップ運用の整理
* 監視設定の追加
* セキュリティグループのさらなる見直し
* 本番環境の運用手順のドキュメント化
