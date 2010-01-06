NAME=testsuite

all:	$(NAME).prg

$(NAME).prg: $(NAME).tas
	dasm $< -o$@

clean:
	rm -f $(NAME).prg
