# aws-cloud9-devops
This is a Python for DevOps AWS-Cloud9 repo


## Github actions and scaffold
1. Basic Scaffold
```bash
mkdir -p .github/workflows \
    && cd .github/workflows \
    && touch main.yml \
    && cd ~/aws-cloud9-devops \
    && touch Makefile \
    && touch requirements.txt \
    && touch hello.py \
```

2. Populate 'main.yml' 
```
name: AWS Python 3.7.15
on: [push]
jobs:
  buil:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Set up Python 3.7.1
      uses: actions/setup-python@v1
      with:
        python-version: 3.7.1
    
    - name: Install dependencies
      run: |
        make install-aws
```

2. Populate 'Makefile' 
```
install-aws:
		pip install --upgrade pip \
				&& pip install -r requirements.txt
				
lint: pylint --disable=R,C hello.py

format:
		black *.py

test:
		python -m pytest -vv --cov=hello test_hello.py
```

3. Populate  'requirements.txt'
```
click
pytest
pylint
```
4. Populate 'hello.py'
```python
def hi():
    return "hi"
```
5. Add, commit and push
```bash
git add * \
    && git commit -m "message" \
    && git push \
    && git status
```