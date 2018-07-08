build:
	GOOS=linux go build -ldflags "-s -w" -o main main.go
	zip main.zip main

deploy:
	aws lambda update-function-code \
	--function-name ${function} \
	--zip-file fileb://main.zip \
	--profile ${profile} \
	--region ${region}
