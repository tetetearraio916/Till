# 1.複数画像アップロード機能を実装してみた
carrierwaveを使用して複数枚の画像をアップロードできるように実装してみた。

## carrierwaveとは？
carrierwaveとは、Railsアプリケーションから画像アップロード機能を簡単に実装できるライブラリ。今回は、carrierwave ver2.1.0を使用しました。

## どのように使用したか？
まずは、下のGemをインストールする。

instaclone/Gemfile

    gem 'carrierwave'
    gem 'mini_magick'

アップローダーを生成する。

    rails g upload image

これにより次のファイルが生成される。このファイル内でカスタマイズしたいときは処理を加える。

    app/upload/image_upload.rb

なので、自分は下のように設定を行いました。

instaclone/app/upload/image_upload.rb

    class ImageUploader < CarrierWave::Uploader::Base
    
        include CarrierWave::MiniMagick
    
        process resize_to_fill: [1000, 1000]
    
        version :thumb do
            process resize_to_fit: [223,223]
        end
    
        version :swiper do
            process resize_to_fit: [400, 400]
        end
        
        version :thumbnil do
            process resize_to_fit: [100, 100]
        end
        
        storage :file
        
        def store_dir
            "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
        end
        
         def extension_whitelist
            %w(jpg jpeg gif png)
         end
         
     end


どのように設定を加えていったかというと、、、

    include CarrierWave::MiniMagick


アップロード時に画像のリサイズを行いたかったので、minimagickをインストール。image_upload.rb生成時にコメントアウトで記載してあるので#を消して処理コードとして記載。minimagickとは、CプログラムであるimagemagickのRubyのインターフェース。これによって、画像リサイズ用のメソッドを使用することが出来る。


下の処理は、アップロードされるとと、1000×1000pxで切り抜きを行い、次にthumbと呼ばれるバージョンが作成され、223×223pxに拡大縮小される。同じように、swiper、thumbnilと呼ばれるバージョンが作成され、各々のバージョンに拡大縮小される。

    process resize_to_fill: [1000, 1000]
    
  
    version :thumb do
        process resize_to_fit: [223,223]
    end
        
    version :swiper do
        process resize_to_fit: [400, 400]
    end
        
    version :thumbnil do
        process resize_to_fit: [100, 100]
    end

これは、画像がアップロードした時に保存される場所である。デフォルト記載されている。「public/uploads/指定したモデル名/指定したモデルのカラム名/モデルID/画像と各バージョンで作成した画像」のように置かれている。変更した場合は、オーバライドして記載すれば良い。

    def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

これもデフォルトでコメントアウトで記載されているので処理出来るように記載。許可される拡張機能のホワイトリストを指定することが出来る。jpg、jpeg、gif、png以外の拡張子をアップロードするとレコードが無効になる。

    def extension_whitelist
        %w(jpg jpeg gif png)
    end

ここまでで設定の説明は終わりにして、次に親となるpostテーブルと子のimageテーブルを作成する。
postとimageでテーブルを分けたのは、複数投稿に対応する為。

|  posts  | 
| ---- | 
|  content  |  

|  images  | 
| ---- | 
|  url  |
| post_id |


    $rails g model Post content:text 

    $rails g model Image url:string post:reference


ここでつまずいたのが、自分の場合はimageモデル作成の際にjson型を扱ったことです。 もともと、postテーブル内でimageカラムを作成して複数投稿できる仕様にしようと思ったのですが、新しいimageテーブルを作成して保存するよう変更したため、わざわざjson型にしなくても良いということを後になって気づきました。なので、ここで一つのテーブルで複数画像を扱うならjson型にして、一つのオブジェクトレコードに複数画像を扱えるように設計するのもいいと思います。自分の場合は、別のテーブルを作成してjson型のままにしていますが、特に理由がないのならstring型で作成することをお勧めします。

マイグレーションファイルを作成して、データベースを更新する。

    $rails db:migrate

モデルファイルに以下の記述を加える。

instaclone/app/model/image.rb

    class Image < ApplicationRecord
        belongs_to :post
        mount_uploader :url, ImageUploader #アップロード機能を使いたいデータにマウントする。
    end


instaclone/app/mode/post.rb

    class Post < ApplicationRecord
        validates :content, presence: true, length: { maximum: 1000 }
        has_many :images, dependent: :destroy
        accepts_nested_attributes_for :images #postを投稿するとimageも同時に投稿できるようになる
    end


ここで注意しなければならないのは、accepts_nested_attributes_forを使うときは、ストロングパラメータにimages_attributesカラムを追記しなければならないこと。以下のようになります。


