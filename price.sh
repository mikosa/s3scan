#!/bin/bash
LOCO=$1
voltype=""
voltypes=("Amazon Glacier" "One Zone - Infrequent Access" "Reduced Redundancy" "Standard - Infrequent Access" "Standard")

for i in `seq 0 4`;
do
voltype=${voltypes[i]}

# generate the filter for api pricing
generate_filter()
{
  cat <<EOF
[{"Type": "TERM_MATCH","Field": "productFamily", "Value": "Storage"}, 
{"Type": "TERM_MATCH","Field": "volumeType", "Value": "$voltype"},
{"Type": "TERM_MATCH","Field":"location", "Value": "$LOCO"}]
EOF
}

#use pricing api and filter for region and for volume type
aws pricing get-products --service-code AmazonS3 \
--filters "$(generate_filter)" \
--query 'PriceList[]' \
--output text \
| awk ' BEGIN { FS="\""; RS="," };
{   
    if (i=="") i=1;
    if (beg[i] != "" && end[i] != "" && price[i]!="") i+=1;
    if ($2 == "pricePerUnit") price[i]=$6;
    if ($2 == "beginRange") beg[i]= $4;
    if ($2 == "endRange") end[i]= $4;
};
END {
print beg[1], " " , end[1], " " , price[1];
print beg[2], " " , end[2], " " , price[2];
print beg[3], " " , end[3], " " , price[3];
}'\
| sort -g |tail -1 | awk '{print $3}'

done
