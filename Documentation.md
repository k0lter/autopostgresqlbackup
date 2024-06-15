## NAME

autopostgresqlbackup -- Automated tool to make periodic backups of databases

## SYNOPSIS

`autopostgresqlbackup [OPTIONS]`

## DESCRIPTION

AutoPostgreSQLBackup is a shell script (usually executed from a cron job or a
systemd timer) designed to provide a fully automated tool to make periodic
backups of databases.

AutoPostgreSQLBackup extract databases into flat files (compressed or not,
encrypted or not) in a daily and/or weekly and/or monthly basis.

AutoPostgreSQLBackup supports mutliple databases engines (PostgreSQL and MySQL
by now).

## OPTIONS

`-h` displays command line help

`-d` Run in debug mode (no mail sent)

`-c` Configuration file or directory (default: `/etc/default/autopostgresqlbackup`)

  When a directory is used, the `*.conf` files will be processed sequentially.
  It allows one to backup multiple databases servers with distinct settings :

   - database servers with distinct engines
   - PostgreSQL cluster with instances running on multiple ports

## ENCRYPTION

Encryption (asymmetric) is now done with GnuPG, you just need to add the public
key (armored or not) you want to encrypt the data to in the file pointed by the
`ENCRYPTION_PUBLIC_KEY` configuration setting.

Export your public key:

`gpg --export 0xY0URK3Y1D --output mypubkey.gpg`

or

`gpg --export --armor 0xY0URK3Y1D --output mypubkey.asc`

then copy mypubkey.asc or mypubkey.gpg to the path pointed by the
`ENCRYPTION_PUBLIC_KEY` configuration setting and set the `ENCRYPTION` setting
to yes.

## DECRYPTION

In order to decrypt a previously encrypted database dump:

`gpg --decrypt --output backup.sql.gz backup.sql.gz.enc`

## OPENSSL ENCRYPTION

Starting from version 2.0 encryption with OpenSSL is no longer supported as it
was discovered[1] (but also known for quite some time[2]) that encrypting large
files with OpenSSL silently fail[3] and that decrypting these files is close to
be impossible[4].

  * [1] https://github.com/k0lter/autopostgresqlbackup/issues/10
  * [2] https://github.com/cytopia/mysqldump-secure/issues/21
  * [3] https://github.com/openssl/openssl/issues/2515
  * [4] https://github.com/imreFitos/large_smime_decrypt

## CONFIGURATION

### MAILADDR

Email Address to send errors to. If empty errors are displayed on stdout.

**default**: `root`

### DBENGINE

Database engine

**default**: `postgresql`

*supported values*: `postgresql` or `mysql`

### USERNAME

Username to access the database server

**default**: `""` (empty, the username to use is automatically defined depending on `DBENGINE`: `postgres` for PostgreSQL and `root` for MySQL)

### SU_USERNAME

By default, on Debian systems (and maybe others), only `postgres` user is
allowed to access PostgreSQL databases without password.

In order to dump databases we need to run pg_dump/psql commands as `postgres`
with su.

This setting makes possible to run backups with a substitute user using `su`.
If empty, `su` usage will be disabled)

**default**: `""` (empty, not used)

*Only while using PostgreSQL database engine*

### PASSWORD

Password to access then Database server

While using PostgreSQL database engine, in order to use a password to connect
to database create a file `~/.pgpass` containing a line like this:

   `hostname:*:*:dbuser:dbpass`

   replace `hostname` with the value of `DBHOST`, `dbuser` with the value of
   `USERNAME` and `dbpass` with the password.

While using MySQL database engine, if password is not set mysqldump will try
to read credentials from `~/.my.cnf` if file exists.

**default**: `""` (empty)

### DBHOST

Host name (or IP address) of database server. Use `localhost` for socket
connection or `127.0.0.1` to force TCP connection.

**default**: `localhost`

### DBPORT

Port of database server.

While using PostgreSQL database engine, it is also used if `DBHOST` is
`localhost` (socket connection) as socket name contains port.

**default**: `""` (empty, the port to use is automatically defined depending on `DBENGINE`: `5432` for PostgreSQL and `3306` for MySQL)

### DBNAMES

Explicit list of database(s) names(s) to backup

If you would like to backup all databases on the server set `DBNAMES="all"`.
If set to `"all"` then any new databases will automatically be backed up
without needing to modify this settings when a new database is created.

