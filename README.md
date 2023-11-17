# README

HTML Renderer is a micro service to render HTML to image/pdf in container.

> Warning: This service can easy access host file, it should be deploy in a private environment and don't expose it to public network. Don't render untrusted URL or HTML content.

## Start service

```
docker run -p 3000:3000 --cap-add SYS_ADMIN ghcr.io/chloerei/htmlrenderer:master
```

## API

### /pdf

```
curl -X POST localhost:3000/pdf \
  -H "Content-Type: application/json" \
  -o file.pdf \
  -d '{
    "url": "https://google.com"
  }'
```

All options, see [PdfController::SCHEMA](app/controllers/screenshot_controller.rb) .


### /screenshot

```
curl -X POST localhost:3000/screenshot \
  -H "Content-Type: application/json" \
  -o screenshot.png \
  -d '{
    "url": "https://google.com"
  }'
```

All options, see [ScreenshotController::SCHEMA](app/controllers/screenshot_controller.rb) .

## Authentication

In production, it's recommended to set a access token to protect the service.

```
docker run -p 3000:3000 --cap-add SYS_ADMIN --env ACCESS_TOKEN=<token> httprenderer
```

Then you need to pass the access token in the request header:

```
curl -X POST localhost:3000/screenshot \
  -H "Authorization: Bearer <token>" \
  -d '{
    "url": "https://google.com"
  }'
```

## Lang

This service already install Noto CJK fonts. This font has variant languages support. Sometimes your need to set the lang to render the correct font.

When render HTML contet, add `lang` attribute to the `<html>` tag:

```
<html lang="zh-CN">
</html>
```

When render URL, add `Accept-Language` header to the request:

```
curl -X POST -d "url=https://google.com" -H "Accept-Language: zh-CN" -o image.png localhost:3000/images
```

But no all website set `lang` attribute correctly, you can download and modify HTML content before render.
