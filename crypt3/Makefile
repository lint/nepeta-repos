ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS = -g -O3 -pedantic -Wall -Wextra -std=c99 -I$(ERLANG_PATH)

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

priv/nif.so: clean
	@mkdir -p priv
	@$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ \
		c_src/nif.c

clean:
	@$(RM) -r priv/nif.so