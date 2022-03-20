.PHONY: assets
assets:
	npm install --prefix assets
	mix deps.get
	# npm install --force phoenix_live_view --prefix assets

.PHONY: dev
dev: 
	mix phx.server

.PHONY: i
i:
	iex -S mix phx.server