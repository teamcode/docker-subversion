## Dockerized Apache Subversion
이 프로젝트는 Apache Subversion 을 HTTPD 로 서비스하는 Docker Container 저장소입니다.
간편하고 빠르게 Subversion Server 를 구축하시려는 분들께 VisualSVN 말고도 선택지를 드리기 위해서
구성해 보았습니다.

Docker 에 대해서 이해가 조금 필요하기는 하지만 그다지 어렵지 않습니다. 하지만 여기서 Docker 에 대해서
설명을 생략하겠습니다.

## 컨테이너 이미지를 빌드하는 방법
### 이미지 만들기
이미지는 아래와 같은 명령어로 만듭니다.
```
docker build -t teamcode/subversion:0.0.2 .
```
위와 같이 만들면 약 ``611MB`` 정도 크기로 이미지가 만들어집니다.

### 만든 이미지를 Docker Hub 에 Push 하기
만든 이미지를 Docker Hub 에 올리기 위해서는 아래와 같은 명령어를 사용합니다. Docker Hub 계정이 필요합니다.
```
docker push teamcode/subversion:0.0.2
```


## 실행, 중지 등 컨테이너 관리하기
### 컨테이너 실행하기
컨테이너를 실행하기 전에 ``docker-compose.yml`` 파일을 열어서 아래와 같은 ``VOLUME`` 설정 부분을 수정해 줍니다.
```
- /home/subversion/config/httpd:/etc/httpd
- /home/subversion/data:/var/opt/subversion
- /home/subversion/logs/httpd:/var/log/httpd
```

위의 경로를 적절하게 변경해 줍니다. 각 ``VOLUME`` 의 의미는 경로 이름이 의미하는 바와 같습니다. 설정 완료 후에
아래와 같은 명령어로 컨테이너를 실행합니다.
```
docker-compose up -d
```

### 컨네이너 중지하기
``docker-compse`` 로 중지합니다.
```
docker-compose stop
```
아래와 같이 ``docker`` 명령어로도 중지할 수 있습니다.
```
docker stop subversion
```

### 로그 확인하기
뭔가 문제가 있는지 확인하고 싶다면 아래 명령어를 실행해 보세요.
```
docker-compose logs subversion
```

### 컨테이너 실행 시 문제가 있는 경우
컨테이너를 실행하지 못한 경우에는 어떤 문제가 있는지 모르기 때문에 직접 실행해서 내용을 살펴볼 필요가 있습니다.
아래와 같이 entrypoint 를 Override 할 수 있습니다.

```
docker run -ti --entrypoint=/bin/bash [이미지 아이디]
```



## 컨테이서 설정하기
### Subversion 에 사용자 추가하기
teamcode/subverion 컨테이너는 Digest 인증을 사용합니다. 아래와 같이 설정합니다.

```
htdigest -c users.conf "Subversion Repository" lala
```

위 명령어는 새 파일을 생성하면서 ``lala`` 라는 사용자를 추가합니다. ``Subversion Repository`` 는 인증에 사용하는 Realm 입니다. 이 값이 변경되면 비밀번호를 변경해야 합니다. 만약 이미 있는 파일에 사용자를 추가하려면 ``-c`` 옵션을 제외하면 됩니다. 아래와 같이 말이죠.
```
htdigest users.conf "Subversion Repository" ryan
```
##License
The Dockerized Apache Subversion is released under version 2.0 of the Apache License.
