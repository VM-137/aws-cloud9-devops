install-aws:
		pip install --upgrade pip \
				&& pip install -r requirements.txt
				
lint: 
		pylint --disable=R,C search.py

format:
		black *.py

test:
		python -m pytest -vv --cov=search test_search.py