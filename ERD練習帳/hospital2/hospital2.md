# 病院の領収書編

## 反省点
- 患者エンティティと保険エンティティで分けてしまって間違えた。保険負担に関しては、政治によって変化する可能性があると思ったので分けた方が良いと思ったが違ったようです
- 請求エンティティに関する項目漏れ
- 請求内容に保険と自費項目を置いてしまった。おそらく請求内容に一律でないので、請求明細に置くべきだった。
- カテゴリ形のエンティティを毎回置き忘れるので気をつけようと思う
## 自分の解答

[![Image from Gyazo](https://i.gyazo.com/468b4ba53d6e655b443ea7574fd7237d.jpg)](https://gyazo.com/468b4ba53d6e655b443ea7574fd7237d)

## ERDレッスンの解答

[![Image from Gyazo](https://i.gyazo.com/2aef3f7b63706ef6a2e54aae79af3fce.jpg)](https://gyazo.com/2aef3f7b63706ef6a2e54aae79af3fce)
