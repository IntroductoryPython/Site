# Makefile for managing the IntroductoryPython online textbook

##########################################################################
## VARIABLES

BOOK_NAME   = inpy

##########################################################################

# Clone the content repositories for making the website
clone:

	# Copy tutorial materials
	@git clone --depth 1 https://github.com/COGS18/Materials $(BOOK_NAME)/tutorials
	@rm $(BOOK_NAME)/tutorials/README.md

	# Copy & build assignments
	# git clone --depth 1 https://github.com/COGS18/assignments $(BOOK_NAME)/assignments
	# rm content/assignments/README.md

# Clear out the copied repositories
clear:

	# Clear tutorial materials
	rm -rf $(BOOK_NAME)/tutorials
	rm -rf $(BOOK_NAME)/assignments

# Build the textbook
build:
	jupyter-book build $(BOOK_NAME)/

# Deploy the website
deploy:

	# Create the textbook
	make build

	# Clone the website deployment repository
	rm -rf $(BOOK_NAME)/_build/deploy/
	git clone --depth 1 https://github.com/introductorypython/introductorypython.github.io $(BOOK_NAME)/_build/deploy/

	# A .nojekyll file tells Github pages to bypass Jekyll processing
	touch $(BOOK_NAME)/_build/deploy/.nojekyll

	# Copy site into the gh-pages branch folder, then push to Github to deploy
	cd $(BOOK_NAME)/_build/ && \
	cp -r html/ deploy && \
	cd deploy && \
	git add * && \
	git add .nojekyll && \
	git commit -a -m 'deploy site' && \
	git push
