#!/bin/bash
#bucket name, creation date, number of files, total size of files, last modified(most recent file of a bucket), bucket cost

BUCKETNAME=$1

# find appropriate region format for pricing API
function convert_region(){
case $1 in
"us-west-2") NAMEREGION="US West (Oregon)" ;;
"us-west-1") NAMEREGION="US West (N. California)" ;;
"us-east-2") NAMEREGION='US East (Ohio)' ;;
"us-east-1") NAMEREGION='US East (N. Virginia)' ;;
"ap-south-1") NAMEREGION="Asia Pacific (Mumbai)" ;;
"ap-northeast-2") NAMEREGION="Asia Pacific (Seoul)" ;;
"ap-southeast-1") NAMEREGION="Asia Pacific (Singapore)" ;;
"ap-southeast-2") NAMEREGION="Asia Pacific (Sydney)" ;;
"ap-northeast-1	") NAMEREGION="Asia Pacific (Tokyo)" ;;
"ca-central-1") NAMEREGION="Canada (Central)" ;;
"cn-north-1") NAMEREGION="China (Beijing)" ;;
"eu-central-1") NAMEREGION="EU (Frankfurt)" ;;
"eu-west-1") NAMEREGION="EU (Ireland)" ;;
"eu-west-2") NAMEREGION="EU (London)" ;;
"eu-west-3") NAMEREGION="EU (Paris)" ;;
"sa-east-1") NAMEREGION="South America (Sao Paulo)" ;;
"us-gov-west-1") NAMEREGION="AWS GovCloud (US)" ;;
esac
echo "$NAMEREGION"
}

#Get bucket location
locator=$(aws s3api get-bucket-location --bucket $1 --query "LocationConstraint" --output text)

if [ "$locator" == "None" ]; then
locator="us-east-1";
fi

#pricing
pricelist=($(echo "$(convert_region $locator)" | awk -F "," '{print $1}' | xargs -n1 -I {} bash -c 'sh price.sh "{}"'))
price_std=${pricelist[4]}
std_infreq=${pricelist[3]}
rr=${pricelist[2]}
onezone=${pricelist[1]}
glacier=${pricelist[0]}

#Get Bucket Encryption Status
encryptor=$(aws s3api get-bucket-encryption --bucket $1 --query "ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm" --output text 2>/dev/null || echo "Absent")
           
#Get Bucket Versioning Status
VersioningStatus=$(aws s3api get-bucket-versioning --bucket $1  --output text)
if [ "$VersioningStatus" == "" ]; then
VersioningStatus="Disabled"
fi

#list files, sum memory usage and count file number
aws s3api list-object-versions \
        --bucket $BUCKETNAME \
        --query 'Versions[].{Size: Size, StorageClass: StorageClass, LastModified: LastModified }' \
        --output text \
| sort -r -k1 \
| awk -v rr=$rr -v onezone=$onezone -v glacier=$glacier -v price_std=$price_std  -v std_infreq=$std_infreq -v reg=$locator -v enc=$encryptor -v ver=$VersioningStatus '\
        function red(string) { printf ("%s%s%s", "\033[1;31m", string, "\033[0m "); }\
        function green(string) { printf ("%s%s%s", "\033[1;32m", string, "\033[0m "); }\
        function blue(string) { printf ("%s%s%s", "\033[1;34m", string, "\033[0m "); }\
        NR==1{lastmod=(substr ($1, 0, 10));} {sum[$3] += $2} \
        END{ line= ":" reg ":" lastmod ":" enc ":" ver ":";\
            for (i in sum) {\
            if (i =="STANDARD") {conv=price_std; type_col=3}
            if (i == "STANDARD_IA") {conv=std_infreq; type_col=2}
            if (i =="ONEZONE_IA ") {conv=onezone;type_col=2}
            if (i == "REDUCED_REDUNDANCY ") {conv=rr;type_col=2}
            if (i == "GLACIER") {conv=glacier;type_col=1}
            mem= sum[i]/ 1024 / 1024 /1024" GB"
            print blue(line) ":", red(i) , mem ":" , mem*conv" USD"}}'
            
            