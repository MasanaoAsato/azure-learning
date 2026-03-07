# Architecture 03 — Azure: Front Door (CDN + WAF) + Storage Account Static Website

このディレクトリ（architectures/03）は、Azure Front Door（CDN / WAF）を利用して Azure Storage Account の静的 Web サイトホスティングをセキュアに配信する構成を学習するための Terraform 構成を含んでいます。グローバルなコンテンツ配信、キャッシュ、WAF によるセキュリティ保護、HTTPS リダイレクトなどの実践的なパターンを学べます。

## 学習の目的

- 静的 Web サイトホスティング：`Azure Storage Account` の Static Website 機能を使った HTML コンテンツの配信方法を理解する。
- グローバル CDN 配信：`Azure Front Door`（Premium SKU）を CDN として利用し、オリジン（Storage Account）へのトラフィックを最適化する方法。
- WAF によるセキュリティ保護：`Front Door Firewall Policy` を使ったレートリミット（IP 単位）、マネージドルールセット（DefaultRuleSet / BotManagerRuleSet）による防御。
- セキュリティポリシーの適用：WAF ポリシーを Front Door エンドポイントに関連付けるセキュリティポリシーの構成。
- HTTPS とキャッシュ：Front Door による HTTPS リダイレクト、キャッシュ戦略（クエリ文字列の無視、圧縮）の設定。
- ヘルスプローブとロードバランシング：Origin Group のヘルスプローブ設定とロードバランシングの挙動。
- Storage Account のセキュリティ強化：TLS 1.2 強制、インフラ暗号化、OAuth 認証デフォルト化、SFTP 無効化などのベストプラクティス。
- Terraform モジュール化：再利用可能なモジュール（resource_group / storage_account / front_door）の使い方。

## 想定するアーキテクチャ要素

- Resource Group：すべてのリソースを束ねる論理的なコンテナ
- Azure Storage Account：静的 Web サイトホスティング（`$web` コンテナ）を有効にした StorageV2 アカウント
- Azure Front Door Profile：Premium_AzureFrontDoor SKU の CDN プロファイル（SystemAssigned マネージド ID 付き）
- Front Door Firewall Policy（WAF）：レートリミットルール、DefaultRuleSet、BotManagerRuleSet を Prevention モードで適用
- Front Door Security Policy：WAF ポリシーをエンドポイントに関連付けるセキュリティポリシー
- Front Door Endpoint：クライアントがアクセスする CDN エンドポイント
- Front Door Origin Group：ヘルスプローブとロードバランシング設定を持つオリジングループ
- Front Door Origin：Storage Account の静的 Web サイトエンドポイントをオリジンとして設定
- Front Door Route：ルーティングルール（HTTPS リダイレクト、キャッシュ、圧縮設定）

## 接続フロー

1. クライアント（ブラウザ） → HTTPS → `Azure Front Door Endpoint`
2. `Front Door WAF Policy` → レートリミット / マネージドルールによるリクエスト検査・ブロック
3. `Azure Front Door` → キャッシュヒット時はキャッシュから応答 / キャッシュミス時は Origin へ転送
4. `Azure Front Door Origin` → HTTPS → `Azure Storage Account` 静的 Web サイト（`$web` コンテナ）
5. Storage Account → HTML コンテンツ（index.html / not_found.html）を返却

## ディレクトリ構成

```
architectures/03/
├── main/                   # メインの Terraform 構成
│   ├── main.tf             # モジュールの呼び出し
│   ├── local.tf            # ローカル変数（プレフィックス、Front Door 設定値）
│   ├── outputs.tf          # 出力値の定義
│   └── provider.tf         # Azure プロバイダ設定
└── modules/                # 再利用可能なモジュール
    ├── resource_group/     # リソースグループ
    ├── storage_account/    # Storage Account、Static Website、Blob（HTML）定義
    └── front_door/         # Front Door Profile、WAF Policy、Security Policy、Endpoint、Origin Group、Origin、Route 設定
```

## 前提

- mise で必要なツールがインストールされていること
- Azure CLI（`az login` 認証済み）または環境変数で Azure 認証がセットされていること
- 使用する Azure サブスクリプションが作成済みで、必要なリソースプロバイダ（`Microsoft.Cdn`, `Microsoft.Storage` 等）が登録されていること

## 使用方法（簡易）

1. `main` ディレクトリへ移動:

```bash
cd architectures/03/main
```

2. Terraform 初期化:

```bash
terraform init
```

3. 計画確認:

```bash
terraform plan
```

4. 適用:

```bash
terraform apply
```

## カスタマイズ

- `local.tf` の変数を変更してリソース名プレフィックス、Front Door の CDN 優先度 (`frontdoor_cdn_priority`)、重み (`frontdoor_cdn_weight`)、追加レイテンシ (`additional_latency_in_milliseconds`)、ヘルスプローブ間隔 (`health_probe_interval_in_seconds`)、応答タイムアウト (`response_timeout_seconds`) を調整できます。
- Storage Account モジュール内の HTML ファイル（`index.html` / `not_found.html`）を編集することで、配信コンテンツをカスタマイズできます。
- WAF ポリシーのレートリミット閾値（現在 200 req/min）やマネージドルールセットの構成を変更することで、セキュリティレベルを調整できます。

## 運用上の注意

- Front Door のエンドポイント名はグローバルで一意である必要があるため、ランダム文字列のサフィックスを付与しています。
- Storage Account 名も Azure 全体で一意である必要があるため、ランダム文字列で生成しています。
- WAF ポリシーの `name` にはハイフンが使用できないため、英数字のみで構成しています。
- Premium SKU を使用しているため、Standard SKU より高いコストが発生します。学習目的の場合はテスト後に速やかに `terraform destroy` でリソースを削除してください。
