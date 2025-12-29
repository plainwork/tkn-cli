.PHONY: changelog version test

V ?=

changelog:
	@if [ -z "$(V)" ]; then \
		echo "V is required (e.g., make version V=0.0.2)"; \
		exit 1; \
	fi
	@last_tag=$$(git describe --tags --abbrev=0 2>/dev/null || true); \
	if [ -n "$$last_tag" ]; then \
		range="$$last_tag..HEAD"; \
	else \
		range="HEAD"; \
	fi; \
	commits=$$(git log --no-merges --pretty=format:"- %s (%h)" $$range); \
	if [ -z "$$commits" ]; then \
		commits="- No changes."; \
	fi; \
	date=$$(date +%Y-%m-%d); \
	tmp=$$(mktemp); \
	{ \
		echo "# Changelog"; \
		echo ""; \
		echo "## v$(V) - $$date"; \
		echo "$$commits"; \
		echo ""; \
		if [ -f CHANGELOG.md ]; then \
			awk 'NR==1 && $$0=="# Changelog"{next} NR==2 && $$0==""{next} {print}' CHANGELOG.md; \
		fi; \
	} > "$$tmp"; \
	mv "$$tmp" CHANGELOG.md

version: changelog
	@if [ -z "$(V)" ]; then \
		echo "V is required (e.g., make version V=0.0.2)"; \
		exit 1; \
	fi
	@echo "$(V)" > VERSION
	@git add CHANGELOG.md VERSION
	@git commit -m "Release v$(V)"
	@git tag "v$(V)"
	@git push origin HEAD
	@git push origin "v$(V)"

test:
	@./tests/run.sh
