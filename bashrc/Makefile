all: install

.PHONY: install
install:
	@for x in `ls dot.*`; do \
		cp $$x $(HOME)/$${x/dot/}; \
	done
	@for x in `ls bash_completion_*`; do \
		cp $$x $(HOME)/.$$x; \
	done

