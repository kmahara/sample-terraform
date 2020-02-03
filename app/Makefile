IMAGE_NAME=app_web
DEPLOYMENT=app1

push:
	./bin/push.sh
	
update:
	kubectl apply -f k8s

history:
	kubectl rollout history deployment ${DEPLOYMENT}

undo:
	kubectl rollout undo deployment ${DEPLOYMENT}
	
