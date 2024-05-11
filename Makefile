NAME=autopostgresqlbackup

all: man

man: ${NAME}.1

${NAME}.1: Documentation.md
	ronn \
		--manual autopostgresqlbackup \
		--name autopostgresqlbackup \
		--section 1 \
		-r Documentation.md
	# Fix duplicate "NAME" section
	tr '\n' '\0' < Documentation.1 \
		| sed -E 's,\.SH "NAME".\\fB[a-zA-Z0-9]+\\fR.,,' \
		| tr '\0' '\n' >  ${NAME}.1
	rm -f Documentation.1

clean:
	rm -f ${NAME}.1
