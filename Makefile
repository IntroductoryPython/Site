# Makefile for managing the IntroductoryPython online textbook

##########################################################################
## REQUIREMENTS
#
# This file requires `jupyter-book` for building the site.
#


##########################################################################
## VARIABLES

BOOK          = inpy
CONTENT-ORG   = https://github.com/COGS18
BOOK-ORG      = https://github.com/introductorypython
SITE-LOC      = introductorypython.github.io


##########################################################################
## CLONING MATERIALS

# Clone the content repositories for making the website
clone:

	clone-materials
	clone-assignments
	clone-projects

clone-materials:

	# Copy  materials
	@git clone --depth 1 $(CONTENT-ORG)/Materials $(BOOK)/materials
	@rm $(BOOK)/materials/README.md
	@rm -rf $(BOOK)/materials/.git

clone-assignments:

	# Copy assignments
	# git clone --depth 1 $(CONTENT-ORG)/assignments $(BOOK)/assignments
	# rm content/assignments/README.md

clone-projects:

	# Copy over the project repositories into temporary repositories
	@git clone --depth 1 $(CONTENT-ORG)/Projects $(BOOK)/temp

	# Copy over the files we want
	@mkdir $(BOOK)/projects
	@mv $(BOOK)/temp/overview.md $(BOOK)/projects/overview.md
	@mv $(BOOK)/temp/faq.md $(BOOK)/projects/faq.md
	@mv $(BOOK)/temp/ProjectIdeas.ipynb $(BOOK)/projects/ProjectIdeas.ipynb

	# Clear out the temporary folders
	@rm -rf $(BOOK)/temp


##########################################################################
## CLEAN UPS

# Clear out the copied repositories
clear:

	# Clear out copied materials
	rm -rf $(BOOK)/materials
	rm -rf $(BOOK)/assignments
	rm -rf $(BOOK)/projects

# Clean out the built textbook
clean:
	jupyter-book clean $(BOOK)/


##########################################################################
## BUILDING SITE

# Build the textbook
build:
	jupyter-book build $(BOOK)/

##########################################################################
## DEPLOYING SITE

# Deploy the website
deploy:

	# Create the textbook
	make build

	# Clone the website host repository
	rm -rf $(BOOK)/_build/deploy/
	git clone --depth 1 $(BOOK-ORG)/$(SITE-LOC) $(BOOK)/_build/deploy/

	# A .nojekyll file to tell Github pages to bypass Jekyll processing
	touch $(BOOK)/_build/deploy/.nojekyll

	# Copy site source into the host repo folder, then push to Github to deploy
	cd $(BOOK)/_build/ && \
	cp -r html/ deploy && \
	cd deploy && \
	git add * && \
	git add .nojekyll && \
	git commit -a -m 'deploy site' && \
	git push
