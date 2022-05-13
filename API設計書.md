# API設計書

## 概要
- ユーザーのマイクロポストを返すAPI
  - ユーザーIDを指定して、ユーザーがDBに存在すればそのユーザーのマイクロポストを返す
    - パラメータとして表示ページ、表示するマイクロポストの数を指定できる
      - 指定しなければ表示ページには1、マイクロポスト数には30が入る
  - マイクロポストは降順で表示される
    - マイクロポストが投稿されていない、もしくは指定したページに表示するマイクロポストがなければ空のjson([])を返す
  - ユーザーが存在しなければエラーを返す

## メソッド
- GET

## URI
- /api/v1/users/{user_id}/microposts{page}{per_page}

## パラメータ
| パラメータ名 | 型 | 内容 |
| ----| ---- | ---- |
| user_id | Integer | ユーザーIDを数字で指定 |
| page | Integer | 表示したいページ数を数字で指定<br>デフォルトは1 |
| per_page | Integer | 表示したいマイクロポストの数を数字で指定<br>デフォルトは30<br>表示したページのマイクロポストが指定した数より少なければある分だけを表示

## レスポンス
### 成功時
#### ステータスコード
- 200

#### レスポンスサンプル
- 表示するマイクロポストが存在する場合
```
{
	"microposts": [
		{
			"id": 295,
			"content": "Possimus facilis repellat odit dolore.",
			"user_id": 1,
			"created_at": "2022-04-18T07:54:54.387Z",
			"updated_at": "2022-04-18T07:54:54.387Z"
		},
		{
			"id": 289,
			"content": "Ut voluptatem sed expedita nam.",
			"user_id": 1,
			"created_at": "2022-04-18T07:54:54.362Z",
			"updated_at": "2022-04-18T07:54:54.362Z"
		},
		{
			"id": 283,
			"content": "Sequi et voluptas quod beatae.",
			"user_id": 1,
			"created_at": "2022-04-18T07:54:54.338Z",
			"updated_at": "2022-04-18T07:54:54.338Z"
		},
  ~~~~ # 省略
		{
			"id": 121,
			"content": "Cumque possimus ipsa quaerat non.",
			"user_id": 1,
			"created_at": "2022-04-18T07:54:53.645Z",
			"updated_at": "2022-04-18T07:54:53.645Z"
		}
	]
}
```

- 表示するマイクロポストが存在しない場合
```
{
  "microposts": []
}
```

### 失敗時
#### ステータスコード
- 404

#### レスポンスサンプル
```
{
  "error": {
    "status": 404,
    "message": "not found"
  }
}
```