THRE=0.8

build:
	GOOS=linux go build -ldflags "-s -w -X main.threshold=${THRE}" -o main main.go
	zip main.zip main

deploy:
	aws lambda update-function-code \
	--function-name ${function} \
	--zip-file fileb://main.zip \
	--profile ${profile} \
	--region ${region}
