# AutoPostgreSQLBackup

AutoPostgreSQLBackup is a shell script (usually executed from a cron job) designed to provide a fully automated tool to make periodic backups of PostgreSQL databases.

AutoPostgreSQLBackup extract databases into flat files in a daily, weekly or monthly basis.

Version 2.0 is a full rewrite.

It supports:
 * Email notification
 * Compression on the fly
 * Encryption on the fly
 * Rotation (daily and/or weekly and/or monthly)
 * Databases exclusion
 * Pre and Post scripts
 * Local configuration

## Usage

On Debian (or derived):

Install: `apt install autopostgresqlbackup`

If the default options are not suitable for you, change them: `${EDITOR} /etc/default/autopostgresqlbackup`

That's it!

## Documentation

See [the documentation](/Documentation.md).

## History

 * 2023: Almost full rewrite with better error handling and new features (see Changelog.md for details)
 * 2019: Creation of a fork/standelone project on Github (https://github.com/k0lter/autopostgresqlbackup)
 * Since 2011: Various patches (fixes and new features) were added in the Debian package
 * 2011: AutoPostgreSQLBackup was included in Debian
 * 2005: AutoPostgreSQLBackup was written by Aaron Axelsen (with some contributions of Friedrich Lobenstock)
   * Project webpage was http://autopgsqlbackup.frozenpc.net/ (offline)

## Encryption

Encryption (asymmetric) is now done with GnuPG, you just need to add the
public key (armored or not) you want to encrypt the data to in the file pointed by the `${ENCRYPTION_PUBLIC_KEY}` configuration setting.

Export your public key:

`gpg --export 0xY0URK3Y1D --output mypubkey.gpg`

or

`gpg --export --armor 0xY0URK3Y1D --output mypubkey.asc`

then copy `mypubkey.asc` or `mypubkey.gpg` to the path pointed by the `${ENCRYPTION_PUBLIC_KEY}` configuration setting and set the `${ENCRYPTION}` setting to `yes`.

## OpenSSL Encryption

Starting from version 2.0 encryption with OpenSSL is no longer supported as [it was discovered](https://github.com/k0lter/autopostgresqlbackup/issues/10) (but also [known for quite some time](https://github.com/cytopia/mysqldump-secure/issues/21)) that encrypting large files with [OpenSSL silently fail](https://github.com/openssl/openssl/issues/2515) and that decrypting these files is [close to be impossible](https://github.com/imreFitos/large_smime_decrypt).

## Authors

 * Emmanuel Bouthenot (Current maintainer)
 * Friedrich Lobenstock (Contributions)
 * Aaron Axelsen (Original author)
