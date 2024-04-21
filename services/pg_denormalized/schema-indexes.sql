CREATE INDEX idx_tweets_jsonb_hashtags ON tweets_jsonb USING GIN ((data->'entities'->'hashtags'), (data->'extended_tweet'->'entities'->'hashtags'));
CREATE INDEX idx_tweets_jsonb_text_gin ON tweets_jsonb USING GIN (to_tsvector('english', COALESCE(data->>'text', '')));
CREATE INDEX idx_tweets_jsonb_extended_text_gin ON tweets_jsonb USING GIN (to_tsvector('english', COALESCE(data->'extended_tweet'->>'full_text', '')));
CREATE INDEX idx_tweets_jsonb_text_search ON tweets_jsonb USING GIN (
    to_tsvector('english', COALESCE(data->'extended_tweet'->>'full_text', data->>'text'))
);
