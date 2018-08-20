# Search Ads Web Service

Online search advertisement platform & Realtime Campaign Monitoring

## Project Description

* Designed and developed web crawler which crawled 500000 product data from Amazon \(Java, JSoup, Proxy\)
* Developed Search Ads workflow support: Query understanding, Ads selection from inverted index \(with MemCached\), Ads ranking, Ads filter, Ads pricing, Ads allocation
* Employed MemCached as Ads Inverted index and built Ads forward index with MySQL Database which contain basic Ads information
* Built Ads Index Server which use gRPC to send Ads candidates to Ads Web Server
* Predict click probability with features generated from simulated search log

## Web Crawler

Used Jsoup to crawler information on Amazon.

* Finished
  * extract price, product detail url, product image url, category from web page
  * convert each product to Ads
  * store Ads to file, each ads in JSON format.
  * support paging
  * log all exception

### improments:

* Avoid Bot Detection:  use Proxy IP and rotating Brower
* performance: use message queue to implement a distributed Web Crawler

![](/images/2.jpeg)

## Online Search Ads Platform

Search advertising is placing online advertisments on front end pages that show results to users from their search engine queries. This search ads server takes thousands of product data as ads candidates and selects, filters, ranks, allocates and prices the ads when search query comes in. The selection and ranking of search ads is based on the quality of ads and the bid price offered by advertisers.

![](/images/1.jpeg)

### The data layer for supporting online system:

* Forward index for Ad detail information \(MySQL\)

##### Model\(stored in MySQL\):

```
     Ad:

     AdId    CampaignID    Keywords    Bid     Description    Detail\_URL   Category   Title  Brand    Thumbnail



     Campaign:

     CampaignID   Budget
```

* Inverted index for Ad keywords \(Memcached\)

##### Build Inverted index:   To accelerate the query speed

![](/images/3.jpeg)

### Backend Architecture:![](/images/4.jpeg)

### Query Understanding

* clean the text by Lucean
* train word2vector model using ads keywords corpus and use synonyms to rewrite query

### Query Relevancy Matching

Ads candiate will first be evaluated and filtered by relevance score. Relevance score is to measure how relevant query is to key words in ads. Here the **Initial** **version** of _relevance score = number of word match query / total number of words in key words_. For quick retreival of ads infomation, the inverted index of ads keywords were built and store in cache.

**improvement:**

use TF-IDF algorithm as the relevance score

### P-Click Prediction

The probability of user click \(p-click\) plays an important role in ads ranking.

Use spark ML process simulated user click log data and generate prediction model.

* Click log

log:

Device IP,  Device id,  Session id,  Query,  AdId,  CampaignId,    Ad\_category\_Query\_category\(0/1\),    clicked\(0/1\)

* Feature space

pClick Features extracted from search log and stored in key-value store[![](https://camo.githubusercontent.com/550a07ba0f2dbe7db7a296c1c41e98fc2741b949/68747470733a2f2f73332d75732d776573742d312e616d617a6f6e6177732e636f6d2f68656c6c6f2d6d79746573742f53637265656e2b53686f742b323031372d30372d31322b61742b372e30362e34372b414d2e706e67 "alt text")](https://camo.githubusercontent.com/550a07ba0f2dbe7db7a296c1c41e98fc2741b949/68747470733a2f2f73332d75732d776573742d312e616d617a6f6e6177732e636f6d2f68656c6c6f2d6d79746573742f53637265656e2b53686f742b323031372d30372d31322b61742b372e30362e34372b414d2e706e67)

* Model

Logistic Regression

### Online Ads Ranking and Pricing

Quality Score = 0.25 \* Relevance Score + 0.75 \* pClick

Rank Score = Quality Score \* Bid

Price\(Cost Per Click\) = next rank score / current quality score + 0.01



## History

```
python ../python/spark-warehouse/generate_budget.py budget.json

python -m json.tool ads.txt

python ../../python/spark-warehouse/dedupe_ads.py ../crawled/ads.txt clean_ads1.txt

python generate_user.py user_small.txt

python generate_budget.py budget.txt

python ../python/spark-warehouse/generate_query_ad.py ../data/deduped/clean_ads.txt query_camp_ad_file.json campaign_weight_file.json ad_weight_file.json query_group_id_query_file.json campaignId_category_file.json campaignId_adId_file.json

python ../python/spark-warehouse/generate_click_log.py ../data/deduped/clean_ads.txt ../data/log/user_small.txt query_camp_ad_file.json campaign_weight_file.json ad_weight_file.json campaignId_category_file.json campaignId_adId_file.json click_log_small.txt

install j2ee eclipse
install mysql

install mysql-connector for java

install mysql-workbench

python ../../python/spark-warehouse/generate_word2vec_training_data.py ../deduped/clean_ads.txt word2vec_training_cleaned.txt

python ../../python/spark-warehouse/word2vec.py word2vec_training_cleaned.txt word2vec_training.txt

memcached -p 11219 -l 127.0.0.1 -d

python generate_synonmy.py ../../data/log/word2vec_training.txt ../../data/deduped/clean_ads.txt

python select_feature.py ../../simpleads/click_log_small.txt

python store_ctr_feature.py

python prepare_ctr_training_data.py /home/chengwei/Projects/SearchAds/simpleads/click_log_small.txt

python ctr_logistic.py

python ctr_gbdt.py

use http://localhost:9090/SearchAds?q=home%20theater%20sysmtem
&
did=87843
&
dip=32772
&
qclass=Electronics

```

    CREATE TABLE `ad` (

    `adId` int(11) NOT NULL,

    `campaignId` int(11) DEFAULT NULL,

    `keyWords` varchar(1024) DEFAULT NULL,

    `bidPrice` double DEFAULT NULL,

    `price` double DEFAULT NULL,

    `thumbnail` mediumtext,

    `description` mediumtext,

    `brand` varchar(100) DEFAULT NULL,

    `detail_url` mediumtext,

    `category` varchar(1024) DEFAULT NULL,

    `title`varchar(2048) DEFAULT NULL,

     PRIMARY KEY (`adId`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    CREATE TABLE `campaign` (

    `campaignId` int(11) NOT NULL,

    `budget` double DEFAULT NULL, 
    PRIMARY KEY(`campaignId`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
