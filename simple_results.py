from json import loads
from sys import argv


json_dict = None


with open(argv[1], 'r') as infile:
    json_dict = loads(infile.read())

for result in json_dict['results']:
    #print(result)
    url = result['url']
    sc  = result['status']
    print(f'{sc} {url}')

