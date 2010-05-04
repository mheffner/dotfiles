COMPLETION=git.sh rake.rb
BASHRC_DIR=bashrc
ENV_DIR=env

all: install env

.PHONY: install
install:
	cp $(BASHRC_DIR)/bashrc $(HOME)/.bashrc
	cp $(BASHRC_DIR)/bash_profile $(HOME)/.bash_profile
	cp $(BASHRC_DIR)/inputrc $(HOME)/.inputrc
	@for x in $(COMPLETION); do \
		echo "cp $(BASHRC_DIR)/bash_completion_$$x $(HOME)/.bash_completion_$$x"; \
		cp $(BASHRC_DIR)/bash_completion_$$x $(HOME)/.bash_completion_$$x; \
	done
	@for x in `ls dot.*`; do \
		cp $$x $${HOME}/$${x/dot/}; \
	done

.PHONY: env
env:
	@for x in `ls $(ENV_DIR)`; do \
		echo "Executing $(ENV_DIR)/$$x"; \
		./$(ENV_DIR)/$$x; \
	done
