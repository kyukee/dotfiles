import sys, requests, re
from urllib.parse import urlparse

if len(sys.argv) <= 1:
	print("Error. You must provide an url as input.")
	exit(1)

inputURL = sys.argv[1]
parsedURL = urlparse(inputURL)

if not parsedURL.netloc:
	print("Error. The provided url wasn't able to be parsed.")
	exit(1)

webpage_text = requests.get(inputURL).text
regex_matches = re.findall("h3.*title.*href.*videos.*", webpage_text)

URL_list = []

for match in regex_matches:
	url_path = re.search("href=\"(.*)\"", match).group(1)
	video_url = "https://ecchi.iwara.tv" + url_path
	URL_list.append(video_url)
	
print("Number of video links found: " + str(len(URL_list)) + ". You should have 36 results.")

for url in URL_list:
	print(url, end=' ')
