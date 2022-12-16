.PHONY: docs clean

# Gallery path must be given relative to the docs/ folder

ifeq ($(GALLERY_PATH),)
GALLERY_PATH := ../../napari/examples
endif

clean:
	echo clean
	rm -rf docs/_build/
	rm -rf docs/api/napari*.rst
	rm -rf docs/_tags
	rm -rf docs/gallery/

docs-install:
	python -m pip install -qr requirements.txt

docs-build:
	python docs/_scripts/prep_docs.py
	NAPARI_APPLICATION_IPY_INTERACTIVE=0 sphinx-build -b html docs/ docs/_build -D sphinx_gallery_conf.examples_dirs=$(GALLERY_PATH)

docs: clean docs-install docs-build

html: clean docs-build

# Implies noplot, but no clean - call 'make clean' manually if needed
# Autogenerated paths need to be ignored to prevent reload loops
html-live:
	python docs/_scripts/prep_docs.py
	NAPARI_APPLICATION_IPY_INTERACTIVE=0 sphinx-autobuild \
		-b html \
		docs/ \
		docs/_build \
		-D plot_gallery=0 \
		-D sphinx_gallery_conf.examples_dirs=$(GALLERY_PATH) \
		--ignore "$(shell pwd)/docs/_tags/*" \
		--ignore "$(shell pwd)/docs/api/napari*.rst" \
		--ignore "$(shell pwd)/docs/gallery/*" \
		--ignore "$(shell pwd)/docs/jupyter_execute/*"

html-noplot: clean
	python docs/_scripts/prep_docs.py
	NAPARI_APPLICATION_IPY_INTERACTIVE=0 sphinx-build -D plot_gallery=0 -b html docs/ docs/_build -D sphinx_gallery_conf.examples_dirs=$(GALLERY_PATH)

linkcheck-files:
	NAPARI_APPLICATION_IPY_INTERACTIVE=0 sphinx-build -b linkcheck -D plot_gallery=0 --color docs/ docs/_build -D sphinx_gallery_conf.examples_dirs=$(GALLERY_PATH)