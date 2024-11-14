NAME=autopostgresqlbackup
SECTION=8

all: man

man: ${NAME}.${SECTION}

${NAME}.${SECTION}: Documentation.md
	pandoc \
		--standalone \
		--to man \
		Documentation.md \
		-o ${NAME}.${SECTION}

clean:
	rm -f ${NAME}.${SECTION}
