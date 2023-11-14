lint:
	ruff check --select E,F,W,B,C4,I --ignore E402,E501,E712,B904,B905 --exclude=CTFd/uploads CTFd/ migrations/ tests/
	yarn lint
	black --check --diff --exclude=CTFd/uploads --exclude=node_modules .
	prettier --check 'CTFd/themes/**/assets/**/*'
	prettier --check '**/*.md'

format:
	isort --skip=CTFd/uploads -rc CTFd/ tests/
	black --exclude=CTFd/uploads --exclude=node_modules .
	prettier --write 'CTFd/themes/**/assets/**/*'
	prettier --write '**/*.md'

test:
	pytest -rf --cov=CTFd --cov-context=test --cov-report=xml \
		--ignore-glob="**/node_modules/" \
		--ignore=node_modules/ \
		-W ignore::sqlalchemy.exc.SADeprecationWarning \
		-W ignore::sqlalchemy.exc.SAWarning \
		-n auto
	bandit -r CTFd -x CTFd/uploads --skip B105,B322
	pipdeptree
	yarn verify

coverage:
	coverage html --show-contexts

serve:
	python serve.py

shell:
	python manage.py shell

translations-init:
	# make translations-init lang=af
	pybabel init -i messages.pot -d CTFd/translations -l $(lang)

translations-extract:
	pybabel extract -F babel.cfg -k lazy_gettext -k _l -o messages.pot .

translations-update:
	pybabel update --ignore-obsolete -i messages.pot -d CTFd/translations

translations-compile:
	pybabel compile -f -d CTFd/translations