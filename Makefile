BASHRC_DIR=bashrc
ENV_DIR=env

all: install env

.PHONY: install
install:
	cd $(BASHRC_DIR) && make install && cd -
	@for x in `ls dot.*`; do \
		cp $$x $${HOME}/$${x/dot/}; \
	done

.PHONY: env
env:
	@for x in `ls $(ENV_DIR)`; do \
		echo "Executing $(ENV_DIR)/$$x"; \
		./$(ENV_DIR)/$$x; \
	done
