# Makefile for managing the IntroductoryPython online textbook

##########################################################################
## REQUIREMENTS
#
# This file requires `jupyter-book` for building the site.
#


##########################################################################
## VARIABLES

BOOK_NAME     = inpy
CONTENT-ORG   = https://github.com/COGS18
BOOK-ORG      = https://github.com/introductorypython
SITE-LOC      = introductorypython.github.io


##########################################################################
## CLONING MATERIALS

# Clone the content repositories for making the website
clone:

	# Copy  materials
	@git clone --depth 1 $(CONTENT-ORG)/Materials $(BOOK_NAME)/tutorials
	@rm $(BOOK_NAME)/tutorials/README.md

	# Copy assignments
	# git clone --depth 1 $(CONTENT-ORG)/assignments $(BOOK_NAME)/assignments
	# rm content/assignments/README.md

	
##########################################################################
## CLEAN UPS

# Clear out the copied repositories
clear:

	# Clear tutorial materials
	rm -rf $(BOOK_NAME)/tutorials
	rm -rf $(BOOK_NAME)/assignments
	
# Clean out the built textbook
clean:
	jupyter-book clean $(BOOK_NAME)/


##########################################################################
## BUILDING SITE

# Build the textbook
build:
	jupyter-book build $(BOOK_NAME)/

##########################################################################
## DEPLOYING SITE

# Deploy the website
deploy:

	# Create the textbook
	make build

	# Clone the website host repository
	rm -rf $(BOOK_NAME)/_build/deploy/
	git clone --depth 1 $(BOOK-ORG)/$(SITE-LOC) $(BOOK_NAME)/_build/deploy/

	# A .nojekyll file to tell Github pages to bypass Jekyll processing
	touch $(BOOK_NAME)/_build/deploy/.nojekyll

	# Copy site source into the host repo folder, then push to Github to deploy
	cd $(BOOK_NAME)/_build/ && \
	cp -r html/ deploy && \
	cd deploy && \
	git add * && \
	git add .nojekyll && \
	git commit -a -m 'deploy site' && \
	git push
