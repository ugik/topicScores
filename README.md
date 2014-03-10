### {url}/scores/   

REST PUT or POST with text in the request Body

#### examples:

(from browser plugin REST client)

	* PUT http://ec2-54-186-59-57.us-west-2.compute.amazonaws.com/scores/ 
request-body:{"text":"The snow is falling in the North."}

(from CURL)

	* curl -X POST -H "Content-Type: application/json" -d '{"text":"the marine mammals are in jeopardy"}' http://ec2-54-186-59-57.us-west-2.compute.amazonaws.com/scores/


