/*
 * Calculates the hashtags that are commonly used for English tweets containing the word "coronavirus"
 */
SELECT
    '#' || extracted.hashtag AS tag,
    COUNT(*) AS count
FROM (
    SELECT DISTINCT
        data->>'id' AS id_tweets,
        jsonb_array_elements(data->'entities'->'hashtags')->>'text' AS hashtag
    FROM tweets_jsonb
    WHERE
        to_tsvector('english', COALESCE(data->>'text', '')) @@ to_tsquery('english', 'coronavirus')
        AND data->>'lang' = 'en'

    UNION

    SELECT DISTINCT
        data->>'id' AS id_tweets,
        jsonb_array_elements(data->'extended_tweet'->'entities'->'hashtags')->>'text' AS hashtag
    FROM tweets_jsonb
    WHERE
        to_tsvector('english', COALESCE(data->'extended_tweet'->>'full_text', '')) @@ to_tsquery('english', 'coronavirus')
        AND data->>'lang' = 'en'
) AS extracted
GROUP BY extracted.hashtag
ORDER BY count DESC, extracted.hashtag
LIMIT 1000;
