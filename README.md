# S3Scan

S3Scan is a bash script running on top of your local aws-cli that will analyse AWS S3 Buckets and help you estimate cost and hopefully decrease your bill. S3Scan is built on top of AWS-CLI using the low level API (s3api) to increase speed and remain lightweight. Some of the benefits of S3Scan are:

  - Built on top of a Light weight, Low Level API (S3API)
  - Supports Multi-Threading, parallel computation to increase the speed of processing
  - Color Coding of results
  - Use of AWS-CLI --profile option (-p "String") to easily switch and scan a different AWS account (similar to aws-cli)
  - Detects all versions of files within buckets
  - Detects and flashes buckets that are not encryted at rest
  - Detects Bucket Creation Date and Last date bucket object was modified
  - Estimates charge per bucket and per volume type

You can also:
  - Filter buckets in a specific AWS Region
  - Filter buckets using partial name
  - Modify maximum number of parallel threads (max 1 thread/bucket) (default is 1)

### Installation

S3Scan requires Bash 3.0 or newer. (should work on both windows and linux or ubuntu (not fully tested yet)....)

Clone this repository or download the 3 files
To use this script without the sh or bash command, copy the files to the current user bin directory
```sh
$ cd ~
$ mkdir bin
```
then copy the files to your user bin folder
Give the files the power to execute
```sh
$ chmod a+x s3scan
$ chmod a+x b2.sh
$ chmod a+x price.sh
```
That is it, you are now ready to start
make sure that you can contact the aws s3 api using this unit test command (more of an integration test):
```sh
$ s3scan -u "true" -b "bucketname"
```

### Usage and Syntax

To scan all s3 buckets in account
```sh
$ s3scan
```
To scan all s3 buckets in another user account
(Make sure the profile is already setup correctly using "aws confgure --profile "profilename")
```sh
$ s3scan -p "profilename"
```

Run multiple threads in parralel (maximum of 1 thread per bucket). It is a good idea to test and check your cpu speed with TOP command or any other command. Adding too many processes might not make a big difference if you do not have extra cpu resources availabale. Default value is 1 thread only

```sh
$ s3scan -t 10
```
[![S3Scan](https://s3.amazonaws.com/www.serverlatency.com/Screenshot_252.jpg)]


Filter buckets by bucket partial name

```sh
$ s3scan -f "partialname"
```
Filter buckets by aws region

```sh
$ s3scan -r "ca-central-1"
```