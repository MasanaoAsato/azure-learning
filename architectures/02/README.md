# Architecture 02 — Azure: Container Apps & Azure Container Registry

このディレクトリ（architectures/02）は、Azure 上でのサーバーレスコンテナ実行環境（Azure Container Apps）とマネージドコンテナレジストリ（Azure Container Registry）を組み合わせた基本的なアーキテクチャを学習するための Terraform 構成を含んでいます。セキュアなイメージのプル、認証・権限設計、スケーリングなどの実践的パターンを学べます。

## 学習の目的

- サーバーレスアプリケーションのデプロイ：`Azure Container Apps` によるコンテナ化アプリのデプロイとスケーリング挙動（KEDAを利用したゼロスケーリング等）を理解する。
- プライベートレジストリ連携：`Azure Container Registry (ACR)` を Container Apps から安全に参照・イメージプルする方法。
- 認証・権限設計（Managed Identity）：Container Apps に割り当てるマネージド ID と ACR に対する権限（AcrPull）の付与。
- リソースグループによる一元管理：関連リソースを単一の `Resource Group` にまとめる構成。
- Terraform モジュール化：再利用可能なモジュール（resource_group / container_registry / container_apps）の使い方。

## 想定するアーキテクチャ要素

- Resource Group：すべてのリソースを束ねる論理的なコンテナ
- Azure Container Registry (ACR)：コンテナイメージを格納・管理するプライベートレジストリ
- Azure Container Apps (ACA)：サーバーレスなコンテナ実行環境。背後で Container Apps Environment を使用
- Managed Identity：ACA が ACR からイメージをプルするためなどの Azure リソース間認証（AcrPull ロール）

## 接続フロー（例）

1. ユーザー（開発環境/CI） → HTTPS → `Azure Container Registry` にコンテナイメージを Push
2. クライアント（外部） → HTTPS → `Azure Container Apps`（Ingress: external）
3. `Azure Container Apps`（割り当てられた Managed Identity） → `Azure Container Registry` から安全にイメージを Pull してコンテナを起動

## ディレクトリ構成（想定）

```
architectures/02/
├── main/                 # メインの Terraform 構成
│   ├── main.tf           # モジュールの呼び出し
│   ├── local.tf          # ローカル変数/プレフィックス等
│   ├── outputs.tf        # 出力値の定義
│   └── provider.tf       # Azure プロバイダ設定
└── modules/              # 再利用可能なモジュール
    ├── resource_group/   # リソースグループ
    ├── container_registry/# Azure Container Registry 定義
    └── container_apps/   # Container Apps Environment, Container App, Managed Identity 設定
```

## 前提

- Terraform >= 1.0
- Azure CLI（`az login` 認証済み）または環境変数で Azure 認証がセットされていること
- 使用する Azure サブスクリプションが作成済みで、必要なリソースプロバイダ（`Microsoft.App`, `Microsoft.ContainerRegistry` 等）が登録されていること

## 使用方法（簡易）

1. `main` ディレクトリへ移動:

```bash
cd architectures/02/main
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

- `local.tf` の変数を変更してリソース名プレフィックス、Location、Container Apps の CPU/メモリ (`capps_cpu`/`capps_memory`)、最小/最大レプリカ数 (`capps_min_replicas`/`capps_max_replicas`)、同時接続数（`capps_scale_concurrent_requests`）などを調整できます。
- Container Apps の Ingress 設定を internal に変更することで、VNet 内からのみアクセス可能な閉域構成への拡張も可能です。

## 運用上の注意

- Container Apps で利用するコンテナイメージは、事前に手動または別パイプラインで Container Registry に Push しておく必要があります（あるいは Terraform 適用時に一時的なサンプルイメージを利用します）。
- ACA から ACR へのプル権限には、セキュリティのベストプラクティスとして Admin User 資格情報（パスワード）ではなく、マネージド ID (Managed Identity) を推奨します。
- テスト後は不要な課金を避けるために `terraform destroy` でリソースを削除してください。
