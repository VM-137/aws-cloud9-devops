[![AWS Python 3.7.10](https://github.com/VM-137/aws-cloud9-devops/actions/workflows/main.yml/badge.svg)](https://github.com/VM-137/aws-cloud9-devops/actions/workflows/main.yml)

# aws-cloud9-devops
This is a Python for DevOps repo, an example of CI using good practices.
I have used a EC2 instance on cloud9 AWS environment, git and github actions.<br>
Libraries used: (click, pytest, pylint, black, pytest-cov)

### Work flow:
* SetUp a basic structure and environment
* SetUp Click options and simple test
* Check Github actions


## SetUp basic structure and environment
1. Scaffold
	```bash
	mkdir -p .github/workflows \
	    && cd .github/workflows \
	    && touch main.yml \
	    && cd ~/aws-cloud9-devops \
	    && touch Makefile \
	    && touch requirements.txt \
	    && touch search.py \
	```

2. Populate 'main.yml' (for github actions, inside workflows)<br>
This EC2 instance uses python 3.7.10, the closest version that github allow us 
to use in github actions environments is python 3.7.15, therefore we select
that version in 'main.yml' because we know the differences for this project are 
negligible.
	```
	name: AWS Python 3.7.10
	on: [push]
	jobs:
	  buil:
	    runs-on: ubuntu-latest
	    steps:
	    - uses: actions/checkout@v2
	    - name: Set up Python 3.7.15
	      uses: actions/setup-python@v1
	      with:
		python-version: 3.7.15

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
			python -m pytest -vv --cov=search test_search.py
	```

3. Populate  'requirements.txt'
	```
	click
	pytest
	pylint
	black
	pytest-cov
	```
4. Populate 'search.py'
	```python
	def hi():
	    return "hi"
	```
5. Add, commit and push
	```bash
	git add * \
	    && git add .github
	    && git commit -m "message" \
	    && git push \
	    && git status
	```
6. Environment creation, source and packages install
	```bash
	virtualenv ~/.aws-cloud9-devops \
	    && source ~/.aws-cloud9-devops/bin/activate \
	    && make install-aws
	```


## SetUp Click options and simple test

1. Modify 'search.py' <br>
This python script will search for a path and file type, when have a match
it will print what is inside in red and then iterate for each result and print
blue or white.
	```python
	#!/usr/bin/env python
	import click
	import glob

	@click.command()
	@click.option(
	    "--path",
	    prompt="Path to search for csv files",
	    help="This is the path to search for files: /tmp"
	    )
	@click.option(
	    "--ftype",
	    prompt="Pass in the type of file",
	    help="Pass in the file type: i.e csv"
	    )

	def search(path, ftype):
	    """ This is a tool that search for patterns like *.csv"""
	    results = glob.glob(f"{path}/*.{ftype}")
	    click.echo(click.style("Found Matches:", fg="red"))
	    for result in results:
		click.echo(click.style(f"{result}", bg="blue", fg="white"))


	if __name__ == "__main__":
	    # pylint: disable=no-value-for-parameter
	    search()
	```
2. Make it executable, print options and check if works
	```bash
	chmod +x search.py \
	    && ./search.py --help \
	    && ./search.py --path . --ftype py
	```
	Output:<br>
![Screenshot from 2022-10-20 22-49-09](https://user-images.githubusercontent.com/78228205/197062514-edf73f70-9840-4388-a5a9-48739c7d7a6f.png)


3. Create 'search_test.py'
	```bash
	touch search_test.py
	```
	Populate
	```python
	from click.testing import CliRunner
	from search import search


	def test_search():
	    runner = CliRunner()
	    result = runner.invoke(search, ["--path", ".", "--ftype", "py"])
	    assert result.exit_code == 0
	    assert ".py" in result.output
	```

4. Test 'search.py'
	```bash
	make test
	```
	Output<br>
![Screenshot from 2022-10-20 23-03-48](https://user-images.githubusercontent.com/78228205/197062715-e7ba247b-6516-4ba5-8d9f-9d8cd74a9672.png)



5. Formatting using balck
	```bash
	make format
	```
6. Add jobs to the github actions workflow in 'main.yml'
	```bash
	    - name: lint
	      run: |
		make lint
	    - name: test
	      run: |
		make test
	    - name: format
	      run: |
		make format
	```

7. Add, commit and push
	```bash
	git add * \
	    && git add .github
	    && git commit -m "Adding functionality" \
	    && git push \
	    && git status
	```
## Check Github actions
* General view<br>
![Screenshot from 2022-10-20 23-34-00](https://user-images.githubusercontent.com/78228205/197063227-d0eb675c-0929-496b-9511-325621df38bf.png)
* Last commit, check jobs (install, lint, test, format)<br>
![Screenshot from 2022-10-20 23-22-23](https://user-images.githubusercontent.com/78228205/197063446-5ec30214-9c5f-430d-a64d-621ced2126be.png)



