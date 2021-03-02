# メタタグの実装
メタタグを実装していきます。

## メタタグとは？
メタタグとは、記事などのコンテンツ情報を検索エンジンやブラウザに伝えるための情報。メタタグを設定することで、SEO対策として検索結果をより上位に表示させたり、リンクがシェアされた場合などは、URLだけでなくサイト名やそのサイトのイメージ画像などのコンテンツ情報(OGP)も表示させることもできる。

## SEOとは？
フル名称は、search engine optimization(検索エンジン最適化)。WEBサイトの成果を向上させる施策のこと。つまり、より多くの人に自分のサイトを見てもらえるように、検索エンジンに引っかかるような検索キーワードを選定したり、サイト内のページ構造、サイト外でリンクを貼ってもらうなどして検索結果の上位に表示させるなどの最適化をしていく。

## OGP(Open Graph Protcol)とは？
FacebookやTwitterなどのSNSでシェアした際に、設定したWEBページのタイトルやイメージ画像、詳細などを正しく伝えるためのHTML要素.。

### 最近のメタタグとSEO効果について
現在はGoogleなどのAI搭載により、メタタグでキーワードを設定してもSEOキーワードを読み込まず上位表示に関わる要素ではなくなってしまったらしい。

## meta-tagsの導入
今回は、meta-tagsというgemを導入。railsでメタタグをを簡単に設定できるライブラリ。


Gemfile
```Gemfile
    gem 'meta-tags'
```

```
bundle install
```

## メタタグの詳細を決める
下記のようにapplication_helperに記述します。管理を楽にするため、settings.ymlで設定した定数を利用する形にします。

app/helpers/application_helper.rb
```ruby
module ApplicationHelper
  def default_meta_tags
    {
      site: Settings.meta.site,
      # trueに設定すると「title | site」の並びで出力
      reverse: true,
      title: Settings.meta.title,
      description: Settings.meta.description,
      keywords: Settings.meta.keywords,
      # URLを正規化するcanonicalタグを設定
      canonical: request.original_url,
      # OGPの設定
      og: {
        title: :full_title,
        # ウェブサイト、記事、ブログサイトの種類
        type: Settings.meta.og.type,
        url: request.original_url,
        image: image_url(Settings.meta.og.image_path),
        site_name: :site,
        description: :description,
        # リソース言語を設定
        locale: 'ja_JP'
      },
      twitter: {
        # twitterOGPのSummaryカード
        card: 'summary_large_image'
      }
    }
  end
end
```

config/settings.yml
```yml
meta:
  site: InstaClone
  title: InstaClone - Railsの実践的アプリケーション
  description: Ruby on Railsの実践的な課題です。Sidekiqを使った非同期処理やトランザクションを利用した課金処理など実践的な内容が学べます。
  keywords:
    - Rails
    - InstaClone
    - Rails特訓コース
  og:
    type: website
    image_path: /images/default.png
```    

## メタタグを設定する

下記のように設定することでどのページにもメタタグが反映される。

app/views/layouts/application.html.slim
```slim
doctype html
html
  head
    = display_meta_tags(default_meta_tags)
    = csrf_meta_tags
    = csp_meta_tag
    = stylesheet_link_tag 'application', media: 'all'
    = javascript_include_tag 'application'
```

### headとbodyの違いとは？
head・・・ファイルのタイトル、文書の種類、言語、キーワード、スタイルシートなどのコンピュータに知らせるためのメタ情報を記載する場所

body・・・文書の本文を記載する場所。


## ページ毎にメタタグを設定する

違うメタタグをページ毎に設定したい場合は、ファイルの一番最初に下記のように記述する。そうすることで、デフォルトで設定したメタタグを上書きする。

app/views/users/index.html.slim
```slim
- set_meta_tags title: "ユーザー一覧ページ"
```

app/views/users/show.html.slim
```slim
- set_meta_tags title: "ユーザー詳細ページ"
```

app/views/posts/show.html.slim

```slim
- set_meta_tags title: '投稿詳細ページ', description: @post.content,
        og: { image: "#{@post.images.first.url}"}
```

### これで下記のようにに反映されれば完成です！
デプロイしたら、google検索用のsitemap_generatorも使ってみたい

トップページ
[![Image from Gyazo](https://i.gyazo.com/ec79bbea64ae62bbda250e6ed78c8105.png)](https://gyazo.com/ec79bbea64ae62bbda250e6ed78c8105)

ユーザー一覧
[![Image from Gyazo](https://i.gyazo.com/7ba649060bd1f5eb555502b262e193a8.png)](https://gyazo.com/7ba649060bd1f5eb555502b262e193a8)

投稿詳細
[![Image from Gyazo](https://i.gyazo.com/13c03b24d8f11b67bf19b9451d6bfae7.png)](https://gyazo.com/13c03b24d8f11b67bf19b9451d6bfae7)

ユーザー詳細
[![Image from Gyazo](https://i.gyazo.com/723a1c469df211b75e3ea76fb567ca93.png)](https://gyazo.com/723a1c469df211b75e3ea76fb567ca93)

OGP
[![Image from Gyazo](https://i.gyazo.com/fa50a328118f3b49b6461bc285266e30.png)](https://gyazo.com/fa50a328118f3b49b6461bc285266e30)


## 参照記事
- [meta-tags ドキュメント](https://github.com/kpumuk/meta-tags)
- [metaタグ（メタタグ）とは？SEO効果のある記述箇所とポイントを紹介](https://ferret-plus.com/13074)
- [OGPを設定しよう！SNSでシェアされやすい設定方法とは？](https://digitalidentity.co.jp/blog/seo/ogp-share-setting.html)
- [Railsアプリでmetaタグ＆OGP設定をする方法](https://creat4869.hatenablog.com/entry/2019/08/15/170109)
- [Qiita Rails 定数を管理するsettings.yml・環境ごとの定数管理の方法](https://qiita.com/clbcl226/items/c068f617aa34d552a50a)
- [TechRacho RailsのCSRF保護を詳しく調べてみた（翻訳）
  ](https://techracho.bpsinc.jp/hachi8833/2017_10_23/46891) 
