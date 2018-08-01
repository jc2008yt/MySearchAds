#!/bin/sh -f

python ../python/spark-warehouse/generate_click_log.py ../data/deduped/clean_ads.txt ../data/log/user_small_teach.txt query_camp_ad_file.json campaign_weight_file.json ad_weight_file.json campaignId_category_file.json campaignId_adId_file.json click_log_small.txt