If the database you want to backup has a space in the name replace the space by a `%20` (`"data base"` will become `"data%20base"`).

**default**: `all`

**example**: `"users pages user%20data"`

### DBEXCLUDE

List of databases to exclude if `DBNAMES` is not set to `all`.

**default** : `""` (empty)

**example**: `"pages user%20data"`

### GLOBALS_OBJECTS

Virtual database name used to backup global objects (users, roles, tablespaces).

**default**: `postgres_globals`

*Only while using PostgreSQL database engine*

### BACKUPDIR

Backup directory

**default**: `/var/backups`

### CREATE_DATABASE

Include or not `CREATE DATABASE` statments in dabatbases backups.

**default**: `yes`

*supported values*: `yes` or `no`

### DOWEEKLY

Which day do you want weekly backups? (1 to 7 where 1 is Monday).

When set to 0, weekly backups are disabled.

**default**: `7` (Sunday)

### DOMONTHLY

Which day do you want monthly backups?

When set to 0, monthly backups are disabled.

**default**: `1` (first day of the month)

### BRDAILY

Backup retention count for daily backups, older backups are removed.

**default**: `14` (14 days)

### BRWEEKLY

Backup retention count for weekly backups, older backups are removed.

**default**: `5` (5 weeks)

### BRMONTHLY

Backup retention count for monthly backups, older backups are removed.

**default**: `12` (12 months)

### COMP

Compression tool. It could be gzip, pigz, bzip2, xz, zstd or any compression
tool that supports to read data to be compressed from stdin and outputs them
to stdout).

If the tool is not in `${PATH}`, the absolute path can be used.

**default**: `gzip`

### COMP_OPTS

Compression tools options to be used with `COMP`

**default**: `""` (empty)

**example**: `COMP="zstd" COMP_OPTS="-f -c"`

### PGDUMP

pg_dump path (relative if present in `${PATH}` or absolute)

**default**: `""` (if empty `pg_dump` will be used)

*Only while using PostgreSQL database engine*

### PGDUMPALL

pg_dumpall path (relative if present in `${PATH}` or absolute)

**default**: `""` (if empty `pg_dumpall` will be used)

*Only while using PostgreSQL database engine*

### PGDUMP_OPTS

Options string for use with pg_dump (see
[pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) manual
page).

**default**: `""` (empty)

*Only while using PostgreSQL database engine*

### PGDUMPALL_OPTS

Options string for use with pg_dumpall (see
[pg_dumpall](https://www.postgresql.org/docs/current/app-pg-dumpall.html)
manual page).

**default**: `""` (empty)

*Only while using PostgreSQL database engine*

### MYDUMP_OPTS

Options string for use with mysqldump (see
[mysqldump](https://dev.mysql.com/doc/refman/8.3/en/mysqldump.html) manual
page).

**default**: `""` (empty)

*Only while using MySQL database engine*

### EXT

Backup files extension

**default**: `sql`

### PERM

Backup files permission

**default**: `600`

### MIN_DUMP_SIZE

Minimum size (in bytes) for a dump/file (compressed or not). File size below
this limit will raise a warning.

**default**: `256`

### ENCRYPTION

Enable encryption (asymmetric) with GnuPG.

**default**: `no`

*supported values*: `yes` or `no`

### ENCRYPTION_PUBLIC_KEY

Encryption public key (path to the key)

**default**: `""` (empty)

### ENCRYPTION_SUFFIX

Suffix for encyrpted files

**default**: `.enc`

### PREBACKUP

Command or script to execute before backups

**default**: `""` (empty, not used)

### POSTBACKUP

Command or script to execute after backups

**default**: `""` (empty, not used)

## AUTHORS

Originally developped by Aaron Axelsen with Friedrich Lobenstock contributions.

Almost fully rewritten by Emmanuel Bouthenot (version 2.0 and higher).

## LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

## CONTRIBUTIONS

Contributions are welcome on the project page:
https://github.com/k0lter/autopostgresqlbackup/pulls

## BUGS

Bug reports are welcome on the project page:
https://github.com/k0lter/autopostgresqlbackup/issues

## SEE ALSO

`pg_dump`(1), `pg_dumpall`(1), `mysqldump`(1) and the project page https://github.com/k0lter/autopostgresqlbackup/
