from django.conf.urls import patterns, include, url

urlpatterns = patterns('',
	url(r'^scores/$', 'topicScores.views.push'),
	url(r'^$', 'topicScores.views.hello'),
)


