# Adaptive Server Enterprise (Sybase) full dumps of all databases on a server
Dumps all databases except model, tempdb and sybsystemprocs. Used compression level 101 and the structure of the dumps folder is:

```
/backup/dumps/<db_name>/
```
##### Requirements

This script is using the sa user and is assuming that all databases folder already exists on the backup folder path.

It's also needed a file that contains the sa password, this file have to be place on

```
$SYBASE/.sybaseASE
```