instacolone/app/controller/post_controller.rb

      def new
        @post = Post.new
        @post.images.build
      end
      
      def create
        @post = current_user.posts.new(post_params)
        if @post.save
          redirect_to posts_path, success: "投稿しました"
        else
          flash[:danger] = "投稿に失敗しました"
          render :new
        end
      end
      
      private
      
      def post_params
        params.require(:post).permit(:content, images_attributes: [:url])
      end

これで複数画像をパラメーターとして渡せるように設定できました。
続いて、viewで画像をどのように複数投稿できるようにするか考えていきます。
ここで、自分は色々ハマまりました。fields_forメソッドでは、第2引数にmultiple: trueを記述することで複数投稿できるとのことですが、うまくいかず、、、。なので別の方法として、javascriptで複数投稿できるように実装しました。この記事がとてもよく書かれていたので参考にさせていただきました。→[Qiita](https://qiita.com/gyu_outputs/items/bae2204f8a40ff1d2d37) この記事の通りに設定すれば、javascriptが起動して、アップロードするたびにプログラムが動いてくれるはずです。




# 2. swiperで1つの投稿に対して複数画像をスライドできるように実装してみた

## swiperとは？
ざっくりというと、スライド機能の実装が簡単にできるフレームワーク。


## どのように使用したか？
まずは、アプリケーション内でswiperを使えるように設定します。いくつか方法があるのですが、私はyarnを利用して導入しました。miketaさんのyarnでの導入方法や内容がとても分かりやすかったので参考にさせていただきました。→[Qiita](https://qiita.com/miketa_webprgr/items/0a3845aeb5da2ed75f82)

swiperをyarnで導入します。

    $yarn add swiper
 
    $yarn install


導入できたか確認するには、packege.json を確認してください。もしyarnを導入していないのであれば、下記のコマンドでyarnを導入してください。(macをお使いの場合)

    $brew installl yarn


導入したら、application.js、application.scssに下記のように記載します。

instaclone/app/assets/stylesheets/application.scss

    @import "swiper/swiper-bundle";


instaclone/app/assets/javascript/application.js

     //= require swiper/swiper-bundle.js
     //= swiper.js


swiper.jsファイルを作成し、下記のように記述してください。swiperでは、swiperで加えたい種類のスライド方法を自分で記述し作成する必要があります。swiperのデモから自分のお好みのスライド方法を選び、ソースコードから!-- Initialize Swiper --より下のスクリプト内のjsのコードをコピペしてください。スクリプトタグは記載する必要はありません。私の場合は、ページネーション/動的弾丸でのスライドにしたので下記のようになります。このjsファイル名はswiper.jsでなくても構いません。ファイル名を変更したい場合は、applicaion.js内で記載したファイル名も変更してください。[デモ](https://swiperjs.com/demos/)

instaclone/app/assets/javascript/swiper.js

    var swiper = new Swiper(".swiper-container", {
    pagination: {
        el: ".swiper-pagination",
        dynamicBullets: true,
        },
    });




これで準備は整ったので、viewで実際に実装してみます。
ページネーション/動的弾丸での実装例なので他のスライド方法を選んだ方は、ソースコードを確認してください。

instaclone/app/views/posts/index.html.slim

     .swiper-container.top-carousel
        .swiper-wrapper(style="transform: translate3d(0px, 0px, 0px)")
            - @image = Image.where(post_id: post.id)
            - @image.each do |img|
                .swiper-slide(style="width: 400px;")
                    = link_to post do
                    = image_tag img.url.swiper.url, class: "card-img-top"
         .swiper-pagination
         
    ~省略~
    
    = javascript_include_tag "application"  


ここで大事なのは、= javascript_include_tag "application"を一番最後に記述することです。これを書き忘れるとswiperが起動してくれません。application.html.slimに書くという方法もありますが、自分はswiperを必要とするページの部分だけに記述してます。また、このimg.url.swiper.urlは、carrierwaveで作成したswiperバージョンの画像を呼び出しています。

これで、自分の場合はswiperを実装することができました。

# 3.Fakerとは？

偽のデータを簡単に追加してくれるライブラリ。ドキュメントを読んだ方が早そうなので詳しい説明は割愛します。

instacolne/Gemfile

    gem 'faker'


Gemfileに記述してbundle.

    Faker::Name.unique.name


このように使うと、Fakerが偽の名前のデータを作成してくれる。名前だけじゃなく、いろいろなデータを作成してくれるので、ドキュメントのdefaultを参考にすると良い。[Faker](https://github.com/faker-ruby/faker)
uniqueをつけると一意のデータを作成してくれるが、作るデータが多すぎると一意にならずエラーが起きるので注意。
