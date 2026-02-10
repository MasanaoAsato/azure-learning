# Azure Learning Architecture 01

このディレクトリ（Architecture 01）は、Azureにおける**セキュアなデータベース運用**と**踏み台サーバー（Bastion + Jumpbox）を経由した管理アクセス**の基本パターンを学習するためのTerraformコードです。

## 学習の目的

このアーキテクチャを通じて、以下のAzureおよびTerraformの概念を学ぶことができます：

1.  **セキュアなネットワーク設計 (Hub & Spoke / Segmentation)**
    - パブリックIPを持たない仮想マシン（Jumpbox）とデータベースの構築。
    - Network Security Group (NSG) によるトラフィック制御。

2.  **Azure Bastion の活用**
    - ポート（3389/22）をインターネットに公開せず、Azure Portal経由で安全にVMへアクセスする方法。

3.  **データベースの VNet 統合 (VNet Integration)**
    - Azure Database for PostgreSQL Flexible Server を VNet 内のサブネットに配置し、インターネットからの直接アクセスを遮断する構成。

4.  **名前解決 (Private DNS Zone)**
    - プライベートIPアドレスを持つPaaSリソースに対して、FQDNで接続するための Private DNS Zone の設定とVNetリンク。


## 🏗️ アーキテクチャ構成

### リソース概要

| カテゴリ | リソース名 | 説明 |
| :--- | :--- | :--- |
| **Network** | **Virtual Network (VNet)** | 全リソースを収容する仮想ネットワーク。 |
| | `AzureBastionSubnet` | Azure Bastion 専用のサブネット。 |
| | `JumpboxSubnet` | 管理用VM（Jumpbox）配置用サブネット。 |
| | `DatabaseSubnet` | PostgreSQL配置用（Delegated Subnet）。 |
| **Access** | **Azure Bastion** | ブラウザ経由でRDP/SSH接続を提供するマネージド踏み台サービス。 |
| **Compute** | **Jumpbox VM** | 管理用仮想マシン（Windows/Linux）。ここからデータベースへ接続して操作を行います。 |
| **Database** | **Azure Database for PostgreSQL** | フレキシブルサーバー。VNet統合により閉域網内からのみアクセス可能。 |
| **DNS** | **Private DNS Zone** | `*.postgres.database.azure.com` の名前解決をVNet内で実現。 |

### 接続フロー

1.  **管理者PC** -> (HTTPS/443) -> **Azure Portal (Azure Bastion)**
2.  **Azure Bastion** -> (RDP/SSH) -> **Jumpbox VM** (Private IP)
3.  **Jumpbox VM** -> (PostgreSQL Protocol/5432) -> **PostgreSQL Flexible Server**

※ JumpboxにはパブリックIPが付与されておらず、外部から直接攻撃を受けるリスクを最小限に抑えています。

## 📁 ディレクトリ構成

- `main/`: ルートモジュール。各子モジュールを呼び出して全体の構成を定義。
- `modules/`:
    - `network`: VNet, Subnet, Private DNS Zoneの定義。
    - `bastion`: Azure BastionホストとPublic IPの定義。
    - `jumpbox`: VM, Network Interface, NSGの定義。
    - `database`: PostgreSQL Flexible Server, Random Passwordの定義。

---

