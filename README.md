# CodeHandoff Notes

## URL

- GitHub Repository: https://github.com/TakuyaYamane/code-handoff-notes
- Demo: http://43.207.188.47

CodeHandoff Notes は、GitHubリポジトリの情報をもとに、ソフトウェアの引き継ぎドキュメントを作成する Ruby on Rails アプリです。

ソフトウェア開発における「属人化」「引き継ぎ不足」「ドキュメント不足」という課題に対して、プロジェクト情報・リポジトリ情報・セットアップ手順・運用メモ・リスクなどを整理し、Markdown形式のドキュメントとして残せるようにすることを目的としています。

## 作成した理由

私は、ソフトウェア開発におけるコード理解、保守、引き継ぎ、ドキュメント化の課題に強い関心があります。

開発現場では、重要な情報が個人の頭の中に残ったままになり、担当者が変わったときに仕様や運用方法が分からなくなることがあります。

このアプリでは、GitHubリポジトリを起点に情報を整理し、次の開発者が理解しやすい引き継ぎドキュメントを作成する流れを実装しました。

## 主な機能

- プロジェクトの作成・表示・編集・削除
- GitHubリポジトリの登録
- GitHub APIからリポジトリ情報を取得
- リポジトリ詳細画面でGitHub情報を表示
- 引き継ぎドキュメントの作成・編集
- GitHub情報を含めたMarkdownドキュメント生成
- 日本語UI
- デモデータの作成
- AWS EC2上での本番公開

## スクリーンショット

### プロジェクト一覧

![プロジェクト一覧](docs/images/project-index.png)

### リポジトリ詳細

![リポジトリ詳細](docs/images/repository-detail.png)

### 引き継ぎドキュメント

![引き継ぎドキュメント](docs/images/handoff-document.png)

## 技術スタック

- Ruby 3.4.7
- Ruby on Rails
- PostgreSQL
- ERB
- CSS
- GitHub API
- HTTParty
- Git / GitHub
- AWS EC2
- Amazon RDS for PostgreSQL
- Nginx
- Puma
- systemd

## データベース設計

```text
Project
  has_many :repositories

Repository
  belongs_to :project
  has_one :handoff_document

HandoffDocument
  belongs_to :repository
```

主なモデルは `Project`、`Repository`、`HandoffDocument` の3つです。

`Project` は複数の `Repository` を持ちます。  
`Repository` は1つの `Project` に所属します。  
`Repository` は1つの `HandoffDocument` を持ちます。  
`HandoffDocument` は1つの `Repository` に所属します。

この構成により、1つのソフトウェアプロジェクトに対して複数のリポジトリを登録し、それぞれに引き継ぎドキュメントを作成できます。

## アプリの流れ

このアプリでは、以下の流れで引き継ぎドキュメントを作成します。

```text
1. プロジェクトを作成する
2. GitHubリポジトリを登録する
3. GitHub APIからリポジトリ情報を取得する
4. システム概要・主な機能・DB設計・セットアップ手順などを入力する
5. Markdown形式の引き継ぎドキュメントを生成する
```

GitHubリポジトリを起点に、プロジェクト情報と運用メモを整理し、他の開発者が理解しやすい引き継ぎドキュメントとして残せるようにしています。

## GitHub API連携

登録されたGitHubリポジトリURLから、以下の情報を取得します。

- 正式なリポジトリ名
- GitHub上の説明
- 主な言語
- スター数
- デフォルトブランチ
- 最終更新日時
- GitHub URL

取得した情報は、リポジトリ詳細画面だけでなく、生成される引き継ぎドキュメントにも反映されます。

## AWSデプロイ構成

本アプリは、AWS上に以下の構成でデプロイしています。

