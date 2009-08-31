COMPLETION=git.sh rake.rb

install:
	cp src/bashrc $(HOME)/.bashrc
	cp src/bash_profile $(HOME)/.bash_profile
	cp src/inputrc $(HOME)/.inputrc
	for x in $(COMPLETION); do \
		cp src/bash_completion_$$x $(HOME)/.bash_completion_$$x; \
	done
