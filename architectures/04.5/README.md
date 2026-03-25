# Architecture 04.5 — Azure: Hub-Spoke Network with Private Endpoint for PostgreSQL

このディレクトリ（architectures/04.5）は、04（Hub-Spoke + Firewall）を拡張し、VM 上の DB を **Azure PaaS（PostgreSQL Flexible Server）+ Private Endpoint** に置き換えた学習用構成です。パブリックインターネットを経由せずに、VNet 内から Private Endpoint 経由で PaaS サービスにプライベート接続するエンタープライズ向けの設計パターンを学べます。

## 学習の目的

- **Private Endpoint**：PaaS サービスに対してプライベート IP を持つエンドポイントを作成し、VNet 内からプライベートにアクセスする方法。
- **Private DNS Zone**：`privatelink.postgres.database.azure.com` ゾーンを作成し、PaaS の FQDN をプライベート IP に名前解決する仕組み。
- **DNS Zone Group**：Private Endpoint 作成時に Private DNS Zone へ A レコードを自動登録する機能。
- **PaaS のパブリックアクセス無効化**：`public_network_access_enabled = false` により、Private Endpoint 経由のみでアクセスを強制する設計。
- ハブ&スポーク トポロジ：`Hub VNet` を中心に `Spoke VNet` を VNet Peering で接続するネットワーク設計（04 から継続）。
- Azure Firewall によるトラフィック制御：Spoke VM → Private Endpoint サブネットへの PostgreSQL（5432）通信を Firewall で制御。
- UDR（ユーザー定義ルート）：`Route Table` でデフォルトルート（0.0.0.0/0）を Firewall へ向け、すべてのアウトバウンドを Firewall 経由にする。
- Azure Bastion によるセキュアアクセス：パブリック IP を持たない VM に対して `Azure Bastion`（Standard SKU）経由で SSH 接続。
- Terraform モジュール化：再利用可能なモジュール（resource_group / network / bastion / vm / database / private_endpoint）による構成管理。

## 04 との差分

| 項目 | 04 | 04.5 |
|------|-----|------|
| DB 層 | Spoke2 VM 上の MySQL | PostgreSQL Flexible Server（PaaS） |
| DB 接続 | Spoke 間を Firewall 経由で直接通信 | Private Endpoint 経由でプライベート接続 |
| 名前解決 | 不要（Private IP 直指定） | Private DNS Zone で FQDN → PE の Private IP |
| Spoke 数 | 2（VM + DB） | 1（VM のみ。DB は PaaS 化） |
| Firewall ルール | spoke1 → spoke2:3306（MySQL） | spoke1-vm → spoke1-pe:5432（PostgreSQL） |

## 想定するアーキテクチャ要素

- **Resource Group**：すべてのリソースを束ねる論理的なコンテナ（Japan East）
- **Hub VNet**（10.0.0.0/16）：Azure Firewall と Azure Bastion を収容する中央ネットワーク
  - AzureFirewallSubnet（10.0.1.0/24）：Azure Firewall 専用サブネット
  - AzureBastionSubnet（10.0.2.0/24）：Azure Bastion 専用サブネット
- **Spoke1 VNet**（10.1.0.0/16）：VM と Private Endpoint を収容
  - test-spoke1-vm-subnet（10.1.1.0/24）：Linux VM（PostgreSQL クライアント）
  - test-spoke1-pe-subnet（10.1.2.0/24）：Private Endpoint（PostgreSQL 向け）
- **VNet Peering**：Hub ↔ Spoke1 の双方向ピアリング（転送トラフィック有効）
- **Azure Firewall**：Firewall Policy によるネットワークルール制御（Standard SKU）
- **Azure Bastion**：Standard SKU（コピー&ペースト、ファイルコピー、トンネリング対応）
- **Linux VM**：Ubuntu 22.04 LTS / Standard_B2ms、postgresql-client インストール済み
- **PostgreSQL Flexible Server**：パブリックアクセス無効、Private Endpoint 経由のみ
- **Private Endpoint**：spoke1-pe-subnet に配置、PostgreSQL への `private_service_connection`
- **Private DNS Zone**：`privatelink.postgres.database.azure.com`、Spoke1 VNet にリンク
- **Route Table**：Spoke1 VM サブネットに関連付け、デフォルトルートを Firewall へ転送
- **NSG**：Spoke1 VM サブネット用（Bastion からの SSH のみ許可）

## 接続フロー

