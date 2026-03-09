# Architecture 04 — Azure: Hub-Spoke Network with Azure Firewall & Bastion

このディレクトリ（architectures/04）は、Azure のハブ&スポーク ネットワークトポロジを Terraform で構築する学習用構成です。Hub VNet に Azure Firewall と Azure Bastion を配置し、Spoke VNet 上の VM（Web 層・DB 層）間のトラフィックを Firewall 経由で制御する、エンタープライズ向けのセキュアなネットワーク設計パターンを学べます。

## 学習の目的

- ハブ&スポーク トポロジ：`Hub VNet` を中心に複数の `Spoke VNet` を VNet Peering で接続するネットワーク設計を理解する。
- Azure Firewall によるトラフィック制御：Spoke 間通信やインターネットへのアウトバウンドを `Azure Firewall`（Standard SKU）で一元的にフィルタリングする方法。
- UDR（ユーザー定義ルート）：`Route Table` でデフォルトルート（0.0.0.0/0）を Firewall へ向けることで、すべてのアウトバウンドトラフィックを強制的に Firewall 経由にする仕組み。
- Azure Bastion によるセキュアアクセス：パブリック IP を持たない VM に対して、`Azure Bastion`（Standard SKU）経由で SSH/RDP 接続する方法。
- NSG によるマイクロセグメンテーション：各 VM サブネットに `Network Security Group` を適用し、必要な通信のみを許可するセキュリティ設計。
- 多層アーキテクチャ：Web/App 層（Spoke1）と Database 層（Spoke2）を分離し、Firewall ルールで MySQL（3306）通信のみ許可するパターン。
- Terraform モジュール化：再利用可能なモジュール（resource_group / network / bastion / vm）による構成管理。

## 想定するアーキテクチャ要素

- **Resource Group**：すべてのリソースを束ねる論理的なコンテナ（Japan East）
- **Hub VNet**（10.0.0.0/16）：Azure Firewall と Azure Bastion を収容する中央ネットワーク
  - AzureFirewallSubnet（10.0.1.0/24）：Azure Firewall 専用サブネット
  - AzureBastionSubnet（10.0.2.0/24）：Azure Bastion 専用サブネット
- **Spoke1 VNet**（10.1.0.0/16）：Web/App 層の VM を収容
  - test-spoke1-vm-subnet（10.1.1.0/24）
- **Spoke2 VNet**（10.2.0.0/16）：Database 層の VM を収容
  - test-spoke2-vm-subnet（10.2.1.0/24）
- **VNet Peering**：Hub ↔ Spoke1、Hub ↔ Spoke2 の双方向ピアリング（転送トラフィック有効）
- **Azure Firewall**：Firewall Policy によるネットワークルール制御（Standard SKU）
- **Azure Bastion**：Standard SKU（コピー&ペースト、ファイルコピー、トンネリング対応）
- **Linux VM × 2**：Ubuntu 22.04 LTS / Standard_B2ms
  - Spoke1 VM：mysql-client インストール済み
  - Spoke2 VM：MySQL Server インストール・構成済み（appdb / appuser）
- **Route Table**：各 Spoke サブネットに関連付け、デフォルトルートを Firewall へ転送
- **NSG**：Bastion サブネット用、各 Spoke VM 用に個別設定

## 接続フロー

1. ユーザー → HTTPS（443） → `Azure Bastion`（Public IP）
2. `Azure Bastion` → SSH（22） → VNet Peering 経由 → `Spoke1 VM` / `Spoke2 VM`
3. `Spoke1 VM` → Route Table → `Azure Firewall` → MySQL（3306） → `Spoke2 VM`
4. `Spoke VM` → Route Table → `Azure Firewall` → HTTP/HTTPS（80, 443） → インターネット
5. 上記以外のアウトバウンド → Firewall でドロップ

## ディレクトリ構成

```
architectures/04/
├── architecture.drawio     # アーキテクチャ図（draw.io）
├── README.md               # このファイル
├── main/                   # メインの Terraform 構成
│   ├── main.tf             # モジュールの呼び出し
│   ├── local.tf            # ローカル変数（プレフィックス、VM サイズ等）
│   ├── outputs.tf          # 出力値の定義（VM の Private IP、DB 認証情報）
│   └── provider.tf         # Azure プロバイダ設定（azurerm ~> 4.58.0）
└── modules/                # 再利用可能なモジュール
    ├── resource_group/     # リソースグループ
    ├── network/            # VNet、Subnet、VNet Peering、Azure Firewall、Firewall Policy、Route Table、NSG
    ├── bastion/            # Azure Bastion、Bastion NSG、Public IP
    └── vm/                 # Linux VM × 2、NIC、カスタムデータ（MySQL セットアップ）
```

## 前提

- mise で必要なツールがインストールされていること
- Azure CLI（`az login` 認証済み）または環境変数で Azure 認証がセットされていること
- 使用する Azure サブスクリプションが作成済みで、必要なリソースプロバイダ（`Microsoft.Network`, `Microsoft.Compute` 等）が登録されていること

## 使用方法（簡易）

1. `main` ディレクトリへ移動:

```bash
cd architectures/04/main
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

5. Bastion 経由で VM に接続（Azure Portal または Azure CLI）:

```bash
# Spoke1 VM に SSH 接続
az network bastion ssh \
  --name test-bastion \
  --resource-group test-learning-rg \
  --target-resource-id <spoke1-vm-resource-id> \
  --auth-type password \
  --username azureuser

# Spoke1 VM から Spoke2 VM の MySQL に接続
mysql -h <spoke2-private-ip> -u appuser -p appdb
```

## カスタマイズ

- `local.tf` の変数を変更してリソース名プレフィックス（`prefix`）、VM サイズ（`vm_size`）、ストレージタイプ（`vm_storage_account_type`）、Bastion SKU（`bastion_sku`）、管理者ユーザー名（`admin_username`）を調整できます。
- Firewall Policy のネットワークルール（`network/main.tf`）を編集することで、許可する通信ポートや宛先を追加・変更できます。
- NSG ルールを編集することで、サブネットレベルのアクセス制御を調整できます。

## 運用上の注意

- Azure Firewall は時間課金が発生するため、学習目的の場合はテスト後に速やかに `terraform destroy` でリソースを削除してください。
- Azure Bastion（Standard SKU）も時間課金が発生します。
- VM のパスワードは `random_password` リソースで自動生成されます。`terraform output -raw db_app_password` で MySQL アプリユーザーのパスワードを確認できます。
- Spoke 間の通信は直接ピアリングされていないため、必ず Hub VNet の Firewall を経由します。Firewall ルールで許可されていない通信はドロップされます。
- `bgp_route_propagation_enabled = false` により、BGP ルートによる UDR の上書きを防止しています。
