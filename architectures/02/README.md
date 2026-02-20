# Architecture 02: Azure Container Apps & Azure Container Registry

このディレクトリは、Terraformを使用してAzure上にContainer Apps環境とContainer Registry (ACR) を構築するための構成を含んでいます。
学習目的で作成されており、ACRの地理的レプリケーションなどの機能が含まれています。

## 概要

このアーキテクチャは以下のリソースをデプロイします：

1.  **Resource Group**
    *   リージョン: Japan East
    *   名前: `test-learning-rg`

2.  **Azure Container Registry (ACR)**
    *   SKU: Premium
    *   管理ユーザー: 無効
    *   パブリックアクセス: 有効
    *   地理的レプリケーション (Geo-replication): Japan West (ゾーン冗長なし)

3.  **Azure Container Apps**
    *   **Environment**: `test-acaenv` (Japan East)
    *   **Container App**: `test-capp`
        *   標準的なContainer Appです。
        *   イメージ: `mcr.microsoft.com/azuredocs/aci-helloworld:latest`
        *   Ingress: 外部公開 (HTTP/80)
        *   スケーリングルール:
            *   最小レプリカ数: 0
            *   最大レプリカ数: 3
            *   スケールトリガー: HTTP同時リクエスト数 (10)
        *   リソース割り当て: 0.5 vCPU / 0.5Gi メモリ

## 前提条件

*   Terraform (>= 1.0)
*   Azure CLI
*   有効なAzureサブスクリプション

## ディレクトリ構成

```
architectures/02/
├── main/               # メインのTerraform構成ファイル
│   ├── main.tf         # モジュールの呼び出し
│   ├── local.tf        # ローカル変数の定義
│   ├── provider.tf     # Azureプロバイダーの設定
│   └── ...
└── modules/            # 再利用可能なモジュール
    ├── container_apps     # Container Apps用モジュール
    ├── container_registry # ACR用モジュール
    └── resource_group     # リソースグループ用モジュール
```

## 使用方法

1.  `main` ディレクトリに移動します。
    ```bash
    cd main
    ```

2.  Terraformを初期化します。
    ```bash
    terraform init
    ```

3.  計画を確認します。
    ```bash
    terraform plan
    ```

4.  リソースをデプロイします。
    ```bash
    terraform apply
    ```

## カスタマイズ

`main/local.tf` ファイルで以下の変数を調整することで、デプロイ内容を変更できます：

*   `prefix`: リソース名のプレフィックス (デフォルト: `test`)
*   `capps_cpu`: Container AppのCPUコア数
*   `capps_memory`: Container Appのメモリ量
*   `capps_min_replicas`: 最小レプリカ数
*   `capps_max_replicas`: 最大レプリカ数
*   `capps_scale_concurrent_requests`: オートスケールのトリガーとなる同時リクエスト数

## 注意事項

*   ACRはPremium SKUを使用しており、地理的レプリケーションが有効になっています。これによりコストが発生する可能性がありますので、試用後は適切にリソースを削除してください (`terraform destroy`)。
