# Documentation

## Configuration settings

### `MAILADDR`

Email Address to send errors to

**default**: `root`

### `SU_USERNAME`

By default, on Debian systems (and maybe others), only `postgres` user is allowed to access PostgreSQL databases without password.

In order to dump databases we need to run pg_dump/psql commands as `postgres` with su.

This setting makes possible to run backups with a substitute user using `su`. If empty, `su` usage will be disabled)

**default**: `""` (empty, not used)

### `USERNAME`

Username to access the PostgreSQL server

**default**: `postgres`

### `DBHOST`

Host name (or IP address) of PostgreSQL server. Use `localhost` for socket connection or `127.0.0.1` to force TCP connection.

**default**: `localhost`

### `DBPORT`

Port of PostgreSQL server. It is also used if `${DBHOST}` is `localhost` (socket connection) as socket name contains port.

**default**: `5432`

### `DBNAMES`

List of database(s) names(s) to backup

If you would like to backup all databases on the server set `DBNAMES="all"`. If set to `"all"` then any new databases will automatically be backed up without needing to modify this settings when a new database is created.

If the database you want to backup has a space in the name replace the space with a `%` (`"data base"` will become `"data%base"`).

**default**: `all`

**example**: `"users pages user%data"`

### `DBEXCLUDE`

List of databases to exclude if `DBNAMES` is not set to `all`.

**default** : `""` (empty)

**example**: `"pages user%data"`

### `GLOBALS_OBJECTS` 

Pseudo database name used to dump global objects (users, roles, tablespaces)

**default**: `postgres_globals`

### `BACKUPDIR` 

Backup directory

**default**: `/var/backups`

### `CREATE_DATABASE`

Include CREATE DATABASE in backups?

**default**: `yes`

### `DOWEEKLY`

Which day do you want weekly backups? (1 to 7 where 1 is Monday)

When set to 0, weekly backups are disabled

**default**: `7` (Sunday)

### `DOMONTHLY`

Which day do you want monthly backups?

When set to 0, monthly backups are disabled

**default**: `1` (first day of the month)

### `BRDAILY`

Backup retention count for daily backups, older backups are removed.

**default**: `14` (14 days)

### `BRWEEKLY`

Backup retention count for weekly backups, older backups are removed.

**default**: `5` (5 weeks)

### `BRMONTHLY`

Backup retention count for monthly backups, older backups are removed.

**default**: `12` (12 months)

### `COMP` 

Compression tool. It could be gzip, pigz, bzip2, xz, zstd or any compression tool that supports to read data to be compressed from stdin and outputs them to stdout).

If the tool is not in `${PATH}`, the absolute path can be used.

**default**: `gzip`

### `COMP_OPTS`

Compression tools options to be used with `COMP`

**default**: `""` (empty)

**example**:
```
COMP="zstd"
COMP_OPTS="-f -c"
```

### `PGDUMP_OPTS`

Options string for use with pg_dump (see [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) manual page).

**default**: `""` (empty)

### `PGDUMPALL_OPTS`

Options string for use with pg_dumpall (see [pg_dumpall](https://www.postgresql.org/docs/current/app-pg-dumpall.html) manual page).

**default**: `""` (empty)

### `EXT`

Backup files extension

**default**: `sql`

### `PERM`

Backup files permission

**default**: `600`

### `MIN_DUMP_SIZE`

Minimum size (in bytes) for a dump/file (compressed or not). File size below this limit will raise an warning.

**default**: `256`

### `ENCRYPTION`

Enable encryption (asymmetric) with GnuPG.

**default**: `no`

### `ENCRYPTION_PUBLIC_KEY`

Encryption public key (path to the key)

**default**: `""` (empty)

#### Export your public key:

`gpg --export 0xY0URK3Y1D --output mypubkey.gpg` or `gpg --export --armor 0xY0URK3Y1D --output mypubkey.asc`

then copy `mypubkey.asc` or `mypubkey.gpg` to the path pointed by the `${ENCRYPTION_PUBLIC_KEY}`.

#### Decryption

`gpg --decrypt --output backup.sql.gz backup.sql.gz.enc`

### `ENCRYPTION_SUFFIX`

Suffix for encyrpted files

**default**: `.enc`

### `PREBACKUP`

Command or script to execute before backups

**default**: `""` (empty, not used)

### `POSTBACKUP`

Command or script to execute after backups

**default**: `""` (empty, not used)

## Password settings

In order to use a password to connect to database create a file `${HOME}/.pgpass` containing a line like this

```
hostname:*:*:dbuser:dbpass
```
replace `hostname` with the value of `${DBHOST}`, `dbuser` with the value of `${USERNAME}` and `dbpass` with the password.
