

# 빌드, 푸시 등
## 이미지 만들기
이미지는 아래와 같은 명령어로 만듭니다.
```
docker build -t teamcode/subversion:0.0.1 .
```
위와 같이 만들면 약 ``611MB`` 정도 크기로 이미지가 만들어집니다.

## 만든 이미지를 Docker Hub 에 Push 하기
만든 이미지를 Docker Hub 에 올리기 위해서는 아래와 같은 명령어를 사용합니다. Docker Hub 계정이 필요합니다.
```
docker push teamcode/subversion:0.0.1
```


# 실행, 중지 등 컨테이너 관리하기

## 컨네이너 중지하기
``docker-compse`` 로 중지합니다.
```
docker-compose stop
```
아래와 같이 ``docker`` 명령어로도 중지할 수 있습니다.
```
docker stop subversion
```

# Import
docker load < rightstack-subversion-0.1.tar.gz

docker-compose up -d

# Subversion 에 사용자 추가하기
teamcode/subverion 컨테이너는 Digest 인증을 사용합니다. 아래와 같이 설정합니다.

```
htdigest -c users.conf "Subversion Repository" lala
```

위 명령어는 새 파일을 생성하면서 ``lala`` 라는 사용자를 추가합니다. ``Subversion Repository`` 는 인증에 사용하는 Realm 입니다. 이 값이 변경되면 비밀번호를 변경해야 합니다. 만약 이미 있는 파일에 사용자를 추가하려면 ``-c`` 옵션을 제외하면 됩니다. 아래와 같이 말이죠.
```
htdigest users.conf "Subversion Repository" ryan
```
