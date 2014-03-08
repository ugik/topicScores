from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.http import HttpResponseRedirect, HttpResponseServerError
from django.core.context_processors import csrf

from django.views.decorators.csrf import csrf_exempt
from luminoso_api import LuminosoClient

import json

# get pw from hidden file, TBD: figure out how to get EC2 instance env variables set
pw = open('/home/ubuntu/.env', 'r').read()[:16]

@csrf_exempt
def push(request):
	correlations = {}
	data = 'None'
	json_data = json.loads(request.body)
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

