# Haskell Real World HTTP

このリポジトリは、書籍「Real World HTTP」のGoサンプルコードをHaskellに移植したものです。

## セットアップ

### 1. GHCupのインストール

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

インストール後、以下のコマンドでパスを通します：

```bash
source ~/.ghcup/env
```

### 2. 依存関係のインストール

```bash
cabal update
cabal build all
```

## プロジェクト構成

各章のサンプルコードは個別のexecutableとして実装されています：

### 第2章

#### 2.1.1 テストエコーサーバーの実行

シンプルなHTTPエコーサーバー。リクエストの内容をコンソールに出力し、"hello"というHTMLを返します。

**ビルド：**
```bash
cabal build ch2-1-1-echo-server
```

**実行：**
```bash
cabal run ch2-1-1-echo-server
```

サーバーはポート18888で起動します。別のターミナルから以下のコマンドでテストできます：

```bash
curl http://localhost:18888/
```

**元のGoコード：**
```go
package main

import (
    "fmt"
    "log"
    "net/http"
    "net/http/httputil"
)

func handler(w http.ResponseWriter, r *http.Request) {
    dump, err := httputil.DumpRequest(r, true)
    if err != nil {
        http.Error(w, fmt.Sprint(err), http.StatusInternalServerError)
        return
    }
    fmt.Println(string(dump))
    fmt.Fprintf(w, "<html><body>hello</body></html>\\n")
}

func main() {
    var httpServer http.Server
    http.HandleFunc("/", handler)
    log.Println("start http listening :18888")
    httpServer.Addr = ":18888"
    log.Println(httpServer.ListenAndServe())
}
```

## 技術スタック

- **WAI (Web Application Interface)**: HaskellのWeb アプリケーション用標準インターフェース
- **Warp**: 高速なHTTPサーバー実装
- **http-types**: HTTPの型定義とユーティリティ

## ディレクトリ構造

```
.
├── app/
│   ├── Main.hs              # メインプログラム
│   └── Ch2/
│       └── EchoServer.hs    # 2.1.1 エコーサーバー
├── haskell-real-world-http.cabal
└── README.md
```

## ライセンス

BSD-3-Clause