1. ユーザー → HTTPS（443） → `Azure Bastion`（Public IP）
2. `Azure Bastion` → SSH（22） → VNet Peering 経由 → `Spoke1 VM`
3. `Spoke1 VM` → Route Table → `Azure Firewall` → PostgreSQL（5432） → `Private Endpoint`（10.1.2.4） → `PostgreSQL Flexible Server`
4. `Spoke1 VM` → Route Table → `Azure Firewall` → HTTP/HTTPS（80, 443） → インターネット
5. 上記以外のアウトバウンド → Firewall でドロップ

## 名前解決フロー

```
Spoke1 VM が nslookup を実行
  → test-psqlflexibleser-xxx.postgres.database.azure.com
  → CNAME: test-psqlflexibleser-xxx.privatelink.postgres.database.azure.com
  → Private DNS Zone の A レコード参照
  → 10.1.2.4（Private Endpoint の Private IP）
```

## ディレクトリ構成

```
architectures/04.5/
├── architecture.svg        # アーキテクチャ図
├── README.md               # このファイル
├── main/                   # メインの Terraform 構成
│   ├── main.tf             # モジュールの呼び出し
│   ├── local.tf            # ローカル変数（プレフィックス、VM サイズ、DB SKU 等）
│   ├── outputs.tf          # 出力値の定義（VM/DB の認証情報、PE の IP）
│   └── provider.tf         # Azure プロバイダ設定（azurerm ~> 4.58.0）
└── modules/                # 再利用可能なモジュール
    ├── resource_group/     # リソースグループ
    ├── network/            # VNet、Subnet、VNet Peering、Azure Firewall、Firewall Policy、Route Table、Private DNS Zone
    ├── bastion/            # Azure Bastion、Bastion NSG、Public IP
    ├── vm/                 # Linux VM、NIC、NSG、カスタムデータ（postgresql-client）
    ├── database/           # PostgreSQL Flexible Server、DB
    └── private_endpoint/   # Private Endpoint、Private Service Connection、DNS Zone Group
```

## 前提

- mise で必要なツールがインストールされていること
- Azure CLI（`az login` 認証済み）または環境変数で Azure 認証がセットされていること
- 使用する Azure サブスクリプションが作成済みで、必要なリソースプロバイダ（`Microsoft.Network`, `Microsoft.Compute`, `Microsoft.DBforPostgreSQL` 等）が登録されていること

## 使用方法（簡易）

1. `main` ディレクトリへ移動:

```bash
cd architectures/04.5/main
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

5. Bastion 経由で VM に接続し、Private Endpoint 経由で PostgreSQL に接続:

```bash
# Spoke1 VM に SSH 接続
az network bastion ssh \
  --name test-bastion \
  --resource-group test-learning-rg \
  --target-resource-id <spoke1-vm-resource-id> \
  --auth-type password \
  --username azureuser

# VM 内で DNS 名前解決を確認（PE の Private IP が返ること）
nslookup $(terraform output -raw postgresql_fqdn)

# VM 内から PostgreSQL に接続
psql -h $(terraform output -raw postgresql_fqdn) -U pgadmin -d testdb
```

6. パスワードの確認:

```bash
# VM のパスワード
terraform output -raw spoke1_admin_password

# PostgreSQL のパスワード
terraform output -raw postgresql_admin_password
```

## カスタマイズ

- `local.tf` の変数を変更してリソース名プレフィックス（`prefix`）、VM サイズ（`vm_size`）、ストレージタイプ（`vm_storage_account_type`）、Bastion SKU（`bastion_sku`）、DB SKU（`db_sku_name`）を調整できます。
- Firewall Policy のネットワークルール（`network/main.tf`）を編集することで、許可する通信ポートや宛先を追加・変更できます。
- NSG ルールを編集することで、サブネットレベルのアクセス制御を調整できます。
- `database/variables.tf` で PostgreSQL のバージョン、ストレージサイズ、バックアップ保持期間を変更できます。

## 運用上の注意

- Azure Firewall は時間課金が発生するため、学習目的の場合はテスト後に速やかに `terraform destroy` でリソースを削除してください。
- Azure Bastion（Standard SKU）も時間課金が発生します。
- PostgreSQL Flexible Server も起動中は課金が発生します。学習用には最小 SKU（`B_Standard_B1ms`）を使用しています。
- VM と PostgreSQL のパスワードは `random_password` リソースで自動生成されます。`terraform output` で確認できます。
- `bgp_route_propagation_enabled = false` により、BGP ルートによる UDR の上書きを防止しています。

## 発展課題

- **DNS の Hub 集約**：Private DNS Zone の VNet Link を Hub VNet に変更し、Azure DNS Private Resolver を Hub に配置して DNS を一元管理するパターン。Spoke が複数に増えた場合のスケーラブルな設計。
- **複数 PaaS への PE 接続**：Storage Account や Key Vault にも Private Endpoint を追加し、同じパターンの横展開を学ぶ。
