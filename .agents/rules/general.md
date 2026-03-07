---
trigger: always_on
---

# このリポジトリについて
azureのアーキテクチャをterraformで記述したものです。
勉強のためのリポジトリです。

# 構成
01,02,03...といった感じでアーキテクチャごとにディレクトリを切っています。
modulesディレクトリには、アーキテクチャで使用するモジュールを配置しています。
main/main.tfでモジュールを呼び出して、アーキテクチャを構築しています。

architectures
  -- 01
    -- main
      -- main.tf
      -- local.tf
      -- providers.tf
    modules
      --network
        -- main.tf
        -- variables.tf
        -- outputs.tf
