#!/bin/sh -f

python ../python/spark-warehouse/generate_query_ad.py ../data/deduped/clean_ads.txt query_camp_ad_file.json campaign_weight_file.json ad_weight_file.json query_group_id_query_file.json campaignId_category_file.json campaignId_adId_file.json
