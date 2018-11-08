# S3Scan


S3Scan is atool running in your local bash that will analyse AWS S3 Buckets and help you estimate cost and decrease your bill. S3Scan is built on top of AWS-CLI using the low level API s3api to increase speed and remain lightweight. Some of the benefits of S3Scan are:

  - light, Low Level API (S3API)
  - Multi-Threading
  - Color Coding of results
  - use of AWS-CLI --profile to switch accounts

You can also:
  - Select a specific Region
  - Filter by bucket name content (partial strings)
  -  

### Installation

S3Scan requires Bash 3.0 or newer.

clone the repository or download the 3 files
To use this script without the sh or bash command, copy the files to the current user bin directory
```sh
$ cd ~
$ mkdir bin
```
then copy the files to your user bin folder
Give the files the power to execute
```sh
$ chmod a+x s3scan
$ chmod a+x s3scan
$ chmod a+x s3scan
```
That is it, you are now ready to start
make sure that you can contact the aws s3 api using this test command:
```sh
$ s3scan -t -b 
```

