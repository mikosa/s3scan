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
  - Scan a specific AWS Region
  - Scan Filtered buckets by name "content" (partial name)
  - Change maximum number of parrallel threads (max 1 thread/bucket) (default is 1)

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
$ s3scan -t -b 
```
