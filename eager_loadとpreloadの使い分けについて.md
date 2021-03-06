## :door: preloadとeager_loadの使い分けについて

### :white_check_mark: 前提条件:全てのレコードを取得するような場合
- 条件を指定する(whereなどを使う)ような場合は、eager_loadを使う。(テーブル結合していなければ、そもそも関連先の情報がわからないためpreloadは使えない)
- 条件を指定しない場合は、preload、each_loadの使い分けはケースバイケース。所得したいデータのカラムが少ないならeach_loadを使って一つのクエリで済ませるべきだし、多いならpreload使った方がいいかも。基本的には、レスポンスタイムはpreload使った方が早い。

さらにこの記事の方の考え方を前提条件に追加していって考えていきますね。

### :white_check_mark: 前提条件:全てのレコードを取得する+関連先のデータが1対1であるような場合
- 1対1であるかつ条件を指定しない場合、eager_loadを使うことで結合してからまとめて取得する方が効率が良い場合が多い。
(1対1になるようなデータを持ってくる場合は、抽象的ですが関連度がかなり強いので結合していった方が効率が多い場合が多いという解釈。company_userとcompany_user_profile的な！)
- 1対1であるかつ条件を指定する(whereなどを使う)ような場合は当然eager_loadが当てはまる。

### :white_check_mark: 前提条件:全てのレコードを取得する+関連先のデータが1対多であるような場合
- 1対多であるかつ条件を指定しない場合、includesの挙動通りpreloadを使う
- 1対多であるかつ条件を指定する(whereなどを使う)ような場合、結合しなければいけないのでeager_loadを使うしかない


## :door: 注意点
- ここまでの考えであっているのなら、一対一のときはeager_loadを使う場合が良いのかもしれないが結合してもデータが重複するような場合がある。その時は、preloadを使うのも検討。なぜなら、eager_loadにはdistinctが備わっていないために指定したデータ数以上のデータを取ってきてしまう可能性があるため。(んーでもその前にdistinctメソッド使えばよくない？:ぐる目顔:笑)
- preloadを使う時に、最初のクエリのデータ取得量が多すぎるとin句内の膨大なデータに対してSQL自体の設定値やメモリサイズの設定値を考慮しなければいけない
- includesはeager_loadとpreloadを判断するのに時間がかかる、また状況を考えたクエリでのデータ取得操作が悪いのであまり使うべきでない。

参考文献
- [ActiveRecordのincludes, preload, eager_load の個人的な使い分け](https://moneyforward.com/engineers_blog/2019/04/02/activerecord-includes-preload-eagerload/)
- [Rails: JOINすべきかどうか、それが問題だ — #includesの振舞いを理解する（翻訳）](https://techracho.bpsinc.jp/hachi8833/2017_09_25/45650)
- [なぜ、SQLは重たくなるのか？──『SQLパフォーマンス詳解』の翻訳者が教える原因と対策](https://eh-career.com/engineerhub/entry/2017/06/26/110000#%E5%8E%9F%E5%9B%A0ORM%E3%81%8C%E7%94%9F%E6%88%90%E3%81%99%E3%82%8BSQL%E3%82%92%E7%A2%BA%E8%AA%8D%E3%81%97%E3%81%A6%E3%81%84%E3%81%AA%E3%81%84)

