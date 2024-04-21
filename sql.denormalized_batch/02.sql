/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
 */
SELECT
    '#' || extracted.hashtag AS tag,
    COUNT(*) AS count
FROM (
    SELECT DISTINCT
        tweets.data->>'id' AS id_tweets,
        jsonb_array_elements(tweets.data->'entities'->'hashtags')->>'text' AS hashtag
    FROM tweets_jsonb tweets
    WHERE
        tweets.data->'entities'->'hashtags' @> '[{"text": "coronavirus"}]'::jsonb

    UNION

    SELECT DISTINCT
        tweets.data->>'id' AS id_tweets,
        jsonb_array_elements(tweets.data->'extended_tweet'->'entities'->'hashtags')->>'text' AS hashtag
    FROM tweets_jsonb tweets
    WHERE
        tweets.data->'extended_tweet'->'entities'->'hashtags' @> '[{"text": "coronavirus"}]'::jsonb
) AS extracted
GROUP BY extracted.hashtag
ORDER BY count DESC, extracted.hashtag ASC
LIMIT 1000;
