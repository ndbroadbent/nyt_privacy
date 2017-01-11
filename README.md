## In response to: https://news.ycombinator.com/item?id=13368711

I'm trying to figure out how much random data needs to be added to NYT articles before an eavesdropper can't tell what you're reading.

## Findings

### Article lengths are consistent if you make repeated requests.

E.g. If I make multiple requests for "http://www.nytimes.com/2017/01/04/travel/places-to-go-faq-2017.html?partner=rss&emc=rss", the length is always 65847 bytes.

### Article lengths

I fetched 197 articles from a selection of 6 NYT RSS feeds. Here's the lengths of the response bodies:

    [80816, 110124, 65745, 97604, 76246, 84295, 88687, 72903, 75928, 74966, 77340, 86963, 71763, 90062, 82252, 84104, 91421, 81413, 80598, 75090, 73792, 124009, 126000, 91594, 76011, 78599, 85260, 81732, 91334, 95643, 74999, 74918, 88818, 81574, 80653, 84295, 35226, 71763, 170377, 69314, 145844, 88597, 81031, 84568, 73150, 187250, 80863, 94493, 94475, 74439, 69547, 158268, 78531, 79455, 163661, 69153, 82769, 81031, 81413, 69503, 86914, 76246, 90062, 77696, 71615, 87280, 88173, 72413, 79455, 80463, 81732, 74486, 70430, 78203, 61310, 82969, 88674, 91223, 102902, 84234, 70420, 73828, 79973, 79813, 88687, 75621, 87447, 86021, 94831, 79997, 76824, 67902, 80838, 75166, 72731, 79813, 80463, 86914, 74486, 82969, 80716, 40830, 67902, 66612, 73755, 75788, 67145, 66454, 75297, 77879, 80461, 87447, 74288, 73826, 76824, 80551, 83043, 101528, 73533, 78572, 79362, 84770, 67856, 88375, 84234, 76011, 84738, 70791, 76357, 70143, 73282, 69082, 84626, 69723, 87256, 69372, 67732, 67156, 66259, 82683, 65868, 68356, 70420, 68211, 69778, 63873, 64213, 69913, 65173, 69518, 86691, 79683, 62302, 69067, 69988, 75888, 63448, 86648, 77403, 81202, 66926, 78730, 92802, 73951, 64841, 324225, 51760, 81583, 70345, 71977, 69565, 73943, 78848, 65247, 81767, 77713, 102209, 72067, 79127, 78264, 63864, 81561, 102902, 85504, 75621, 100854, 71345, 81834, 75882, 200931, 68189, 70601, 70191, 69736, 68085, 68885, 65847]


* Mean: 82188.43
* Standard deviation: 26206.5

This is the point where I'm going to start guessing, because I actually don't know anything about statistics.

So, uhhhh, I've heard some good things about 99.7% and 3 standard deviations. I guess they could pick a random number between 0 and 78619 (26206.5 * 3), and add that many random bytes to the page.

I also know that if there are more articles, then it gets harder to figure out which one the person is reading, because there are more articles with similar lengths. I would assume that if you wanted to be 99.7% sure that you have a pool of at least 20 possible articles, then the equation might involve 3 standard deviations, and it might also involve the number 20. (However, I'm 99.7% sure that I'm completely wrong.)

Also it seems like you would only want to make short articles longer, and you'd want to add less random data to the longest articles.


### How you might add random data to a webpage

If they were using Ruby (they're probably not), and they weren't caching all of their pages as static data (they probably are), then they could put something like this at the bottom of the page:

    <!-- <%= SecureRandom.base64(rand(0..78619)) %> -->

(Inspired by https://github.com/meldium/breach-mitigation-rails)