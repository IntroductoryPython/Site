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

clone-labs:

	# Clone coding labs repo, and copy out files (to re-org & rename)
	@git clone --depth 1 $(CONTENT-ORG)/CodingLabs $(BOOK)/temp --branch tom --single-branch

	@mkdir $(BOOK)/labs
	@mv $(BOOK)/temp/CL1-ProgrammingI.ipynb $(BOOK)/labs/CL1-ProgrammingI.ipynb
	@mv $(BOOK)/temp/CL2-ProgrammingII.ipynb $(BOOK)/labs/CL2-ProgrammingII.ipynb
	@mv $(BOOK)/temp/CL3-AlgorithmicThinking.ipynb $(BOOK)/labs/CL3-AlgorithmicThinking.ipynb
	@mv $(BOOK)/temp/CL4-Exploring.ipynb $(BOOK)/labs/CL4-Exploring.ipynb
	@mv $(BOOK)/temp/CL6-CommandLine.ipynb $(BOOK)/labs/CL5-CommandLine.ipynb
	@rm -rf $(BOOK)/temp


clone-assignments:

	# Clone assignments repo, and copy out files (to re-org & rename)
	@git clone --depth 1 $(CONTENT-ORG)/Assignments $(BOOK)/temp

	# Copy over the files we want
	@mkdir $(BOOK)/assignments
	@mv $(BOOK)/temp/A1-GettingStarted.ipynb $(BOOK)/assignments/D1-GettingStarted.ipynb
	@mv $(BOOK)/temp/A2-Ciphers.ipynb $(BOOK)/assignments/D2-Ciphers.ipynb
	@mv $(BOOK)/temp/A3-Chatbots.ipynb $(BOOK)/assignments/D3-Chatbots.ipynb
	@mv $(BOOK)/temp/A4-ArtificialAgents.ipynb $(BOOK)/assignments/D4-ArtificialAgents.ipynb
	@rm -rf $(BOOK)/temp

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
