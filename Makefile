.PHONY: init up ps migrate

init: # clone後の環境構築(初回のみ)
	docker compose build
	docker compose up -d --build
	docker compose exec web rails db:create
	@make stop

up: # サーバー起動
	docker compose up
stop: # サーバー停止
	docker compose stop
ps: # コンテナの起動状態の確認
	docker compose ps
migrate: # DBのマイグレートを実行
	docker compose exec web rails db:migrate