# API設計書

## 概要
- ユーザーのマイクロポストを30件返すAPI

## メソッド
- GET

## URI
- /api/v1/microposts/

## パラメータ
| パラメータ名 | 型 | 内容 |
| ----| ---- | ---- |
| user_id | string | 数字 |

## レスポンス
### 成功時
#### ステータスコード
- 200

#### レスポンスサンプル
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

### 失敗時(存在しないユーザーIDが送信された場合)
#### ステータスコード
- 404

#### レスポンスサンプル
```
{
  "error": {
    "code": 404
    "message": "not found"
  }
}
```