```text
User
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

### 使用しているAWSサービス

- Amazon EC2：Railsアプリケーションサーバー
- Amazon RDS for PostgreSQL：本番データベース
- Amazon EBS：EC2のストレージ
- Security Group：SSH、HTTP、HTTPS、PostgreSQL接続の制御

### サーバー構成

EC2上にUbuntuサーバーを構築し、Nginxをリバースプロキシとして設定しています。

RailsアプリケーションはPumaで起動し、systemdでサービス化しています。  
これにより、EC2上でPumaを常駐起動できるようにしています。

データベースには Amazon RDS for PostgreSQL を使用し、Railsアプリから `DATABASE_URL` を通して接続しています。

### 本番環境で使用している環境変数

- `RAILS_ENV=production`
- `DATABASE_URL`
- `RAILS_MASTER_KEY`
- `SECRET_KEY_BASE`
- `GITHUB_TOKEN`

秘密情報はGitHubには含めず、EC2上の環境変数ファイルで管理しています。

## AWS構築で行ったこと

- AWSアカウント作成
- MFA設定
- Budgetsによる料金アラート設定
- EC2インスタンス作成
- キーペア作成
- セキュリティグループ設定
- SSH接続確認
- EC2インスタンスタイプ変更
- EBSボリューム拡張
- Ubuntu上にRuby 3.4.7をインストール
- Bundlerのインストール
- GitHubからRailsアプリをclone
- `bundle install`
- RDS PostgreSQL作成
- EC2からRDSへの接続確認
- `DATABASE_URL` の設定
- `RAILS_MASTER_KEY` の設定
- `SECRET_KEY_BASE` の設定
- production環境で `db:migrate`
- production環境で `db:seed`
- production環境で `assets:precompile`
- Pumaをsystemdで常駐化
- NginxからPumaへリクエストを転送
- EC2のパブリックIPでRailsアプリを表示
- Nginxから静的assetsを配信できるように権限を調整

## ローカル環境でのセットアップ

```bash
git clone https://github.com/TakuyaYamane/code-handoff-notes.git
cd code-handoff-notes
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
bin/rails server
```

ブラウザで以下を開きます。

```text
http://localhost:3000
```

## デモデータ

以下のコマンドで、デモ用のプロジェクト、リポジトリ、引き継ぎドキュメントが作成されます。

```bash
bin/rails db:seed
```

作成されるデモデータは、名前に `【デモ】` を付けています。

これにより、アプリを起動した直後でも、プロジェクト作成から引き継ぎドキュメント生成までの流れを確認できます。

## 工夫した点

### 1. ソフトウェア引き継ぎという実務に近い課題をテーマにしたこと

単なるCRUDアプリではなく、ソフトウェア開発における「引き継ぎ」「コード理解」「ドキュメント化」という課題をテーマにしました。

プロジェクト情報、リポジトリ情報、セットアップ手順、運用メモ、リスクを整理することで、他の開発者がプロジェクトを理解しやすくなることを目指しています。

### 2. GitHub APIを利用したこと

手入力だけでなく、実際のGitHubリポジトリ情報を取得し、リポジトリ詳細画面と引き継ぎドキュメントに反映できるようにしました。

これにより、GitHubリポジトリを起点にしたドキュメント作成の流れを実装しています。

### 3. デモデータを用意したこと

`bin/rails db:seed` を実行すると、すぐにアプリの使用例を確認できるようにしています。

初めてアプリを見る人でも、どのような情報を登録し、どのようなドキュメントが生成されるのかを理解しやすくしました。

### 4. 日本語UIにしたこと

採用担当者や開発者が、画面を見ただけで使い方を理解しやすいように、日本語UIにしています。

ボタンやフォーム、説明文も日本語にし、アプリの目的が伝わりやすくなるようにしました。

### 5. Markdown形式でドキュメントを生成したこと

引き継ぎドキュメントはMarkdown形式で生成されます。

Markdownにすることで、GitHubのREADME、社内Wiki、Issue、Pull Requestなどにも転用しやすい形式にしています。

### 6. AWS上に自分でサーバーを構築したこと

Railsアプリをローカルで動かすだけでなく、AWS EC2上にUbuntuサーバーを構築し、Nginx、Puma、RDS PostgreSQLを使って本番環境として公開しました。

EC2、RDS、Security Group、EBS、Nginx、Puma、systemd、環境変数管理など、Webアプリを外部公開するために必要なサーバー構築の流れを実際に経験しました。

## AWS構築で学んだこと

- EC2はAWS上でLinuxサーバーを構築するために使う
- セキュリティグループでSSH、HTTP、HTTPS、PostgreSQLの通信を制御する
- Nginxは外部からのHTTPリクエストを受けるWebサーバーとして使う
- PumaはRailsアプリケーションを動かすアプリケーションサーバーとして使う
- RDSは本番環境のPostgreSQLデータベースとして利用できる
- 本番環境では `DATABASE_URL`、`RAILS_MASTER_KEY`、`SECRET_KEY_BASE` などの環境変数が必要になる
- RubyのビルドにはCPU、メモリ、ディスク容量が必要
- 小さいインスタンスではRubyビルド時に容量不足や接続切れが起きることがある
- EBSボリュームを拡張することで、EC2のディスク容量を増やせる
- systemdを使うことで、Pumaをサービスとして常駐化できる
- NginxからPumaへリクエストを転送することで、Railsアプリを外部公開できる
- Nginxで静的assetsを配信するには、ファイルの配置と権限設定が重要になる

## 今後の改善

- 独自ドメイン設定
- HTTPS化
- 認証機能
- チーム共有機能
- Markdownエクスポート機能
- GitHubリポジトリ内のREADMEやファイル構成の取得
- AIによる引き継ぎドキュメント生成
- テスト追加
- エラーハンドリング強化
- 本番環境でのログ管理
- UIのさらなる改善

## このアプリで学んだこと

- RailsのMVC構成
- Active Recordの関連
- CRUD実装
- ネストしたルーティング
- フォーム実装
- バリデーション
- 外部API連携
- Service Objectの作成
- Markdown生成
- Git / GitHubでの開発管理
- READMEによるポートフォリオの見せ方
- AWS EC2でのサーバー構築
- RDS PostgreSQLとの接続
- NginxとPumaを使ったRailsアプリ公開
- systemdによるPumaの常駐化
- 本番環境での環境変数管理

## 今後の展望

今後は、GitHubリポジトリ内のREADMEやファイル構成も取得し、より具体的な引き継ぎドキュメントを生成できるようにしたいと考えています。

また、AIを活用して、コードやREADMEからシステム概要や注意点を自動生成する機能にも発展させたいです。

最終的には、開発者がプロジェクトを引き継ぐ際に、短時間で全体像を理解できるような支援ツールにしていきたいです。