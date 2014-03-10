from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.http import HttpResponseRedirect, HttpResponseServerError
from django.core.context_processors import csrf

from django.views.decorators.csrf import csrf_exempt
from luminoso_api import LuminosoClient

import json
import os

# get pw from hidden file, TBD: figure out how to get EC2 instance env variables set
pw = ""
fname = '/home/ubuntu/.env'
if os.path.isfile(fname):
	pw = open(fname, 'r').read()[:16]

@csrf_exempt
def push(request):
	correlations = {}  # dictionary of correlations
	if len(request.body) == 0:
		return HttpResponseRedirect("/")

	json_data = json.loads(request.body)  # load text from body of request
	try:
		# connect to Luminoso and our english corpus
		project_name = "GP english sample"
		client = LuminosoClient.connect('/projects/u64t648d/', 
				 username='gk@luminoso.com', password=pw)  
		project = client.get(name=project_name)[0]
		project = client.change_path(project['project_id'])

		# get correlations to each topic
		result = project.put('topics/text_correlation', text=json_data['text'])
		topics = project.get('topics/')
		for key, value in result.iteritems():
			correlations.update({(t['name'], value) for t in topics if t['_id']==key})

	except KeyError:
		HttpResponseServerError('Malformed data')
	return HttpResponse(json.dumps(correlations))

def hello(request):
	html = '<html><body><h2>.../scores/   </h2>REST PUT or POST with text in the request Body<br>eg.<br>PUT http://ec2-54-186-59-57.us-west-2.compute.amazonaws.com/scores/<br>body:{"text":"The snow is falling in the North."}</body></html>'
	return HttpResponse(html)

