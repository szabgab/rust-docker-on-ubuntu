# Development

## Build the image

```
$ docker build . -t szabgab/rust
```

## Tag

```
$ docker tag mydocker:latest szabgab/rust:25.10.01
$ docker tag mydocker:latest szabgab/rust:latest
```

## Push

```
$ docker push szabgab/rust:25.10.01
$ docker push szabgab/rust:latest
```


