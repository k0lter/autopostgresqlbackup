# Changelog

## Version 2.0

* Huge code cleanup and refactoring

### Added features

* Compressing and/or encrypting dumps on the fly (Closes: #1)
* The day of the week for the weekly backups is now configurable (1 for Monday, 0 disable weekly backups) (Closes: #1, #9)
* The day of the month for the monthly backups is now configurable (instead of 1 by default, 0 disable the monthly backups) (Closes: #1, #8)
* Support for any compression tool that supports to read data to be compressed from stdin and outputs it to stdout (Closes: #3, #6)
* Daily, weekly and monthly dumps keeped are now configurable (by default, 14 daily, 5 weekly and 6 monthly backups)

### Removed features

* It's no longer possible to dump all databases in a single file
* Copying the last dump in the latest/ directory is no longer supported
* Specifying the databases names to dump during the montly backup is no longer supported
* It is no longer supported to send backup files by email (MAILCONTENT=files). It is probably no a good idea to send backup files by email (for various reasons: file size, privacy, data leaks, etc.) but I guess that it could easily be implemented in a POSTBACKUP script.
